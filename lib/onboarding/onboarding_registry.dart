import 'onboarding_model.dart';
import 'package:cptsd_app/resources.dart';

class OnboardingRegistry {
  // Keys used to save and load the onboarding status.
  static const String keyTools = 'onboarding_tools';
  static const String keyProfile = 'onboarding_profile';
  static const String keyInnerStudio = 'onboarding_inner_studio';
  static const String keyEducation = 'onboarding_education';

  // Stores the onboarding cards for each main section.
  static const Map<String, SectionOnboardingConfig> _configs = {
    keyTools: SectionOnboardingConfig(
      sectionKey: keyTools,
      cards: [
        IntroCardItem(
          title: 'Welcome to Tools',
          description:
              'Explore four groups of tools: Grounding, Emotional Awareness, Cognitive Processing, and Emotional Regulation. Use them whenever you need some support.',
          imagePath: OnboardingImages.tools_1,
        ),
        IntroCardItem(
          title: '1-Tap SOS Protocol',
          description:
              'Feeling overwhelmed or panicked? Tap the SOS button at the top to start a guided grounding exercise.',
          imagePath: OnboardingImages.tools_2,
        ),
        IntroCardItem(
          title: 'Mood Tracker',
          description:
              'Tap the calendar icon in the top-left corner to record your mood and look back at your mood patterns over time.',
          imagePath: OnboardingImages.tools_3,
        ),
        IntroCardItem(
          title: 'Personalise Your Tools',
          description:
              'Tap the gear icon in the top-right corner to pin or hide tools, change tool icons, choose a background, and change the layout.',
          imagePath: OnboardingImages.tools_4,
        ),
      ],
    ),

    // Profile section
    keyProfile: SectionOnboardingConfig(
      sectionKey: keyProfile,
      cards: [
        IntroCardItem(
          title: 'Your Profile',
          description:
              'View your progress, change your username and avatar, manage your preferences, and adjust notifications.',
          imagePath: OnboardingImages.profile_1,
        ),
        IntroCardItem(
          title: 'Local & Google Drive Backup',
          description:
              'Your data is stored on your phone by default. You can also back it up to your own Google Drive when you need to.',
          imagePath: OnboardingImages.profile_2,
        ),
        IntroCardItem(
          title: 'App PIN Lock',
          description:
              'Add a PIN to help keep your personal data and app content private.',
          imagePath: OnboardingImages.profile_3,
        ),
      ],
    ),

    // Inner Studio section
    keyInnerStudio: SectionOnboardingConfig(
      sectionKey: keyInnerStudio,
      cards: [
        IntroCardItem(
          title: 'Collect Progress Stickers',
          description:
              'Complete activities in the Tools section to unlock new stickers. Come back to see what you have unlocked.',
          imagePath: OnboardingImages.studio_1,
        ),
        IntroCardItem(
          title: 'Your Sticker Book',
          description:
              'Tap the Sticker Book icon in the top-left corner to see and organise your sticker collection.',
          imagePath: OnboardingImages.studio_2,
        ),
        IntroCardItem(
          title: 'Custom Stickers & Playground',
          description:
              'Tap the customisation icon in the top-right corner to add your own stickers and arrange your space.',
          imagePath: OnboardingImages.studio_3,
        ),
      ],
    ),

    // Education section
    keyEducation: SectionOnboardingConfig(
      sectionKey: keyEducation,
      cards: [
        IntroCardItem(
          title: 'Learn at Your Own Pace',
          description:
              'Explore trauma-informed articles to learn more about your nervous system, emotions, and self-help strategies.',
          imagePath: OnboardingImages.education,
        ),
      ],
    ),
  };

  // Gets the onboarding content for a specific section.
  static SectionOnboardingConfig? getConfig(String key) {
    return _configs[key];
  }
}