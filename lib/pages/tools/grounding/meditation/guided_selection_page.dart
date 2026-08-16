import 'package:flutter/material.dart';
import 'package:cptsd_app/resources.dart'; 
import 'guided_session_page.dart';

// Meditation selection sessions provide 3 different guided exercises

class GuidedSelectionPage extends StatelessWidget {
  const GuidedSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("GUIDED MEDITATION", style: TextStyle(letterSpacing: 2, fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: MeditationAssets.guidedSessions.entries.map((entry) {
          final data = entry.value;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuidedSessionPage(
                      title: entry.key,
                      sessionData: data,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: AssetImage(data['bgImage']),
                    fit: BoxFit.cover,
                    // Apply a dark overlay to improve text readability while preserving the background image
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.darken),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        entry.key.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${data['duration'] ~/ 60} MINUTES",
                        style: const TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}