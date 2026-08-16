/// Represents a single swipeable card inside the intro overlay
class IntroCardItem {
  final String title;
  final String description;
  final String imagePath; 

  const IntroCardItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

/// Holds all onboarding cards for a specific section
class SectionOnboardingConfig {
  final String sectionKey;
  final List<IntroCardItem> cards;

  const SectionOnboardingConfig({
    required this.sectionKey,
    required this.cards,
  });
}