import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'inner_studio_models.dart';
import 'package:cptsd_app/resources.dart'; 
import 'package:cptsd_app/main.dart'; 

// Stores the current progress information of the Inner Studio.
// This state controls sticker collection, progress display,
// and milestone reward notifications.
class StudioState {
  final int progressPoints;
  final int targetPoints;
  final int currentStickerIndex; 
  final bool showPlusOne; // Controls the temporary "+1" animation after collecting a reward
  // Stores all stickers unlocked by the user
  final List<UnlockedSticker> collectedStickers;
  // Message shown after successfully unlocking a sticker
  final String? congratulationsMessage; 
  // Stores the activity that triggered a milestone reward.
  // When available, it replaces normal progress rewards
  // and requires the user to collect the milestone sticker first.
  final String? pendingMilestoneActivityId;

  StudioState({
    required this.progressPoints,
    required this.targetPoints,
    required this.currentStickerIndex,
    this.showPlusOne = false,
    required this.collectedStickers,
    this.congratulationsMessage,
    this.pendingMilestoneActivityId,
  });

  // Converts current progress into a value between 0 and 1
  // for displaying progress bars
  double get percentage => (progressPoints / targetPoints).clamp(0.0, 1.0);
  
  // Determines whether the reward area is ready for collection.
  // A reward can be either a normal progression sticker
  // or a special milestone sticker.
  bool get isReady => pendingMilestoneActivityId != null || progressPoints >= targetPoints;
  
  // Checks whether the current available reward is a milestone sticker.
  bool get isShowingMilestone => pendingMilestoneActivityId != null;

  StudioState copyWith({
    int? progressPoints,
    int? targetPoints,
    int? currentStickerIndex,
    bool? showPlusOne,
    List<UnlockedSticker>? collectedStickers,
    String? congratulationsMessage,
    bool clearCongratulations = false,
    String? pendingMilestoneActivityId,
    bool clearMilestone = false,
  }) {
    return StudioState(
      progressPoints: progressPoints ?? this.progressPoints,
      targetPoints: targetPoints ?? this.targetPoints,
      currentStickerIndex: currentStickerIndex ?? this.currentStickerIndex,
      showPlusOne: showPlusOne ?? this.showPlusOne,
      collectedStickers: collectedStickers ?? this.collectedStickers,
      congratulationsMessage: clearCongratulations ? null : (congratulationsMessage ?? this.congratulationsMessage),
      pendingMilestoneActivityId: clearMilestone ? null : (pendingMilestoneActivityId ?? this.pendingMilestoneActivityId),
    );
  }
}

// Handles Inner Studio progression logic.
// This connects user activities from different tools
// with the gamification reward system
class StudioNotifier extends StateNotifier<StudioState> {
  // Local database instance used for storing progress
  // and unlocked stickers permanently
  final Isar _isar;
  final Random _random = Random();

  // Sticker categories used to distinguish different reward types
  static const String tagCustom = 'Custom';
  static const String tagMilestone = 'Milestone';
  static const String tagProgression = 'Progression';

  // Activity IDs used to identify different tools and activities
  // Activity IDs are used instead of UI names so that
  // internal tracking remains independent from displayed text.
  static const String actGuidedBreathing = 'guided_breathing';
  static const String actMeditation = 'meditation';
  static const String actGrounding54321 = 'grounding_54321';
  static const String actJournaling = 'journaling';
  static const String actReframeThought = 'reframe_thought';
  static const String actDecisionMaking = 'decision_making';
  static const String actWorryRelease = 'worry_release';
  static const String actInterpersonalSkills = 'interpersonal_skills';
  static const String actMoodTracker = 'mood_tracker';
  static const String actSosProtocol = 'sos_protocol';

  StudioNotifier(this._isar) : super(StudioState(progressPoints: 0, targetPoints: 100, currentStickerIndex: 0, collectedStickers: [])) {
    _initStudio();
  }

  // Sort stickers based on unlock time so the newest reward
  // appears first in the sticker collection
  List<UnlockedSticker> _getSortedList(List<UnlockedSticker> rawList) {
    final List<UnlockedSticker> sorted = List<UnlockedSticker>.from(rawList);
    sorted.sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
    return sorted;
  }

