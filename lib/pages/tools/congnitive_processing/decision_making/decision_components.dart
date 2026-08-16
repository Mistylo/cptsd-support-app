import 'package:flutter/material.dart';


// This file contains reusable UI components for the trauma-informed
// decision reflection feature.

/// Displays the user's progress through the guided reflection workflow.
class DecisionStepHeader extends StatelessWidget {
  final int currentStep;
  final VoidCallback? onBack;

  const DecisionStepHeader({
    super.key,
    required this.currentStep,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (currentStep / 3).clamp(0.0, 1.0);

    // Main stages presented during the structured reflection process.
    final labels = [
      "1. Options",
      "2. Reflection",
      "3. Choice",
    ];

    return Column(
      children: [
        Row(
          children: [
            if (currentStep > 1)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: onBack,
              )
            else
              const SizedBox(width: 16),

            Text(
              labels[currentStep - 1],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),

            const Spacer(),

            Text(
              "Step $currentStep of 3",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(width: 16),
          ],
        ),

        const SizedBox(height: 6),

        LinearProgressIndicator(
          value: progress,
          minHeight: 4,
          backgroundColor: Colors.grey[200],
          valueColor:
              const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}


/// Provides a brief grounding reminder during the reflection process
class GroundingBanner extends StatelessWidget {
  const GroundingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.amber[200]!,
        ),
      ),

      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Colors.amber[800],
            size: 18,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              "Take a deep breath. Consider what matters most to you.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber[950],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// Input component for adding personally identified benefits and concerns
class FactorInputRow extends StatelessWidget {
  final TextEditingController controller;
  final bool isHighIntensity;
  final bool isPro;
  final VoidCallback onIntensityToggle;
  final VoidCallback onSubmitted;

  const FactorInputRow({
    super.key,
    required this.controller,
    required this.isHighIntensity,
    required this.isPro,
    required this.onIntensityToggle,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey[300]!,
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),

        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,

                decoration: InputDecoration(
                  hintText: isPro
                      ? "Add a benefit..."
                      : "Add a concern...",

                  border: InputBorder.none,

                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 13,
                  ),
                ),

                style: const TextStyle(
                  fontSize: 14,
                ),

                onSubmitted: (_) => onSubmitted(),
              ),
            ),


            IconButton(
              icon: Icon(
                isPro
                    ? Icons.local_fire_department
                    : Icons.gpp_bad,

                color: isHighIntensity
                    ? (isPro
                        ? Colors.orange[700]
                        : Colors.red[700])
                    : Colors.grey[300],
              ),

              // Allows users to mark factors that feel personally important.
              tooltip: isPro
                  ? "Mark as Important Benefit (🔥)"
                  : "Mark as Important Concern (🚨)",

              onPressed: onIntensityToggle,
            ),


            IconButton(
              icon: const Icon(
                Icons.add_circle,
                color: Colors.blueAccent,
              ),

              onPressed: onSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}


/// Highlights options that contain both meaningful benefits and concerns
class HighStakesConflictCard extends StatelessWidget {
  const HighStakesConflictCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(8),

        border: Border.all(
          color: Colors.purple[200]!,
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.purple[800],
            size: 22,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "IMPORTANT REFLECTION POINT",

                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[900],
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "This option contains both meaningful benefits and important concerns.\n"
                  "Consider what matters most to you and how you would respond to possible challenges.",

                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple[950],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}