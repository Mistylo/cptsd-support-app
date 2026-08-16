import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Haptic Feedback
import 'package:cptsd_app/resources.dart'; 
import 'package:audioplayers/audioplayers.dart';
import 'package:cptsd_app/pages/sos_function/sos_protocol_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This file implements the interactive 5-4-3-2-1 Grounding Exercise session page, 
//providing a sensory grounding activity designed to help users reconnect 
//with their immediate environment during moments of emotional distress
class GroundingSessionPage extends StatefulWidget {
  const GroundingSessionPage({super.key});

  @override
  State<GroundingSessionPage> createState() => _GroundingSessionPageState();
}

class _GroundingSessionPageState extends State<GroundingSessionPage> {
  // Tracks the current stage of the 5-4-3-2-1 grounding exercise.
  // Each stage corresponds to one sensory category:
  // See (5), Feel (4), Hear (3), Smell (2), Taste (1).
  int _currentStepIndex = 0; // 0 to 4 (See, Feel, Hear, Smell, Taste)

  final AudioPlayer _audioPlayer = AudioPlayer();
  // Tracks completion status of interactive grounding elements
  // within the current sensory stage.
  List<bool> _itemStatus = []; 

  // Controls optional audio feedback when users interact
  // with grounding objects. The preference is persisted locally
  bool _isSoundEnabled = true; 
  static const String _soundPreferenceKey = 'grounding_pop_sound_enabled';

  // Defines the sequence of the 5-4-3-2-1 sensory grounding exercise
  // Each step specifies the sensory category, required interactions,
  // visual style, and user instruction.
  final List<Map<String, dynamic>> _steps = [
    {"sense": "SEE", "count": 5, "instruction": "Name 5 things you see around you", "shape": "circle", "color": const Color.fromARGB(255, 95, 133, 163)},
    {"sense": "FEEL", "count": 4, "instruction": "Focus on 4 things you can feel", "shape": "square", "color": const Color.fromARGB(255, 98, 141, 99)},
    {"sense": "HEAR", "count": 3, "instruction": "Listen for 3 distinct sounds", "shape": "ring", "color": const Color.fromARGB(255, 228, 194, 143)},
    {"sense": "SMELL", "count": 2, "instruction": "Identify 2 things you can smell", "shape": "blob", "color": const Color.fromARGB(255, 146, 104, 153)},
    {"sense": "TASTE", "count": 1, "instruction": "Note 1 thing you can taste", "shape": "diamond", "color": const Color.fromARGB(255, 214, 129, 123)},
  ];

  @override
  void initState() {
    super.initState();
    _loadSoundPreference();
    _setupAudio();
    _initializeStep(0);
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Release the audio resource when leaving the page.
    super.dispose();
  }