  // Loads existing progress from local storage when the app starts.
  // If no previous progress exists, a new progression state is created
  Future<void> _initStudio() async {
    final savedState = await _isar.studioStateDatas.where().findFirst();
    final allStickersRaw = await _isar.unlockedStickers.where().findAll();
    final allStickers = _getSortedList(allStickersRaw);

    if (savedState != null) {
      state = StudioState(
        progressPoints: savedState.currentProgressPoints,
        targetPoints: savedState.currentTargetPoints,
        currentStickerIndex: savedState.currentStickerIndex,
        collectedStickers: allStickers,
      );
    } else {
      final initialTarget = _random.nextInt(71) + 30; 
      final newStateData = StudioStateData()
        ..currentProgressPoints = 0
        ..currentTargetPoints = initialTarget
        ..currentStickerIndex = 0; 
      
      await _isar.writeTxn(() async {
        await _isar.studioStateDatas.put(newStateData);
      });
      state = state.copyWith(targetPoints: initialTarget, collectedStickers: allStickers);
    }
  }

  Future<bool> completeActivity(String activityId, [String uiToolName = ""]) async {
    final stateData = await _isar.studioStateDatas.where().findFirst() ?? StudioStateData();
    
    stateData.completedActivityKeys = List<String>.from(stateData.completedActivityKeys);
    stateData.completedActivityCounts = List<int>.from(stateData.completedActivityCounts);

    int index = stateData.completedActivityKeys.indexOf(activityId);
    int currentCount = index != -1 ? stateData.completedActivityCounts[index] : 0;
    
    const int fixedPointsEarned = 3; 
    int newProgress = stateData.currentProgressPoints + fixedPointsEarned;
    
    if (newProgress > stateData.currentTargetPoints) {
      newProgress = stateData.currentTargetPoints;
    }

    int updatedUseCount = currentCount + 1;
    if (index != -1) {
      stateData.completedActivityCounts[index] = updatedUseCount;
    } else {
      stateData.completedActivityKeys.add(activityId);
      stateData.completedActivityCounts.add(updatedUseCount);
    }

    stateData.currentProgressPoints = newProgress;
    
    // Calculate total practice count across all activities.
    // This value is used to provide feedback about overall engagement.
    int totalGlobalPractices = 0;
    for (var count in stateData.completedActivityCounts) {
      totalGlobalPractices += count;
    }

    // Debug information used during development to verify activity tracking and reward calculations
    debugPrint("📊 [STUDIO TRACKER] Activity: $activityId | Individual Count: $updatedUseCount | Total Count: $totalGlobalPractices | Current Points: $newProgress/${stateData.currentTargetPoints}");

    await _isar.writeTxn(() async {
      await _isar.studioStateDatas.put(stateData);
    });

    // After completing the same activity five times,
    // unlock a special milestone reward.
    if (updatedUseCount == 5) {
      // Set progress point state BUT also intercept workbench with the milestone activity payload
      state = state.copyWith(
        progressPoints: newProgress,
        pendingMilestoneActivityId: activityId,
      );
      return true; 
    }
    
    // Update normal progress when no milestone reward is triggered
    state = state.copyWith(progressPoints: newProgress);
    return false; 
  }

  // Handles reward collection after the user interacts
  // with the completed reward item in Inner Studio
  Future<void> handleWorkbenchCollection(String uiToolName) async {
    if (!state.isReady) return;

    if (state.isShowingMilestone) {
      await _collectMilestoneSticker(state.pendingMilestoneActivityId!, uiToolName);
    } else {
      await _collectProgressionSticker();
    }
  }

