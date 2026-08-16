import 'package:flutter/material.dart';
import 'package:cptsd_app/resources.dart'; 
import 'audio_breathing_session_page.dart'; 

// Provides the selection interface for audio guided breathing exercises
// Users can choose a predefined breathing technique before starting a session
// with audio guidance and visual support
class AudioGuidedSelectionPage extends StatelessWidget {
  const  AudioGuidedSelectionPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Audio Guided Breathing", style: TextStyle(letterSpacing: 2, fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Loads predefined breathing sessions from the shared resources file
    // Keeping session metadata separate from the UI allows new exercises to be added
    // without modifying the selection interface.
      body: Column(
        children: BreathingAssets.audioBreathing.entries.map((entry) {
          final session = entry.value;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioGuidedSessionPage(
                      title: entry.key,
                      sessionData: session,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: AssetImage(session['bgImage']),
                    fit: BoxFit.cover,
                    // Darkens the background image to improve text readability.
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
                        "${session['duration'] ~/ 60} MINUTES",
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