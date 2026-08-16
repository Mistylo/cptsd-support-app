import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cptsd_app/resources.dart'; 
import 'package:cptsd_app/pages/sos_function/sos_protocol_page.dart'; 

// Meditation sessions provide unguided relaxation exercises
// Users can customise session duration, background visuals and audio preferences.
// This prototype uses predefined local resources to demonstrate interaction design
// and personalisation concepts within a trauma-informed application.

class UnguidedSessionPage extends StatefulWidget {
  const UnguidedSessionPage({super.key});

  @override
  State<UnguidedSessionPage> createState() => _UnguidedSessionPageState();
}

class _UnguidedSessionPageState extends State<UnguidedSessionPage> {
  // Stores the current meditation session state, including timer duration and playback status
  int _secondsRemaining = 600; 
  int _initialDuration = 600;
  bool _isRunning = false;
  Timer? _timer;
  
  // Tracks the user's selected ambient sound and completion ringtone
  final AudioPlayer _ambientPlayer = AudioPlayer();
  final AudioPlayer _ringtonePlayer = AudioPlayer();
  String _selectedAmbient = "none";
  String _selectedRingtone = "Bright Digital Bell";

  // Stores the user's selected meditation background, which can be either a colour or an image
  String _selectedBgType = "color"; 
  // Default background for the session
  Object _selectedBgValue = const Color(0xFF1E1E1E); 

  @override
  void dispose() {
    _timer?.cancel();
    _ambientPlayer.stop();
    _ambientPlayer.dispose();
    _ringtonePlayer.stop();
    _ringtonePlayer.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        _timer?.cancel();
        _ambientPlayer.pause();
      } else {
        _startTimer();
        _playAmbient(); 
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

  void _completeSession() {
    _timer?.cancel();
    _ambientPlayer.stop();
    _ringtonePlayer.play(AssetSource(_selectedRingtone));
    setState(() => _isRunning = false);
  }

  void _playAmbient() async {
    if (_selectedAmbient == "none") {
      await _ambientPlayer.stop();
      return;
    }
    await _ambientPlayer.setReleaseMode(ReleaseMode.loop);
    await _ambientPlayer.play(AssetSource(_selectedAmbient));
  }

  void _previewRingtone(String path) async {
    await _ringtonePlayer.stop();
    await _ringtonePlayer.play(AssetSource(path));
  }

  void _previewAmbience(String path) async {
    if (path == "none") return;
    
    // Stop any current preview or running ambient sound
    await _ambientPlayer.stop();
    
    // Play the selected sound
    await _ambientPlayer.play(AssetSource(path));
    
    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    
    if (!_isRunning) {
      await _ambientPlayer.stop();
    }
  }

  // Builds the main meditation interface and its supporting UI components.

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
                _buildTimerDisplay(),
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
          onError: (exception, stackTrace) {
            debugPrint('Main background failed to load: $exception');
          },
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
            onPressed: () {
              _timer?.cancel();
              _ambientPlayer.stop();
              _ringtonePlayer.stop();
              Navigator.pop(context);
            },
          ),
          // Provides quick access to the SOS support page 
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.sos, 
              width: 36,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const SOSProtocolPage())
            ),
          ),
          // Opens the session settings, allowing the user to customise the meditation experience
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 30),
            onPressed: () => _showSettingsMenu(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay() {
    String minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    String seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return Column(
      children: [
        Text(
          "$minutes:$seconds",
          style: const TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.w200),
        ),
        const Text("STAY PRESENT", style: TextStyle(color: Colors.white70, letterSpacing: 4)),
      ],
    );
  }

 void _setTime(int mins) {
    setState(() {
      _initialDuration = mins * 60; 
      _secondsRemaining = _initialDuration;
      _isRunning = false;
      _timer?.cancel();
      _ambientPlayer.stop(); 
    });
  }

