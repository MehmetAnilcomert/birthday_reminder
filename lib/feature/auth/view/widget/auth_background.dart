import 'dart:ui';
import 'package:birthday_reminder/product/utility/constants/product_padding.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.general.colorScheme.primary,
                  context.general.colorScheme.primaryContainer,
                  context.general.colorScheme.secondary,
                ],
              ),
            ),
          ),
          // Bubbles/Circles for decoration (optional, keeping it simple for now)
          Positioned(
            top: -50,
            left: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),

          // Glassmorphic Content
          Center(
            child: SingleChildScrollView(
              padding: const ProductPadding.allNormal(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const ProductPadding.allNormal(),
                    decoration: BoxDecoration(
                      color: context.general.colorScheme.surface.withOpacity(
                        0.8,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
