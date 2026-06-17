import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/pages/login_page.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/pages/signup_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _showFront = true;

  void tragicInit() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCard() {
    setState(() {
      _showFront = !_showFront;
      _showFront
          ? _animationController.reverse()
          : _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final angle = _animationController.value * pi;

          final isBack = angle >= pi / 2;

          return Transform(
            alignment: .center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isBack
                ? Transform(
                    alignment: .center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: SignupPage(onFlip: _toggleCard),
                  )
                : LoginPage(onFlip: _toggleCard),
          );
        },
      ),
    );
  }
}
