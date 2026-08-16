import 'package:flutter/material.dart';

enum AppCanvasMode { defaultCloud, darkMidnight }

// Theme data for the Tool/Profile section
class ToolThemeData {
  final String accentName;       
  final AppCanvasMode themeMode; 

  const ToolThemeData({
    required this.accentName,
    required this.themeMode,
  });

  bool get isDarkMode => themeMode == AppCanvasMode.darkMidnight;

  Color get topColor => isDarkMode ? const Color(0xFF161920) : _getLightModeTopColor();
  Color get bottomColor => isDarkMode ? const Color(0xFF0F1115) : _getLightModeBottomColor();
  Color get cardColor => isDarkMode ? const Color(0xFF1F232C) : const Color(0xFFFDFDFE);
  Color get foregroundColor => isDarkMode ? const Color(0xFFF1F3F9) : const Color(0xFF1E2229);
  Color get subtitleColor => isDarkMode ? const Color(0xFF8A94A6) : const Color(0xFF626D7F);

  LinearGradient get backgroundGradient {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [topColor, bottomColor],
    );
  }

 // Accent colours used by common interface elements
// The selected colour depends on the user's chosen theme
  Color get accentColor {
    if (isDarkMode) {
      switch (accentName) {
        case "Lavender": return const Color(0xFFD3BADC); 
        case "Ocean":    return const Color(0xFF9AD1EC); 
        case "Rose":     return const Color(0xFFE8B2C3); 
        case "Forest":   return const Color(0xFF9CD1A6); 
        default:         return const Color(0xFFB0B8C4);
      }
    } else {
      switch (accentName) {
        case "Lavender": return const Color(0xFF8F6399); 
        case "Ocean":    return const Color(0xFF3B7DA3); 
        case "Rose":     return const Color(0xFFB55D7C); 
        case "Forest":   return const Color(0xFF3B6B4C); 
        default:         return const Color(0xFF5A6474);
      }
    }
  }

  // Colours used by common UI components
  Color get buttonTextColor {
    if (isDarkMode) {
      return const Color(0xFF0F1115);
    }
    return Colors.white;
  }
  Color get accentHighlightColor {
    return accentColor.withOpacity(0.12);
  }

  // Background colours for the light theme.
  Color _getLightModeTopColor() {
    switch (accentName) {
      case "Lavender": return const Color(0xFFF5EFFF); 
      case "Ocean":    return const Color(0xFFEFF7FA); 
      case "Rose":     return const Color(0xFFFFF0F3); 
      case "Forest":   return const Color(0xFFF2F7F4); 
      default:         return const Color(0xFFF8F9FA);
    }
  }

  Color _getLightModeBottomColor() {
    switch (accentName) {
      case "Lavender": return const Color(0xFFFAF8FF); 
      case "Ocean":    return const Color(0xFFF7FAFC);
      case "Rose":     return const Color(0xFFFFFAFB);
      case "Forest":   return const Color(0xFFFAFDFB);
      default:         return Colors.white;
    }
  }
}

// Icons used throughout the application
class AppIcons{
  static const String meditation = "assets/icons/icons_meditation.svg";
  static const String guidedBreathing = "assets/icons/icons_guidedbreathing.svg";
  static const String journaling = "assets/icons/icons_journaling.svg";
  static const String problemsovling = "assets/icons/icons_problemsovling.svg";
  static const String thoughtreframing = "assets/icons/icons_thoughtrefreming.svg";
  static const String fiveMiniDely = "assets/icons/icons_five_min_delay.svg";
  static const String fiveFour = "assets/icons/icons_5.svg";
  static const String recognizeEmotion = "assets/icons/icons_recognize_emotion.svg";
  static const String worryRelease = "assets/icons/icons_musle_relax.svg";
  static const String supportPlan = "assets/icons/support_plan.svg";
  static const String desisionMaking = "assets/icons/icons_decision_making.svg";
  static const String interpersonalSkills = "assets/icons/icons_skills.svg";
  static const String setting = "assets/icons/icons_cog.svg";
  static const String sos = "assets/icons/icons_sos.svg";
  static const String calendar = "assets/icons/icons_calendar.svg";
  static const String book = "assets/icons/icons_book.svg";
  static const String chat = "assets/icons/icons_chat.svg";
  static const String profile = "assets/icons/icons_profile.svg";
  static const String star = "assets/icons/icons_star.svg";
  static const String tool = "assets/icons/icons_tool.svg";
  static const String stickerBook = "assets/icons/icons_stickerbook.svg";
  static const String cognitiveProcessing = "assets/icons/cognitive_processing.svg";
  static const String emotionalAwareness = "assets/icons/emotional_awareness.svg";
  static const String emotionalRegulation = "assets/icons/emotional_regulation.svg";
  static const String grounding = "assets/icons/grounding.svg";

}

