import 'package:flutter/material.dart';
import 'onboarding_model.dart';

class StaticIntroDialog extends StatefulWidget {
  final SectionOnboardingConfig config;

  // Called when the user skips or finishes the introduction.
  final VoidCallback onDismissed;

  const StaticIntroDialog({
    Key? key,
    required this.config,
    required this.onDismissed,
  }) : super(key: key);

  @override
  State<StaticIntroDialog> createState() => _StaticIntroDialogState();
}

class _StaticIntroDialogState extends State<StaticIntroDialog> {
  // Controls the onboarding pages.
  final PageController _pageController = PageController();

  // Keeps track of the current onboarding page.
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Moves to the next page or closes the introduction on the last page.
  void _onNext() {
    if (_currentIndex < widget.config.cards.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onDismissed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = widget.config.cards;
    final isLastPage = _currentIndex == cards.length - 1;

    return Dialog(
      // Keep the dialog appearance consistent across different themes.
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 480,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Displays each onboarding card as a separate page.
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: cards.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final card = cards[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Shows the illustration for the current page.
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            card.imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        card.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        card.description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Colors.grey[700],
                            ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Shows which onboarding page the user is currently viewing.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                cards.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Allows the user to close the introduction at any time.
                TextButton(
                  onPressed: widget.onDismissed,
                  child: const Text('Skip'),
                ),

                ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isLastPage ? 'Get Started' : 'Next',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}