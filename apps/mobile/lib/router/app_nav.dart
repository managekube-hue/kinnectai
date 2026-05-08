import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNav {
  AppNav._();

  static Future<T?> push<T extends Object?>(
    BuildContext context,
    String route, {
    Object? arguments,
  }) {
    return context.push<T>(route, extra: arguments);
  }

  static void go(
    BuildContext context,
    String route, {
    Object? arguments,
  }) {
    context.go(route, extra: arguments);
  }
}