// Images used throughout the application
class AppImages{
  // Inner Studio basic images
  static const String workspace = "assets/images/inner_studio/workspace.png";
  static const String phase1 = "assets/images/inner_studio/phases/phase1.png";
  static const String phase2 = "assets/images/inner_studio/phases/phase2.png";
  static const String phase3 = "assets/images/inner_studio/phases/phase3.png";
  static const String phase4 = "assets/images/inner_studio/phases/phase4.png";
  static const String phase5 = "assets/images/inner_studio/phases/phase5.png";

  // Inner Studio reward stickers
  static const List<String> rewardStickers = [
    'assets/images/inner_studio/stickers/rewards/reward_1.png',
    'assets/images/inner_studio/stickers/rewards/reward_2.png',
    'assets/images/inner_studio/stickers/rewards/reward_3.png',
    'assets/images/inner_studio/stickers/rewards/reward_4.png',
    'assets/images/inner_studio/stickers/rewards/reward_5.png',
    'assets/images/inner_studio/stickers/rewards/reward_6.png',
    'assets/images/inner_studio/stickers/rewards/reward_7.png',
  ];

  // Inner Studio Milestone stickers
  static const Map<String, String> milestoneStickers = {
    'guided_breathing': 'assets/images/inner_studio/stickers/milestones/milestone_breathing.png',
    'meditation': 'assets/images/inner_studio/stickers/milestones/milestone_meditation.png',
    'grounding_54321': 'assets/images/inner_studio/stickers/milestones/milestone_grounding.png',
    'journaling': 'assets/images/inner_studio/stickers/milestones/milestone_journaling.png',
    'reframe_thought': 'assets/images/inner_studio/stickers/milestones/milestone_thought.png',
    'decision_making': 'assets/images/inner_studio/stickers/milestones/milestone_decision.png',
    'support_plan': 'assets/images/inner_studio/stickers/milestones/milestone_support.png', 
    'interpersonal_skills': 'assets/images/inner_studio/stickers/milestones/milestone_interpersonal.png',
    'worry_release': 'assets/images/inner_studio/stickers/milestones/milestone_release.png',
    'mood_tracker': 'assets/images/inner_studio/stickers/milestones/milestone_mood.png',
    'sos_protocol': 'assets/images/inner_studio/stickers/milestones/milestone_sos.png',
  };
}

class OnboardingImages {
   static const String tools_1 = 'assets/images/onboarding/onboarding_tools_1.png';
   static const String tools_2 = 'assets/images/onboarding/onboarding_tools_2.png';
   static const String tools_3 = 'assets/images/onboarding/onboarding_tools_3.png';
   static const String tools_4 = 'assets/images/onboarding/onboarding_tools_4.png';
   static const String studio_1 = 'assets/images/onboarding/onboarding_studio_1.png';
   static const String studio_2 = 'assets/images/onboarding/onboarding_studio_2.png';
   static const String studio_3 = 'assets/images/onboarding/onboarding_studio_3.png';
   static const String profile_1 = 'assets/images/onboarding/onboarding_profile_1.png';
   static const String profile_2 = 'assets/images/onboarding/onboarding_profile_2.png';
   static const String profile_3 = 'assets/images/onboarding/onboarding_profile_3.png';
   static const String education = 'assets/images/onboarding/onboarding_education.png';

}

// Assets used for Meditation
class MeditationAssets {

  // Background Colors
  static const List<Color> bgColors = [
    Color(0xFFDFD1F4), // Lavender
    Color(0xFFC5E5F3), // Ocean
    Color(0xFFF4D1DC), // Rose
    Color(0xFFF5F5F5), // Cloud
    Color(0xFFD5E8D4), // Forest
    Color(0xFF1E1E1E), // Midnight
  ];

  // Background Image
  static const List<String> bgImages = [
    "assets/images/meditation/meditation_forest.png",
    "assets/images/meditation/meditation_sunset.png",
    "assets/images/meditation/meditation_cityview.png",
  ];

