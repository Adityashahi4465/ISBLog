import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget child;
  const Responsive({super.key ,required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      
      child: ConstrainedBox(
      
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: child,
      ),
    );
  }
}