 // Store the user's sound preference so it is remembered next time
  Future<void> _loadSoundPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isSoundEnabled = prefs.getBool(_soundPreferenceKey) ?? true;
      });
    } catch (e) {
      debugPrint("Failed to load preference cache: $e");
    }
  }

  Future<void> _toggleSoundPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isSoundEnabled = !_isSoundEnabled;
        prefs.setBool(_soundPreferenceKey, _isSoundEnabled);
      });
    } catch (e) {
      debugPrint("Failed to save preference cache: $e");
    }
  }

  void _setupAudio() async {
    try {
      await _audioPlayer.setSource(AssetSource('audio/pop.mp3'));
    } catch (e) {
      debugPrint("Audio setup error: $e");
    }
  }

  void _initializeStep(int stepIndex) {
    setState(() {
      _currentStepIndex = stepIndex;
      int count = _steps[stepIndex]['count'];
      _itemStatus = List.generate(count, (index) => false); 
    });
  }

  void _handleSpecificTap(int index) async {
    if (_itemStatus[index]) return; // Prevent duplicate interactions after an item has been completed

    // Provides immediate tactile feedback to reinforce interaction
    HapticFeedback.mediumImpact();
    
    // Play sound feedback only when the user enables audio feedback.
    if (_isSoundEnabled) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource('audio/pop.mp3'));
      } catch (e) {
        debugPrint("Audio execution error: $e");
      }
    }

    setState(() {
      _itemStatus[index] = true; 
    });

    if (_itemStatus.every((status) => status == true)) {
      _moveToNextStep();
    }
  }

  void _moveToNextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      // Adds a short transition delay to allow the completion animation
      // to finish before presenting the next sensory stage
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          _initializeStep(_currentStepIndex + 1);
        }
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _resetExercise() {
    setState(() {
      _currentStepIndex = 0;
      _initializeStep(0);
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Exercise Complete", style: TextStyle(color: Colors.white)),
        content: const Text(
          "How are you feeling? You can go through the steps again if you need more time to ground yourself.",
          style: TextStyle(color: Colors.white70),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetExercise();
            },
            child: const Text("I need to do this again", 
              style: TextStyle(color: Color.fromARGB(255, 149, 174, 218), fontWeight: FontWeight.bold)
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("I feel better / Finish", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildShapeGrid(Map<String, dynamic> step) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: List.generate(_itemStatus.length, (index) {
        return _getShapeWidget(index, _itemStatus[index], step['shape'], step['color']);
      }),
    );
  }

  Widget _getShapeWidget(int index, bool isPopped, String shape, Color color) {
    double size = 80;

    return GestureDetector(
      onTap: () => _handleSpecificTap(index),
      // Uses scale and opacity animations to create a disappearing
      // interaction effect when users complete each grounding item
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: isPopped ? 1.4 : 1.0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: isPopped ? 0.0 : 1.0,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: (shape == "circle" || shape == "ring") ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: shape == "square" ? BorderRadius.circular(20) : 
                            (shape == "blob" ? const BorderRadius.only(topLeft: Radius.circular(35), bottomRight: Radius.circular(35), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)) : null),
              gradient: RadialGradient(
                colors: [color.withOpacity(0.8), color.withOpacity(0.3)],
                center: const Alignment(-0.3, -0.3),
              ),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.3), blurRadius: 15, spreadRadius: 2)
              ],
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
            ),
            child: _getInnerTexture(shape),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white54),
            onPressed: () => Navigator.pop(context),
          ),
          
          // SOS BUTTON
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SOSProtocolPage())),
            child: SvgPicture.asset(AppIcons.sos, width: 45, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ),
          
          // Sound control
          IconButton(
            icon: Icon(
              _isSoundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: _isSoundEnabled ? Colors.white70 : Colors.white24,
            ),
            onPressed: _toggleSoundPreference,
          ),
        ],
      ),
    );
  }

  // Displays the user's progress through the five sensory stages
  Widget _buildProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length, (index) {
        bool isDone = index < _currentStepIndex;
        bool isCurrent = index == _currentStepIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: isDone ? Colors.blue : (isCurrent ? Colors.white : Colors.white10),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  Widget _getInnerTexture(String shape) {
    IconData icon;
    switch (shape) {
      case "circle": icon = Icons.blur_on; break;
      case "square": icon = Icons.texture; break;
      case "ring": icon = Icons.graphic_eq; break;
      case "blob": icon = Icons.cloud_queue; break;
      case "diamond": icon = Icons.restaurant_menu; break;
      default: icon = Icons.star;
    }
    return Center(child: Icon(icon, color: Colors.white24, size: 30));
  }

  @override
  Widget build(BuildContext context) {
    var currentStep = _steps[_currentStepIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildProgressBar(),
            const Spacer(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                currentStep['instruction'].toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w300, letterSpacing: 2),
              ),
            ),
            
            const Spacer(),
            _buildShapeGrid(currentStep),
            const Spacer(),
            
            const Text("TAP AFTER EACH ITEM", style: TextStyle(color: Colors.white24, letterSpacing: 2, fontSize: 12)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}