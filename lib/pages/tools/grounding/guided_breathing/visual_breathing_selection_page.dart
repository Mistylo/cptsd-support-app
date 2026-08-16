import 'package:flutter/material.dart';
import 'visual_breathing_session_page.dart'; 

// Provides the selection interface for visual breathing exercises
// Users can choose from predefined breathing rhythms and enter an interactive
// breathing session based on the selected technique

class VisualBreathingSelectionPage extends StatelessWidget {
  const VisualBreathingSelectionPage({super.key});

  // Available visual breathing techniques
  static const Map<String, Map<String, dynamic>> visualTechniques = {
    "Extended Exhale": {
      "instruction": "Inhale for 4s • Exhale for 6s\nPerfect for calming the heart rate quickly.",
      "icon": Icons.air_rounded,
      "color": Color(0xFFB39DDB), // Lavender
    },
    "Box Breathing": {
      "instruction": "Inhale 4s • Hold 4s • Exhale 4s • Hold 4s\nResets the nervous system and improves focus.",
      "icon": Icons.grid_view_rounded,
      "color": Color(0xFF81C784), // Soft Green
    },
    "Physiological Sigh": {
      "instruction": "Double Inhale • Long Sigh Out\nThe fastest biological way to reduce anxiety.",
      "icon": Icons.waves_rounded,
      "color": Color(0xFF64B5F6), // Sky Blue
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), 
      appBar: AppBar(
        title: const Text("VISUAL BREATHING", style: TextStyle(letterSpacing: 2, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Choose a rhythm to follow",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: visualTechniques.length,
                itemBuilder: (context, index) {
                  String key = visualTechniques.keys.elementAt(index);
                  var data = visualTechniques[key]!;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VisualBreathingPage(
                              techniqueName: key,
                              techniqueData: data,
                            ),
                          ),
                        );
                      },
                      child: _buildTechniqueCard(key, data),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechniqueCard(String title, Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          // Technique icon
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: data['color'].withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(data['icon'], color: data['color'], size: 30),
          ),
          const SizedBox(width: 20),
          // Displays the technique name and short breathing instructions to help users
        // select an exercise before starting the session
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data['instruction'].split('\n')[0], 
                  style: TextStyle(color: data['color'].withOpacity(0.8), fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  data['instruction'].split('\n')[1], 
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 16),
        ],
      ),
    );
  }
}