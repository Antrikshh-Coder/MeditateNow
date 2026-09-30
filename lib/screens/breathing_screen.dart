import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../models/breathing_exercise.dart';
import '../data/mock_data.dart';
import '../widgets/breathing_circle.dart';

class BreathingScreen extends StatefulWidget {
  final VoidCallback? onSessionCompleted;
  const BreathingScreen({super.key, this.onSessionCompleted});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  BreathingExercise _selectedExercise = MockData.breathingExercises.first;
  BreathingPhaseType _phase = BreathingPhaseType.ready;
  int _countdown = 4;
  int _currentCycle = 1;
  bool _isActive = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _selectedExercise.inhale),
    );
    _scaleAnimation = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  void _selectExercise(BreathingExercise exercise) {
    if (_isActive) _pause();
    setState(() {
      _selectedExercise = exercise;
      _phase = BreathingPhaseType.ready;
      _countdown = exercise.inhale;
      _currentCycle = 1;
    });
  }

  void _start() {
    setState(() {
      _isActive = true;
      _phase = BreathingPhaseType.inhale;
      _countdown = _selectedExercise.inhale;
      _currentCycle = 1;
    });
    _animController.duration = Duration(seconds: _selectedExercise.inhale);
    _animController.forward(from: 0.0);
    _runTimer();
  }

  void _pause() {
    setState(() => _isActive = false);
    _timer?.cancel();
    _animController.stop();
  }

  void _restart() {
    _timer?.cancel();
    _animController.reset();
    setState(() {
      _isActive = false;
      _phase = BreathingPhaseType.ready;
      _countdown = _selectedExercise.inhale;
      _currentCycle = 1;
    });
  }

  void _runTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isActive) return;
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _nextPhase();
        }
      });
    });
  }

  void _nextPhase() {
    if (_phase == BreathingPhaseType.inhale) {
      if (_selectedExercise.hold1 > 0) {
        _phase = BreathingPhaseType.holdIn;
        _countdown = _selectedExercise.hold1;
      } else {
        _startExhale();
      }
    } else if (_phase == BreathingPhaseType.holdIn) {
      _startExhale();
    } else if (_phase == BreathingPhaseType.exhale) {
      if (_selectedExercise.hold2 > 0) {
        _phase = BreathingPhaseType.holdOut;
        _countdown = _selectedExercise.hold2;
      } else {
        _finishCycleOrComplete();
      }
    } else if (_phase == BreathingPhaseType.holdOut) {
      _finishCycleOrComplete();
    }
  }

  void _startExhale() {
    _phase = BreathingPhaseType.exhale;
    _countdown = _selectedExercise.exhale;
    _animController.duration = Duration(seconds: _selectedExercise.exhale);
    _animController.reverse(from: 1.0);
  }

  void _finishCycleOrComplete() {
    if (_currentCycle >= _selectedExercise.defaultCycles) {
      _restart();
      widget.onSessionCompleted?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Breathing exercise completed! +2 mindful minutes.')),
      );
    } else {
      _currentCycle++;
      _phase = BreathingPhaseType.inhale;
      _countdown = _selectedExercise.inhale;
      _animController.duration = Duration(seconds: _selectedExercise.inhale);
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131F17),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Program Selection Tabs
              Column(
                children: [
                  Text(
                    'Breathe',
                    style: GoogleFonts.dmSerifDisplay(fontSize: 28, color: AppColors.warmCream),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Return to the present moment.',
                    style: GoogleFonts.manrope(fontSize: 13, color: AppColors.sage),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: MockData.breathingExercises.map((ex) {
                        final isSelected = ex.id == _selectedExercise.id;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text('${ex.title} (${ex.subtitle})'),
                            selected: isSelected,
                            selectedColor: AppColors.sage,
                            labelStyle: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.forestGreen : Colors.white70,
                            ),
                            backgroundColor: Colors.white.withValues(alpha: 0.08),
                            onSelected: (_) => _selectExercise(ex),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              // Visualizer Center
              BreathingCircle(
                phase: _phase,
                countdownSeconds: _countdown,
                scaleAnimation: _scaleAnimation,
                currentCycle: _currentCycle,
                totalCycles: _selectedExercise.defaultCycles,
              ),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white60, size: 28),
                    onPressed: _restart,
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sage,
                      foregroundColor: AppColors.forestGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r20),
                      ),
                    ),
                    onPressed: () {
                      if (_isActive) {
                        _pause();
                      } else {
                        _start();
                      }
                    },
                    icon: Icon(_isActive ? Icons.pause : Icons.play_arrow),
                    label: Text(
                      _isActive ? 'Pause' : 'Start Practice',
                      style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
