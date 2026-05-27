import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

typedef IconFactory = IconData Function();

class IconMapping {
  IconMapping._();

  static final Map<String, IconFactory> glyphs = {
    'send': PhosphorIcons.paperPlaneTilt,
    'message': PhosphorIcons.chatCircleDots,
    'family': PhosphorIcons.users,
    'marketplace': PhosphorIcons.storefront,
    'record': PhosphorIcons.microphone,
    'consent': PhosphorIcons.handshake,
    'security': PhosphorIcons.shieldCheck,
    'error': PhosphorIcons.warningCircle,
  };
}