void _restartSession() {
    setState(() {
      _timer?.cancel();
      _secondsRemaining = _initialDuration; 
      _isRunning = false;
      _ambientPlayer.stop();
    });
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 70), 

        // PLAY/PAUSE
        IconButton(
          icon: Icon(
            _isRunning ? Icons.pause_circle_filled : Icons.play_circle_filled, 
            size: 90, 
            color: Colors.white,
          ),
          onPressed: _toggleTimer,
        ),

        const SizedBox(width: 30),
        IconButton(
          icon: const Icon(Icons.replay_rounded, color: Colors.white70, size: 40),
          onPressed: _restartSession,
        ),
      ],
    );
  }

  // Displays configurable session options, including duration, background, ambient audio and completion ringtone

  void _showSettingsMenu() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return DefaultTabController(
            length: 4, 
            child: SizedBox(
              height: 500,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    isScrollable: true,
                    tabs: [
                      Tab(text: "Duration"),
                      Tab(text: "Visuals"),
                      Tab(text: "Ambience"),
                      Tab(text: "Ringtone"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab 1: DurationU
                        ListView(
                          children: [1, 5, 10, 15, 20, 30].map((int mins) {
                            return ListTile(
                              title: Text("$mins Minutes"),
                              trailing: (_secondsRemaining == mins * 60) 
                                  ? const Icon(Icons.check, color: Colors.green) : null,
                              onTap: () {
                                _setTime(mins);
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                        ),

                        // Tab 2: Visuals
                        _buildVisualsTab(setModalState),

                        // Tab 3: Ambience
                        _buildSelectionList(MeditationAssets.ambience, _selectedAmbient, (val) {
                          setState(() => _selectedAmbient = val);
                          setModalState(() {}); 
                          
                          // If the timer is running, play it for real (looping)
                          // If the timer is NOT running, just give a 3 second preview
                          if (_isRunning) {
                            _playAmbient();
                          } else {
                            _previewAmbience(val);
                          }
                        }),

                        // Tab 4: Ringtone
                        _buildSelectionList(MeditationAssets.ringtones, _selectedRingtone, (val) {
                          setState(() => _selectedRingtone = val);
                          setModalState(() {}); // Refresh the checkmark in the menu
                          _previewRingtone(val);
                        }),
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

Widget _buildVisualsTab(StateSetter setModalState) {
  final colors = MeditationAssets.bgColors;
  final imagePaths = MeditationAssets.bgImages;

  return GridView.builder(
    padding: const EdgeInsets.all(20),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 15,
    ),
    itemCount: colors.length + imagePaths.length,
    itemBuilder: (context, index) {
      bool isColor = index < colors.length;
      
      final int imageIndex = index - colors.length;
      final String currentImagePath = !isColor ? imagePaths[imageIndex] : "";

      return GestureDetector(
        onTap: () {
          setState(() {
            if (isColor) {
              _selectedBgType = "color";
              _selectedBgValue = colors[index];
            } else {
              _selectedBgType = "image";
              _selectedBgValue = currentImagePath;
            }
          });
          setModalState(() {}); 
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isColor ? colors[index] : Colors.grey[300],
            image: !isColor && currentImagePath.isNotEmpty ? DecorationImage(
              image: AssetImage(currentImagePath), 
              fit: BoxFit.cover,
              onError: (exception, stackTrace) {
                debugPrint('Failed to load asset circle preview: $exception');
              },
            ) : null,
            border: Border.all(
              color: (_selectedBgValue == (isColor ? colors[index] : currentImagePath))
                  ? Colors.black
                  : Colors.black12, 
              width: 2,
            ),
          ),
        ),
      );
    },
  );
}

  Widget _buildSelectionList(Map<String, String> data, String current, Function(String) onSelect) {
    return ListView(
      children: data.entries.map((entry) {
        final isSelected = entry.value == current;
        return ListTile(
          title: Text(entry.key, style: TextStyle(color: isSelected ? Colors.blue : Colors.black)),
          trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
          onTap: () => onSelect(entry.value),
        );
      }).toList(),
    );
  }
}