  // Audio resources available during meditation sessions
  // These are predefined options rather than dynamically loaded content
  static const Map<String, String> ambience = {
    "None": "none",
    "Soft Rain": "audio/meditation/ambient/soft_rain.mp3", 
    "Rainforest": "audio/meditation/ambient/rain_forest.wav",
    "Ocean": "audio/meditation/ambient/ocean.wav",
    "Coffee Shop": "audio/meditation/ambient/coffeeshop.wav",
    "Summer Night": "audio/meditation/ambient/summer_night.mp3", 
    "Tibetan Singing Bowls": "audio/meditation/ambient/tibetan_sining_bowl.wav", 
  };

  // Ringtones
  static const Map<String, String> ringtones = {
    "Bright Digital Bell": "audio/meditation/ringtone/bright_digital_bell.mp3", 
    "Crisp Bell": "audio/meditation/ringtone/crisp_bell.mp3",
    "Gentle Clock": "audio/meditation/ringtone/wake_clock.mp3",
    "Short Gentle Bell": "audio/meditation/ringtone/gentel_bell.mp3", 
    "Soft and Soothing Bell": "audio/meditation/ringtone/soft_bell.mp3",
  };

  // Guided meditation
  static const Map<String, Map<String, dynamic>> guidedSessions = {
    "Soft Start": {
      "female": "audio/meditation/guided/basic_f.mp3",
      "male": "audio/meditation/guided/basic_m.mp3",
      "duration": 600, 
      "bgImage": "assets/images/meditation/soft_start_bg.png",
    },
    "Mountain": {
      "female": "audio/meditation/guided/mountain_f.mp3",
      "male": "audio/meditation/guided/mountain_m.mp3",
      "duration": 900, 
      "bgImage": "assets/images/meditation/mountain_bg.png",
    },
    "Quiet Presence": {
      "female": "audio/meditation/guided/longer_f.mp3",
      "male": "audio/meditation/guided/longer_m.mp3",
      "duration": 1200, 
      "bgImage": "assets/images/meditation/presence_bg.png",
    },
  };
}

// Assets used for Breathing
class BreathingAssets {
  // Audio guided breathing
  static const Map<String, Map<String, dynamic>> audioBreathing = {
    "Extended Exhale": {
      "female": "audio/breathing/extended_female.mp3",
      "male": "audio/breathing/extended_male.mp3",
      "duration": 180, 
      "bgImage": "assets/images/breathing/extended.png",
    },
    "Box Breathing": {
      "female": "audio/breathing/box_female.mp3",
      "male": "audio/breathing/box_male.mp3",
      "duration": 120, 
      "bgImage": "assets/images/breathing/box.png",
    },
    "Physiological Sigh": {
      "female": "audio/breathing/sigh_female.mp3",
      "male": "audio/breathing/sigh_male.mp3",
      "duration": 120, 
      "bgImage": "assets/images/breathing/sigh.png",
    },
  };

  // Visual guided breathing (Animation Rythem)
  static const Map<String, Map<String, dynamic>> visualBreathing = {
    "Extended Exhale": {
      "inhale": 4,
      "exhale": 6,
      "description": "Slows the heart rate.",
      "color": Color(0xFFB39DDB), 
    },
    "Box Breathing": {
      "inhale": 4,
      "hold": 4,
      "exhale": 4,
      "holdAfter": 4,
      "description": "Resets the nervous system.",
      "color": Color(0xFF81C784),
    },
    "Physiological Sigh": {
      "inhale": 2,      
      "topUp": 1,      
      "exhale": 6,     
      "description": "Instant anxiety relief.",
      "color": Color(0xFF64B5F6), 
    },
  };
}

// Tool Categories used throughout the application
class ToolCategory {
  final String title;
  final String icon; 
  final List<String> toolIds; 

  ToolCategory({required this.title, required this.icon, required this.toolIds});

final List<ToolCategory> appCategories = [
  ToolCategory(
    title: "Grounding",
    icon: AppIcons.grounding, 
    toolIds: ["Guided Breathing", "Meditation", "5-4-3-2-1 Grounding"],
  ),
  ToolCategory(
    title: "Emotional Awareness",
    icon: AppIcons.emotionalAwareness,
    toolIds: ["Journaling"],
  ),
  ToolCategory(
    title: "Cognitive Processing",
    icon: AppIcons.cognitiveProcessing,
    toolIds: ["Reframe Thought", "Decision Making"],
  ),
  ToolCategory(
    title: "Emotional Regulation",
    icon: AppIcons.emotionalRegulation,
    toolIds: ["Worry Release"],
  ),
];
}
