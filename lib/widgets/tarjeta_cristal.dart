import 'dart:ui'; // Necesario para el efecto de desenfoque
import 'package:flutter/material.dart';

class TarjetaCristal extends StatelessWidget {
  final Widget child;

  const TarjetaCristal({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(25),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withAlpha(50), width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }
}
