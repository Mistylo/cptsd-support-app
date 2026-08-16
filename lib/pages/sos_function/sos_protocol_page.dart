import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// SOS Protocol Main Flow
// Handles the overall emergency support sequence by guiding users through
// several grounding activities step by step
class SOSProtocolPage extends StatefulWidget {
  const SOSProtocolPage({super.key});

  @override
  State<SOSProtocolPage> createState() => _SOSProtocolPageState();
}

class _SOSProtocolPageState extends State<SOSProtocolPage> {
  int _currentStep = 0;

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  // Displays emergency support information and external crisis resources
  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 48),
        title: const Text(
          "Emergency Services",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "If you are in immediate physical danger, please contact local emergency responders or a crisis hotline immediately.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.white24),
            SizedBox(height: 10),
            ListTile(
              dense: true,
              leading: Icon(Icons.phone, color: Colors.redAccent),
              title: Text("Emergency Call", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text("Call 112 or 999", style: TextStyle(color: Colors.white54)),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.sms, color: Colors.redAccent),
              title: Text("Samaritans Ireland", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text("Call 116 123 (24/7)", style: TextStyle(color: Colors.white54)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close", style: TextStyle(color: Colors.white60)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("SOS Protocol", style: TextStyle(fontSize: 16, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildStepView(),
        ),
      ),
    );
  }

  Widget _buildStepView() {
    switch (_currentStep) {
      case 0:
        return _buildSafetyIntro();
      case 1:
        return SOSBreathingModule(onComplete: _nextStep);
      case 2:
        return SOSSensory54321Module(onComplete: _nextStep);
      case 3:
        return SOSGroundingGame(
          onComplete: _nextStep,
        );
      default:
        return _buildCompletionView();
    }
  }

  Widget _buildSafetyIntro() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "YOU ARE SAFE HERE",
              style: TextStyle(color: Color(0xFF8269A1), fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "What you are feeling right now is an echo of the past. Take a moment to ground yourself.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8269A1),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Begin Protocol", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: _showEmergencyDialog,
              icon: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 18),
              label: const Text(
                "Are you in physical danger?",
                style: TextStyle(color: Colors.redAccent, fontSize: 13, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: Colors.tealAccent, size: 64),
            const SizedBox(height: 24),
            const Text("Protocol Complete", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              "You handled that with strength. Feel your feet on the ground, and step back into your day whenever you feel ready",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 36),
            ElevatedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8269A1),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Return to App", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// 1. Paced Breathing Module
// Implements a simple breathing exercise using animation to guide users
// through controlled inhale and exhale cycles
class SOSBreathingModule extends StatefulWidget {
  final VoidCallback onComplete;
  const SOSBreathingModule({super.key, required this.onComplete});

  @override
  State<SOSBreathingModule> createState() => _SOSBreathingModuleState();
}

