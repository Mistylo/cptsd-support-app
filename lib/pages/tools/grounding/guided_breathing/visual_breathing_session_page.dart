import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cptsd_app/resources.dart'; 
import 'package:cptsd_app/pages/sos_function/sos_protocol_page.dart';

// Provides the interactive visual breathing session interface
// The screen guides users through breathing rhythms using animated visual cues,
// optional ambient sounds, and customisable background settings
class VisualBreathingPage extends StatefulWidget {
  final String techniqueName;
  final Map<String, dynamic> techniqueData;

  const VisualBreathingPage({
    super.key, 
    required this.techniqueName, 
    required this.techniqueData
  });

  @override
  State<VisualBreathingPage> createState() => _VisualBreathingPageState();
}

class _VisualBreathingPageState extends State<VisualBreathingPage> with TickerProviderStateMixin {
  // Controls the breathing animation and current instruction displayed to the user
  // The animation expands and contracts to provide a visual pacing guide
  late AnimationController _haloController;
  String _currentAction = "GET READY";
  bool _isRunning = false;

  // Audio settings
  final AudioPlayer _ambientPlayer = AudioPlayer();
  String _selectedAmbient = "none";

  // Background settings
  String _selectedBgType = "color"; 
  Object _selectedBgValue = const Color(0xFF1E1E1E); 

  @override
  void initState() {
    super.initState();
    _haloController = AnimationController(
      vsync: this,
      lowerBound: 0.1, 
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _isRunning = false; 
    _haloController.dispose();
    _ambientPlayer.stop();
    _ambientPlayer.dispose();
    super.dispose();
  }

  // Controls the breathing exercise workflow
  // Different breathing techniques use different inhale, hold, and exhale timings,
  // which are represented through animation and instruction changes
  void _toggleSession() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _playAmbient();
        _runBreathingCycle();
      } else {
        _ambientPlayer.pause();
        _haloController.stop();
        _currentAction = "PAUSED";
      }
    });
  }

  Future<void> _runBreathingCycle() async {
    if (!_isRunning || !mounted) return;

    if (widget.techniqueName == "Physiological Sigh") {
      setState(() => _currentAction = "INHALE");
      await _haloController.animateTo(0.7, duration: const Duration(seconds: 2), curve: Curves.easeInOut);
      
      if (!_isRunning) return;
      setState(() => _currentAction = "TOP UP");
      await _haloController.animateTo(1.0, duration: const Duration(milliseconds: 800), curve: Curves.easeOut);
      
      if (!_isRunning) return;
      setState(() => _currentAction = "EXHALE");
      await _haloController.animateTo(0.1, duration: const Duration(seconds: 6), curve: Curves.easeInOut);

    } else if (widget.techniqueName == "Box Breathing") {
      setState(() => _currentAction = "INHALE");
      await _haloController.animateTo(1.0, duration: const Duration(seconds: 4), curve: Curves.easeInOut);
      
      if (!_isRunning) return;
      setState(() => _currentAction = "HOLD");
      await Future.delayed(const Duration(seconds: 4));
      
      if (!_isRunning) return;
      setState(() => _currentAction = "EXHALE");
      await _haloController.animateTo(0.1, duration: const Duration(seconds: 4), curve: Curves.easeInOut);
      
      if (!_isRunning) return;
      setState(() => _currentAction = "HOLD");
      await Future.delayed(const Duration(seconds: 4));

    } else { 
      // Extended Exhale
      setState(() => _currentAction = "INHALE");
      await _haloController.animateTo(1.0, duration: const Duration(seconds: 4), curve: Curves.easeInOut);
      
      if (!_isRunning) return;
      setState(() => _currentAction = "EXHALE");
      await _haloController.animateTo(0.1, duration: const Duration(seconds: 6), curve: Curves.easeInOut);
    }

    if (_isRunning) _runBreathingCycle();
  }

  // Audio playback

  void _playAmbient() async {
    if (_selectedAmbient == "none") {
      await _ambientPlayer.stop();
      return;
    }
    await _ambientPlayer.setReleaseMode(ReleaseMode.loop);
    await _ambientPlayer.play(AssetSource(_selectedAmbient));
  }

  void _previewAmbience(String path) async {
    if (path == "none") return;
    await _ambientPlayer.stop();
    await _ambientPlayer.play(AssetSource(path));
    await Future.delayed(const Duration(seconds: 3));
    if (!_isRunning) {
      await _ambientPlayer.stop();
    }
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
                _buildAnimatedHalo(),
                const SizedBox(height: 40),
                Text(
                  _currentAction,
                  style: const TextStyle(color: Colors.white, fontSize: 28, letterSpacing: 5, fontWeight: FontWeight.w300),
                ),
                const Spacer(),
                _buildInstructionCard(),
                const SizedBox(height: 40),
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
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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

  // Creates the animated visual breathing guide
  // The expanding and shrinking circle provides a simple pacing cue that users
  // can follow without reading instructions continuously
  Widget _buildAnimatedHalo() {
    return AnimatedBuilder(
      animation: _haloController,
      builder: (context, child) {
        return Container(
          width: 280,
          height: 280,
          alignment: Alignment.center,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white10)),
          child: Container(
            width: 100 + (150 * _haloController.value),
            height: 100 + (150 * _haloController.value),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3 * _haloController.value),
                  blurRadius: 30,
                  spreadRadius: 10 * _haloController.value,
                )
              ],
              color: Colors.white.withOpacity(0.1 * _haloController.value),
            ),
          ),
        );
      },
    );
  }

  // Displays the breathing technique instructions selected by the user
  Widget _buildInstructionCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        widget.techniqueData['instruction'] ?? "",
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
      ),
    );
  }

  Widget _buildControls() {
    return IconButton(
      icon: Icon(_isRunning ? Icons.pause_circle_filled : Icons.play_circle_filled, size: 90, color: Colors.white),
      onPressed: _toggleSession,
    );
  }


  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DefaultTabController(
              length: 2,
              child: SizedBox(
                height: 450,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.black,
                      tabs: [Tab(text: "Visuals"), Tab(text: "Ambience")],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildVisualsTab(setModalState),
                          _buildSelectionList(MeditationAssets.ambience, _selectedAmbient, (val) {
                            setState(() => _selectedAmbient = val);
                            setModalState(() {}); 
                            if (_isRunning) {
                              _playAmbient();
                            } else {
                              _previewAmbience(val);
                            }
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

  Widget _buildVisualsTab(StateSetter setModalState) {
    final colors = MeditationAssets.bgColors;
    final images = MeditationAssets.bgImages;
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 15),
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
              color: isColor ? colors[index] : Colors.grey[300],
              image: !isColor ? DecorationImage(image: AssetImage(images[index - colors.length]), fit: BoxFit.cover) : null,
              border: Border.all(color: Colors.black12, width: 2),
            ),
          ),
        );
      },
    );
  }
}