  Future<void> _collectMilestoneSticker(String activityId, String uiToolName) async {
    String stickerName = "";
    String toolReadableName = "";

    switch (activityId) {
      case actGuidedBreathing: stickerName = "Rhythm of Peace"; toolReadableName = "Guided Breathing"; break;
      case actMeditation: stickerName = "Meditation Master"; toolReadableName = "Meditation"; break;
      case actGrounding54321: stickerName = "Anchor of Calm"; toolReadableName = "5-4-3-2-1 Grounding"; break;
      case actJournaling: stickerName = "Insight Scribe"; toolReadableName = "Journaling"; break;
      case actReframeThought: stickerName = "Cognitive Architect"; toolReadableName = "Reframe Thought"; break;
      case actDecisionMaking: stickerName = "Clarity Finder"; toolReadableName = "Decision Making"; break;
      case actWorryRelease: stickerName = "Burden Dropper"; toolReadableName = "Worry Release"; break;
      case actInterpersonalSkills: stickerName = "Boundary Sculptor"; toolReadableName = "Interpersonal Skills"; break;
      case actMoodTracker: stickerName = "Self-Awareness Mirror"; toolReadableName = "Mood Tracker"; break;
      case actSosProtocol: stickerName = "Storm Anchor"; toolReadableName = "SOS Protocol"; break;
      default: return;
    }

    final String assetPath = AppImages.milestoneStickers[activityId] ?? AppImages.rewardStickers[0];

    final sticker = UnlockedSticker()
      ..name = stickerName
      ..imagePath = assetPath
      ..isCustom = false
      ..isMilestone = true
      ..tags = [tagMilestone]
      ..unlockedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.unlockedStickers.put(sticker);
    });
    
    final updatedListRaw = await _isar.unlockedStickers.where().findAll();
    final updatedList = _getSortedList(updatedListRaw);
    final finalToolName = uiToolName.isNotEmpty ? uiToolName : toolReadableName;

    // Remove the temporary milestone state after collection.
    // Normal progression rewards can still be available if progress is full
    state = state.copyWith(
      clearMilestone: true,
      collectedStickers: updatedList,
      congratulationsMessage: "You've unlocked this sticker by doing 5 times of $finalToolName! You are a master of it now.",
    );
  }

  Future<void> _collectProgressionSticker() async {
    final stateData = await _isar.studioStateDatas.where().findFirst() ?? StudioStateData();
    
    int totalGlobalPractices = 0;
    for (var count in stateData.completedActivityCounts) {
      totalGlobalPractices += count;
    }

  // Generate a new random target so users receive
  // different progression requirements after each reward.
    final nextTarget = _random.nextInt(71) + 30; 
    final nextStickerAssetIndex = (state.currentStickerIndex + 1) % AppImages.rewardStickers.length;
    final String assetPath = AppImages.rewardStickers[state.currentStickerIndex];
    
    final int stickerNumber = state.collectedStickers.length + 1;
    final String stickerName = "Souvenir #$stickerNumber";

    await _isar.writeTxn(() async {
      final sticker = UnlockedSticker()
        ..name = stickerName
        ..imagePath = assetPath
        ..isCustom = false
        ..isMilestone = false
        ..tags = [tagProgression]
        ..unlockedAt = DateTime.now();

      await _isar.unlockedStickers.put(sticker);

      final sd = await _isar.studioStateDatas.where().findFirst() ?? StudioStateData();
      sd.currentProgressPoints = 0; 
      sd.currentTargetPoints = nextTarget;
      sd.currentStickerIndex = nextStickerAssetIndex;
      await _isar.studioStateDatas.put(sd);
    });

    final updatedListRaw = await _isar.unlockedStickers.where().findAll();
    final updatedList = _getSortedList(updatedListRaw);

    state = state.copyWith(
      progressPoints: 0,
      targetPoints: nextTarget,
      currentStickerIndex: nextStickerAssetIndex,
      showPlusOne: true,
      collectedStickers: updatedList,
      congratulationsMessage: "You've unlocked this sticker with $totalGlobalPractices times of practices with our tools.",
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      state = state.copyWith(showPlusOne: false);
    });
  }

  // Allows external features such as achievements or special events
  // to manually add stickers into the collection.
  Future<void> awardSpecialSticker({
    required String name, 
    required String assetPath, 
    required List<String> tags,
    bool isMilestone = false,
    bool isCustom = false,
  }) async {
    final sticker = UnlockedSticker()
      ..name = name
      ..imagePath = assetPath
      ..isCustom = isCustom
      ..isMilestone = isMilestone
      ..tags = tags
      ..unlockedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.unlockedStickers.put(sticker);
    });
    
    final updatedListRaw = await _isar.unlockedStickers.where().findAll();
    state = state.copyWith(collectedStickers: _getSortedList(updatedListRaw));
  }

  // Removes a sticker from the collection and updates the UI state
  Future<void> deleteSticker(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.unlockedStickers.delete(id);
    });
    
    final updatedListRaw = await _isar.unlockedStickers.where().findAll();
    state = state.copyWith(collectedStickers: _getSortedList(updatedListRaw));
  }

  void clearCongratulationsMessage() {
    state = state.copyWith(clearCongratulations: true);
  }
}


final studioProvider = StateNotifierProvider<StudioNotifier, StudioState>((ref) {
  final isar = ref.watch(isarProvider); // Grabs the live database instance automatically
  return StudioNotifier(isar);
});