class _SOSBreathingModuleState extends State<SOSBreathingModule> with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _haloAnimation;
  String _breathLabel = "Inhale";
  int _completedCycles = 0;
  final int _targetCycles = 3;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _haloAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 100.0, end: 240.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 240.0, end: 100.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 60),
    ]).animate(_breathingController);

    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _completedCycles++;
        });
        if (_completedCycles < _targetCycles) {
          _breathingController.forward(from: 0.0);
        }
      }
    });

    _breathingController.addListener(() {
      final progress = _breathingController.value;
      if (progress < 0.4 && _breathLabel != "Inhale") {
        setState(() => _breathLabel = "Inhale");
      } else if (progress >= 0.4 && _breathLabel != "Exhale") {
        setState(() => _breathLabel = "Exhale");
      }
    });

    _breathingController.forward();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("PACED BREATHING (4-6 HARMONY)", style: TextStyle(color: Colors.white30, fontSize: 11, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Text(
            _breathLabel,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 48),
          SizedBox(
            height: 260,
            width: 260,
            child: Center(
              child: AnimatedBuilder(
                animation: _haloAnimation,
                builder: (context, child) {
                  return Container(
                    width: _haloAnimation.value,
                    height: _haloAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF8269A1).withOpacity(0.25),
                      border: Border.all(color: const Color(0xFF8269A1), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8269A1).withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 10,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            "Cycle Progress: $_completedCycles / $_targetCycles",
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 24),
          if (_completedCycles >= _targetCycles)
            ElevatedButton(
              onPressed: widget.onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8269A1),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Continue to Grounding", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}

// 2. 5-4-3-2-1 Sensory Grounding Module
// Guides users through a sensory awareness exercise to redirect attention
// towards the current environment
class SOSSensoryStage {
  final int count;
  final String title;
  final String subtitle;
  final IconData icon;

  const SOSSensoryStage({
    required this.count,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class SOSSensory54321Module extends StatefulWidget {
  final VoidCallback onComplete;
  const SOSSensory54321Module({super.key, required this.onComplete});

  @override
  State<SOSSensory54321Module> createState() => _SOSSensory54321ModuleState();
}

class _SOSSensory54321ModuleState extends State<SOSSensory54321Module> {
  final List<SOSSensoryStage> _stages = const [
    SOSSensoryStage(count: 5, title: "THINGS YOU SEE", subtitle: "Look around and tap 5 visual anchors", icon: Icons.visibility_outlined),
    SOSSensoryStage(count: 4, title: "THINGS YOU CAN TOUCH", subtitle: "Feel 4 physical textures near you", icon: Icons.back_hand_outlined),
    SOSSensoryStage(count: 3, title: "THINGS YOU HEAR", subtitle: "Listen carefully for 3 ambient sounds", icon: Icons.hearing_outlined),
    SOSSensoryStage(count: 2, title: "THINGS YOU CAN SMELL", subtitle: "Notice 2 scents in your environment", icon: Icons.air_outlined),
    SOSSensoryStage(count: 1, title: "THING YOU CAN TASTE", subtitle: "Acknowledge 1 taste or sensation", icon: Icons.restaurant_outlined),
  ];

  int _currentStageIndex = 0;
  late int _remainingTapsInStage;

  @override
  void initState() {
    super.initState();
    _remainingTapsInStage = _stages[0].count;
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    setState(() {
      if (_remainingTapsInStage > 1) {
        _remainingTapsInStage--;
      } else {
        if (_currentStageIndex < _stages.length - 1) {
          _currentStageIndex++;
          _remainingTapsInStage = _stages[_currentStageIndex].count;
        } else {
          widget.onComplete();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stage = _stages[_currentStageIndex];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "5-4-3-2-1 GROUNDING (${stage.count} OF ${_stages.length})",
              style: const TextStyle(color: Colors.white30, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              stage.title,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              stage.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 48),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: List.generate(_remainingTapsInStage, (index) {
                return GestureDetector(
                  onTap: _handleTap,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF8269A1).withOpacity(0.2),
                      border: Border.all(color: const Color(0xFF8269A1), width: 1.5),
                    ),
                    child: Icon(stage.icon, color: Colors.white, size: 26),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. Attention Based Grounding Mini Game
// Provides a simple interactive task designed to encourage concentration
// and shift attention away from distressing thoughts
class SOSGroundingGame extends StatefulWidget {
  final VoidCallback onComplete;

  const SOSGroundingGame({
    super.key,
    required this.onComplete,
  });

  @override
  State<SOSGroundingGame> createState() => _SOSGroundingGameState();
}

class _SOSGroundingGameState extends State<SOSGroundingGame> with SingleTickerProviderStateMixin {
  final List<IconData> _iconPool = const [
    Icons.crop_square,
    Icons.circle_outlined,
    Icons.change_history,
    Icons.star_border,
    Icons.hexagon_outlined,
    Icons.filter_hdr,
  ];

  late IconData _baseIcon;
  late IconData _targetIcon;
  int _targetIndex = 0;

  int _score = 0;
  int _currentRound = 0;
  final int _roundsPerBatch = 5;
  bool _showingBatchCompletionMenu = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);

    _generatePuzzle();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _generatePuzzle() {
    final random = Random();
    int firstChoice = random.nextInt(_iconPool.length);
    int secondChoice = (firstChoice + 1 + random.nextInt(_iconPool.length - 1)) % _iconPool.length;

    _baseIcon = _iconPool[firstChoice];
    _targetIcon = _iconPool[secondChoice];
    _targetIndex = random.nextInt(9);
    _showingBatchCompletionMenu = false;
  }

  void _handleCellTap(int idx) {
    if (_showingBatchCompletionMenu) return;

    if (idx == _targetIndex) {
      HapticFeedback.lightImpact();

      setState(() {
        _score++;
        _currentRound++;

        if (_currentRound >= _roundsPerBatch) {
          _showingBatchCompletionMenu = true;
        } else {
          _generatePuzzle();
        }
      });
    } else {
      HapticFeedback.vibrate();
      _shakeController.forward(from: 0.0);
    }
  }

  void _playAnotherBatch() {
    setState(() {
      _currentRound = 0;
      _generatePuzzle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "MIND TRACTION ATTENTION GAME",
              style: TextStyle(color: Colors.white30, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _showingBatchCompletionMenu
                  ? "Batch Focus Metrics Complete"
                  : "Find the odd shape out among the grid patterns",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 32),
            _showingBatchCompletionMenu
                ? _buildBatchCompletionWidget()
                : _buildGameMatrixGrid(),
            const SizedBox(height: 24),
            Text(
              "ROUND PROGRESSION: $_currentRound / $_roundsPerBatch",
              style: const TextStyle(color: Colors.white24, fontSize: 11, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameMatrixGrid() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, idx) {
          final bool isTarget = idx == _targetIndex;
          return InkWell(
            onTap: () => _handleCellTap(idx),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                border: Border.all(color: Colors.white12, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  isTarget ? _targetIcon : _baseIcon,
                  color: Colors.white60,
                  size: 28,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBatchCompletionWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.stars_rounded, color: Colors.tealAccent, size: 44),
        const SizedBox(height: 16),
        Text(
          "Successfully tracked $_score anomalies",
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _playAnotherBatch,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Play Another Round", style: TextStyle(color: Colors.white, fontSize: 13)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: widget.onComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 130, 105, 161),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Continue Protocol", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
          ],
        )
      ],
    );
  }
}