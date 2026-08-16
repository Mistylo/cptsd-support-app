import 'package:flutter/material.dart';
import 'security_service.dart';

class PinLockPage extends StatefulWidget {
  final Widget childOnUnlock;  // Screen shown after the PIN is entered correctly

  const PinLockPage({super.key, required this.childOnUnlock});

  @override
  State<PinLockPage> createState() => _PinLockPageState();
}

class _PinLockPageState extends State<PinLockPage> with SingleTickerProviderStateMixin {
  late SecurityService _securityService;
  late AnimationController _shakeController;
  
  String _inputPin = "";
  bool _isUnlocked = false;
  bool _isInit = false;
  bool _hasPinConfigured = true;

   // Colours used for the PIN screen
  static const Color _bgLight = Color(0xFFF8F9FA);       
  static const Color _cardLight = Color(0xFFE9ECEF);  
  static const Color _textPrimary = Color(0xFF212529);    
  static const Color _textSecondary = Color(0xFF6C757D);   
  static const Color _accentActive = Color(0xFF212529);  
  static const Color _accentInactive = Color(0xFFCED4DA);  

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _initService();
  }

  Future<void> _initService() async {
    _securityService = SecurityService();
    
    // Check if the user has set up a PIN
    final hasPin = await _securityService.hasPIN();

    if (!mounted) return;

    setState(() {
      _hasPinConfigured = hasPin;
       // Skip the PIN screen if no PIN has been set
      if (!hasPin) {
        _isUnlocked = true;
      }
      _isInit = true;
    });
  }

  void _onKeyPress(String val) {
    if (_inputPin.length < 4) {
      setState(() {
        _inputPin += val;
      });
    }

    // Check the PIN automatically after four digits
    if (_inputPin.length == 4) {
      _verifyAndUnlock();
    }
  }

  void _onDelete() {
    if (_inputPin.isNotEmpty) {
      setState(() {
        _inputPin = _inputPin.substring(0, _inputPin.length - 1);
      });
    }
  }

  Future<void> _verifyAndUnlock() async {
    final isValid = await _securityService.verifyPIN(_inputPin);
    
    if (isValid) {
      setState(() {
        _isUnlocked = true;
      });
    } else {
      // Display an error animation to indicate unsuccessful authentication
      _shakeController.forward(from: 0.0);
      setState(() {
        _inputPin = ""; 
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect PIN. Please try again!'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      return const Scaffold(
        backgroundColor: _bgLight,
        body: Center(child: CircularProgressIndicator(color: _textPrimary)),
      );
    }

    // Show the main screen after unlocking
    if (_isUnlocked) {
      return widget.childOnUnlock;
    }

   
    const double shakeOffset = 24.0;
    final Animation<double> offsetAnimation = Tween<double>(begin: 0.0, end: shakeOffset)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    return Scaffold(
      backgroundColor: _bgLight,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline_rounded, size: 54, color: _textSecondary),
            const SizedBox(height: 24),
            const Text(
              "Enter PIN to Unlock",
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.w700, 
                color: _textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your 4-digit security code",
              style: TextStyle(
                color: _textSecondary, 
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 48),

            // PIN indicators show how many digits have been entered
            AnimatedBuilder(
              animation: offsetAnimation,
              builder: (context, child) {
                double dx = offsetAnimation.value * (offsetAnimation.value < (shakeOffset / 2) ? 1 : -1);
                return Transform.translate(
                  offset: Offset(dx, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      bool isFilled = index < _inputPin.length;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFilled ? _accentActive : _accentInactive,
                          boxShadow: isFilled ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ] : null,
                        ),
                      );
                    }),
                  ),
                );
              },
            ),

            const SizedBox(height: 56),

            // Numeric keypad for secure PIN entry
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0, 
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    if (index == 9) return const SizedBox.shrink(); 
                    
                    String keyLabel = "";
                    if (index == 10) {
                      keyLabel = "0";
                    } else if (index == 11) {
                      return ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: const Icon(Icons.backspace_outlined, size: 24, color: _textPrimary),
                            onPressed: _onDelete,
                          ),
                        ),
                      );
                    } else {
                      keyLabel = (index + 1).toString();
                    }

                    return Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _cardLight,
                      ),
                      child: ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _onKeyPress(keyLabel),
                            child: Center(
                              child: Text(
                                keyLabel,
                                style: const TextStyle(
                                  fontSize: 26, 
                                  fontWeight: FontWeight.w600, 
                                  color: _textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }
}