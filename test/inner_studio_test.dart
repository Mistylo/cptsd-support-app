import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:cptsd_app/pages/inner_studio/inner_studio_provider.dart';
import 'package:cptsd_app/pages/inner_studio/inner_studio_models.dart';

void main() {
  late Isar isar;
  late StudioNotifier notifier;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);
    final tempDir = await Directory.systemTemp.createTemp('isar_test');
    
    isar = await Isar.open(
      [StudioStateDataSchema, UnlockedStickerSchema],
      directory: tempDir.path,
    );
    
    notifier = StudioNotifier(isar);
  });

  tearDown(() async {
    await isar.close();
  });

  test('Completing an activity 5 times unlocks a Milestone sticker', () async {
    const String toolId = StudioNotifier.actGuidedBreathing;

    for (int i = 0; i < 5; i++) {
      await notifier.completeActivity(toolId, "Guided Breathing");
    }

    final stickers = await isar.unlockedStickers.where().findAll();
    final milestoneSticker = stickers.firstWhere((s) => s.isMilestone);

    expect(milestoneSticker.isMilestone, isTrue);
    expect(milestoneSticker.name, equals("Rhythm of Peace"));
  });

  test('Accumulating points up to target unlocks a Progression/Reward sticker', () async {
    // 1. Force the database state to have a known target (e.g., 60 points) 
    // so we can test the loop reliably without random target interference.
    await isar.writeTxn(() async {
      final stateData = await isar.studioStateDatas.where().findFirst() ?? StudioStateData();
      stateData.currentTargetPoints = 60;
      stateData.currentProgressPoints = 0;
      await isar.studioStateDatas.put(stateData);
    });

    // Re-read or trigger initialization sync if your state depends on it
    // Complete an activity 3 times (3 * 20 points = 60 points)
    // Use an unmapped action ID so it doesn't trigger any 5x tool milestones
    for (int i = 0; i < 3; i++) {
      await notifier.completeActivity("pure_points_test_action");
    }

    // 2. Query Isar database to ensure a background reward sticker was generated
    final stickers = await isar.unlockedStickers.where().findAll();
    final rewardSticker = stickers.firstWhere((s) => !s.isMilestone);

    expect(rewardSticker.isMilestone, isFalse);
    expect(rewardSticker.tags.contains(StudioNotifier.tagProgression), isTrue);
    expect(rewardSticker.name, startsWith("Souvenir #"));
  });
}