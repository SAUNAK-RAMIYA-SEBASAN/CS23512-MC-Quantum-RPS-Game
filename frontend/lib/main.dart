import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantum RPS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF0a0e27),
        primaryColor: Color(0xFF00ffff),
        fontFamily: 'Courier',
      ),
      home: QuantumGame(),
    );
  }
}

class QuantumGame extends StatefulWidget {
  @override
  _QuantumGameState createState() => _QuantumGameState();
}

class _QuantumGameState extends State<QuantumGame> with TickerProviderStateMixin {
  String result = '';
  String playerMove = '';
  String quantumMove = '';
  String message = '';
  bool isLoading = false;
  int winStreak = 0;
  bool showEasterEgg = false;

  late AnimationController _glowController;
  late AnimationController _resultController;
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late AnimationController _buttonController;

  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _resultController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _resultController,
      curve: Curves.elasticOut,
    );

    _shakeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _buttonController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _resultController.dispose();
    _shakeController.dispose();
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> playGame(int choice) async {
    HapticFeedback.mediumImpact();

    _buttonController.forward().then((_) => _buttonController.reverse());

    setState(() {
      isLoading = true;
      message = '';
      showEasterEgg = false;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/play'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'player_choice': choice}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await Future.delayed(Duration(milliseconds: 600));

        setState(() {
          playerMove = data['player_move'];
          quantumMove = data['quantum_move'];
          result = data['result'];
          message = data['message'];
          isLoading = false;

          if (result == 'win') {
            winStreak++;
            HapticFeedback.heavyImpact();
            if (winStreak >= 3) {
              showEasterEgg = true;
            }
          } else {
            winStreak = 0;
          }
        });

        _fadeController.forward(from: 0.0);
        _resultController.forward(from: 0.0);

        if (result == 'lose') {
          _shakeController.forward(from: 0.0);
          HapticFeedback.vibrate();
        } else if (result == 'win') {
          HapticFeedback.heavyImpact();
        }
      }
    } catch (e) {
      setState(() {
        message = 'Connection Error';
        isLoading = false;
      });
    }
  }

  Color _getResultColor() {
    switch (result) {
      case 'win':
        return Color(0xFF00ff41);
      case 'lose':
        return Color(0xFFff0055);
      case 'tie':
        return Color(0xFF00ffff);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Smooth animated gradient background
          AnimatedGradientBackground(),

          // Floating particles
          FloatingParticles(),

          // Main content with shake animation
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value * (Random().nextBool() ? 1 : -1), 0),
                child: child,
              );
            },
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Glowing Title
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF00ffff).withOpacity(_glowAnimation.value * 0.8),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF00ffff).withOpacity(_glowAnimation.value * 0.6),
                                    blurRadius: 25,
                                    spreadRadius: 3,
                                  ),
                                  BoxShadow(
                                    color: Color(0xFFa855f7).withOpacity(_glowAnimation.value * 0.4),
                                    blurRadius: 20,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                'QUANTUM RPS',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00ffff),
                                  letterSpacing: 5,
                                  shadows: [
                                    Shadow(
                                      color: Color(0xFF00ffff).withOpacity(_glowAnimation.value),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 60),

                        // Selection Prompt
                        FadeTransition(
                          opacity: _glowAnimation,
                          child: Text(
                            '> SELECT YOUR MOVE_',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF00ffff).withOpacity(0.8),
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),

                        SizedBox(height: 35),

                        // Easter Egg Indicator
                        if (showEasterEgg)
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                margin: EdgeInsets.only(bottom: 25),
                                decoration: BoxDecoration(
                                  color: Color(0xFF00ffff).withOpacity(0.15),
                                  border: Border.all(
                                    color: Color(0xFF00ffff),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF00ffff).withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '⚡',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'QUANTUM MASTERY: ${winStreak}X STREAK',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF00ffff),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.8,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '⚡',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // Game Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildCyberpunkButton('🪨', 0, 'ROCK'),
                            SizedBox(width: 18),
                            _buildCyberpunkButton('📄', 1, 'PAPER'),
                            SizedBox(width: 18),
                            _buildCyberpunkButton('✂️', 2, 'SCISSORS'),
                          ],
                        ),

                        SizedBox(height: 60),

                        // Loading Indicator
                        if (isLoading)
                          Container(
                            padding: EdgeInsets.all(25),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00ffff)),
                                    strokeWidth: 3,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'QUANTUM PROCESSING...',
                                  style: TextStyle(
                                    color: Color(0xFF00ffff),
                                    fontSize: 13,
                                    letterSpacing: 2.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Result Display
                        if (!isLoading && playerMove.isNotEmpty)
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                padding: EdgeInsets.all(28),
                                decoration: BoxDecoration(
                                  color: Color(0xFF0d1117).withOpacity(0.85),
                                  border: Border.all(
                                    color: _getResultColor(),
                                    width: 2.5,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getResultColor().withOpacity(0.4),
                                      blurRadius: 25,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildMoveDisplay('YOU', playerMove),
                                        Container(
                                          width: 2.5,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFF00ffff).withOpacity(0.6),
                                                Color(0xFFa855f7).withOpacity(0.4),
                                              ],
                                            ),
                                          ),
                                        ),
                                        _buildMoveDisplay('QUANTUM', quantumMove),
                                      ],
                                    ),
                                    SizedBox(height: 25),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: _getResultColor().withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: _getResultColor().withOpacity(0.4),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        message.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: _getResultColor(),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),

                                    // Victory confetti effect
                                    if (result == 'win')
                                      Padding(
                                        padding: EdgeInsets.only(top: 15),
                                        child: ConfettiEffect(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCyberpunkButton(String emoji, int choice, String label) {
    return GestureDetector(
      onTapDown: (_) => _buttonController.forward(),
      onTapUp: (_) {
        _buttonController.reverse();
        if (!isLoading) playGame(choice);
      },
      onTapCancel: () => _buttonController.reverse(),
      child: AnimatedBuilder(
        animation: _buttonController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_buttonController.value * 0.1),
            child: Container(
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Color(0xFF161b22),
                border: Border.all(
                  color: Color(0xFF00ffff).withOpacity(0.6),
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF00ffff).withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Color(0xFFa855f7).withOpacity(0.25),
                    blurRadius: 15,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    emoji,
                    style: TextStyle(fontSize: 42),
                  ),
                  SizedBox(height: 10),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF00ffff),
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoveDisplay(String player, String move) {
    return Column(
      children: [
        Text(
          player,
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF00ffff).withOpacity(0.75),
            letterSpacing: 2.5,
          ),
        ),
        SizedBox(height: 10),
        Text(
          move,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Smooth animated gradient background
class AnimatedGradientBackground extends StatefulWidget {
  @override
  _AnimatedGradientBackgroundState createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(Color(0xFF0a0e27), Color(0xFF1a0a2e), _controller.value)!,
                Color.lerp(Color(0xFF16213e), Color(0xFF0f1b3d), _controller.value)!,
                Color.lerp(Color(0xFF1a1a2e), Color(0xFF2d1b3d), _controller.value)!,
                Color.lerp(Color(0xFF0d1117), Color(0xFF1a0d2e), _controller.value)!,
              ],
              stops: [
                0.0 + (_controller.value * 0.1),
                0.3 + (_controller.value * 0.15),
                0.7 - (_controller.value * 0.1),
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

// Floating particles
class FloatingParticles extends StatefulWidget {
  @override
  _FloatingParticlesState createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> particles = List.generate(40, (index) => Particle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 25),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double speed = 0.08 + Random().nextDouble() * 0.2;
  double size = 1.5 + Random().nextDouble() * 2.5;
  Color color = Random().nextDouble() > 0.7
      ? Color(0xFFa855f7)
      : Color(0xFF00ffff);
  double opacity = 0.2 + Random().nextDouble() * 0.3;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

      double yPos = ((particle.y + animationValue * particle.speed) % 1.0) * size.height;

      canvas.drawCircle(
        Offset(particle.x * size.width, yPos),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

// Confetti effect for wins
class ConfettiEffect extends StatefulWidget {
  @override
  _ConfettiEffectState createState() => _ConfettiEffectState();
}

class _ConfettiEffectState extends State<ConfettiEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(220, 80),
          painter: ConfettiPainter(_controller.value),
        );
      },
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double animationValue;
  final List<ConfettiParticle> confetti = List.generate(25, (i) => ConfettiParticle());

  ConfettiPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in confetti) {
      final paint = Paint()
        ..color = particle.color.withOpacity((1 - animationValue) * 0.9);

      double x = size.width / 2 + particle.x * animationValue * 120;
      double y = particle.y * animationValue * 70;

      canvas.drawCircle(Offset(x, y), 3.5, paint);
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}

class ConfettiParticle {
  double x = (Random().nextDouble() - 0.5) * 2;
  double y = Random().nextDouble();
  Color color = [
    Color(0xFF00ff41),
    Color(0xFF00ffff),
    Color(0xFFa855f7),
    Color(0xFF00d4ff),
  ][Random().nextInt(4)];
}
