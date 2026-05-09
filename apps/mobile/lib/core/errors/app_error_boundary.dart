import 'package:flutter/material.dart';

class AppErrorBoundary extends StatelessWidget {
  const AppErrorBoundary({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}