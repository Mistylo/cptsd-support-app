import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cptsd_app/resources.dart';
import "package:cptsd_app/pages/sos_function/sos_protocol_page.dart";

// Provides the interactive session interface for audio-guided breathing exercises
// The user follows a selected breathing technique through audio guidance,
// session timing, and customisable visual settings.
class AudioGuidedSessionPage extends StatefulWidget {
  final String title;
  final Map<String, dynamic> sessionData;

  const AudioGuidedSessionPage({
    super.key, 
    required this.title, 
    required this.sessionData
  });

  @override
  State<AudioGuidedSessionPage> createState() => _AudioGuidedSessionPageState();
}

class _AudioGuidedSessionPageState extends State<AudioGuidedSessionPage> {
  // Stores the current breathing session progress, including remaining time
// and whether the session is actively running.
  late int _secondsRemaining;
  bool _isRunning = false;
  Timer? _timer;

  // Controls playback of the guided breathing audio.
  // The user can choose between different recorded voice options.
  final AudioPlayer _voicePlayer = AudioPlayer(); 
  String _selectedVoice = "female"; 

  // Background settings
  String _selectedBgType = "image";
  late Object _selectedBgValue;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.sessionData['duration'];
    _selectedBgValue = widget.sessionData['bgImage'];
  }

  @override
  void dispose() {
    _timer?.cancel();      // Stops active session processes when the user leaves the page
    _voicePlayer.stop();  
    _voicePlayer.dispose();
    super.dispose();
  }

  // Handles session control, including timer updates, audio playback and completion behaviour

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        _timer?.cancel();
        _voicePlayer.pause();
      } else {
        _startTimer();
        _playVoice();
      }
      _isRunning = !_isRunning;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _completeSession();
      }
    });
  }

 void _playVoice() async {
  String path = widget.sessionData[_selectedVoice];
  
  try {
    await _voicePlayer.stop();
    await _voicePlayer.play(AssetSource(path));
  } catch (e) {
    debugPrint("Unable to play audio: $e");
  }
}

  void _completeSession() {
    _timer?.cancel();
    _voicePlayer.stop();
    setState(() {
      _isRunning = false;
      _secondsRemaining = widget.sessionData['duration']; // Reset for next time
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                _buildSessionInfo(),
                const Spacer(),
                _buildControls(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    if (_selectedBgType == "image") {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_selectedBgValue as String),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(color: Colors.black.withOpacity(0.4)),
      );
    } else {
      return Container(color: _selectedBgValue as Color);
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.sos, 
              width: 36, 
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SOSProtocolPage())),
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 30),
            onPressed: () => _showSettingsMenu(),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionInfo() {
    String minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    String seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return Column(
      children: [
        Text(widget.title.toUpperCase(), style: const TextStyle(color: Colors.white70, letterSpacing: 4, fontSize: 14)),
        const SizedBox(height: 10),
        Text("$minutes:$seconds", style: const TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.w200)),
      ],
    );
  }

 Widget _buildControls() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(width: 70), 

      // Play/pause button
      IconButton(
        icon: Icon(
          _isRunning ? Icons.pause_circle_filled : Icons.play_circle_filled, 
          size: 90, 
          color: Colors.white,
        ),
        onPressed: _toggleTimer,
      ),

      const SizedBox(width: 30),

      // Restart button
      IconButton(
        icon: const Icon(Icons.replay_rounded, color: Colors.white70, size: 40),
        onPressed: () {
          setState(() {
            _timer?.cancel();
            _secondsRemaining = widget.sessionData['duration']; // Reset to initial time
            _isRunning = false;
            _voicePlayer.stop();
          });
        },
      ),
    ],
  );
}

  // Provides user customisation options for voice selection and visual appearance
  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DefaultTabController(
              length: 2, // Only Voice and Visuals
              child: SizedBox(
                height: 400,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.black,
                      indicatorColor: Colors.black,
                      tabs: [Tab(text: "Voice"), Tab(text: "Visuals")],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildVoiceTab(setModalState),
                          _buildVisualsTab(setModalState),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVoiceTab(StateSetter setModalState) {
    return Column(
      children: [
        ListTile(
          title: const Text("Female Guide"),
          trailing: _selectedVoice == "female" ? const Icon(Icons.check, color: Colors.green) : null,
          onTap: () {
            setState(() {
              _selectedVoice = "female"; 
              
              // Switch to the selected voice immediately if the session is running.
              if (_isRunning) {
                _voicePlayer.stop(); 
                _playVoice(); 
              }
            });
            setModalState(() {});
          },
        ),
        ListTile(
          title: const Text("Male Guide"),
          trailing: _selectedVoice == "male" ? const Icon(Icons.check, color: Colors.green) : null,
          onTap: () {
            setState(() {
              _selectedVoice = "male"; 
          
              if (_isRunning) {
                _voicePlayer.stop(); 
                _playVoice(); // This starts the new voice file
              }
            });
            setModalState(() {});
          },
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Voice change will take effect next time you press play.", style: TextStyle(color: Colors.grey, fontSize: 12)),
        )
      ],
    );
  }

  Widget _buildVisualsTab(StateSetter setModalState) {
    final colors = MeditationAssets.bgColors;
    final images = MeditationAssets.bgImages;

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 15,
      ),
      itemCount: colors.length + images.length,
      itemBuilder: (context, index) {
        bool isColor = index < colors.length;
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isColor) {
                _selectedBgType = "color";
                _selectedBgValue = colors[index];
              } else {
                _selectedBgType = "image";
                _selectedBgValue = images[index - colors.length];
              }
            });
            setModalState(() {}); 
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isColor ? colors[index] : Colors.grey[200],
              image: !isColor ? DecorationImage(image: AssetImage(images[index - colors.length]), fit: BoxFit.cover) : null,
              border: Border.all(color: Colors.black12, width: 2),
            ),
          ),
        );
      },
    );
  }

  
}