import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// PRD Addendum 1.0 S4 -- Immutable icon-to-feature mapping.
///
/// All feature icons MUST use PhosphorIcons. Banned: Material Icons,
/// CupertinoIcons on brand surfaces. System fallbacks (back, close) exempt.
///
/// Lint rule: any icon usage must reference [kinnectIcon] or this map.
/// CI gate: `dart run custom_lint --icon-mapping-check` fails if unmapped.
enum KinnectFeature {
  home,
  repost,
  stitch,
  create,
  tree,
  root,
  pulse,
  comment,
  rewind,
  favorite,
  share,
  branch,
  notifications,
  marketplace,
  Photplay,
  memoryBox,
  voiceprint,
  restore,
  legacyReel,
  familyCrest,
  settings,
  search,
  discovery,
  kinScore,
  dna,
  rooms,
  gathering,
  messaging,
  support,
  export,
  qrCode,
  lock,
  unlock,
  camera,
  upload,
  download,
  play,
  pause,
  record,
  trash,
  edit,
  filter,
  globe,
  map,
  alert,
  shield,
  check,
  warning,
  info,
}

/// Returns the PhosphorIcon for a given KinnectAI feature.
///
/// Usage: `Icon(kinnectIcon(KinnectFeature.pulse))`
IconData kinnectIcon(KinnectFeature feature) {
  return _iconMap[feature] ?? PhosphorIcons.question();
}

const Map<KinnectFeature, IconData Function()> _iconMapFn = {
  KinnectFeature.home: PhosphorIcons.house,
  KinnectFeature.repost: PhosphorIcons.repeat,
  KinnectFeature.stitch: PhosphorIcons.scissors,
  KinnectFeature.create: PhosphorIcons.plus,
  KinnectFeature.tree: PhosphorIcons.treeStructure,
  KinnectFeature.root: PhosphorIcons.user,
  KinnectFeature.pulse: PhosphorIcons.heart,
  KinnectFeature.comment: PhosphorIcons.chatCircleText,
  KinnectFeature.rewind: PhosphorIcons.arrowUDownLeft,
  KinnectFeature.favorite: PhosphorIcons.star,
  KinnectFeature.share: PhosphorIcons.shareNetwork,
  KinnectFeature.branch: PhosphorIcons.usersThree,
  KinnectFeature.notifications: PhosphorIcons.bell,
  KinnectFeature.marketplace: PhosphorIcons.storefront,
  KinnectFeature.Photplay: PhosphorIcons.flower,
  KinnectFeature.memoryBox: PhosphorIcons.lock,
  KinnectFeature.voiceprint: PhosphorIcons.microphone,
  KinnectFeature.restore: PhosphorIcons.magicWand,
  KinnectFeature.legacyReel: PhosphorIcons.filmStrip,
  KinnectFeature.familyCrest: PhosphorIcons.shield,
  KinnectFeature.settings: PhosphorIcons.gear,
  KinnectFeature.search: PhosphorIcons.magnifyingGlass,
  KinnectFeature.discovery: PhosphorIcons.binoculars,
  KinnectFeature.kinScore: PhosphorIcons.percent,
  KinnectFeature.dna: PhosphorIcons.dna,
  KinnectFeature.rooms: PhosphorIcons.videoCamera,
  KinnectFeature.gathering: PhosphorIcons.calendarBlank,
  KinnectFeature.messaging: PhosphorIcons.chatDots,
  KinnectFeature.support: PhosphorIcons.headset,
  KinnectFeature.export: PhosphorIcons.downloadSimple,
  KinnectFeature.qrCode: PhosphorIcons.qrCode,
  KinnectFeature.lock: PhosphorIcons.lock,
  KinnectFeature.unlock: PhosphorIcons.lockOpen,
  KinnectFeature.camera: PhosphorIcons.camera,
  KinnectFeature.upload: PhosphorIcons.uploadSimple,
  KinnectFeature.download: PhosphorIcons.downloadSimple,
  KinnectFeature.play: PhosphorIcons.play,
  KinnectFeature.pause: PhosphorIcons.pause,
  KinnectFeature.record: PhosphorIcons.record,
  KinnectFeature.trash: PhosphorIcons.trash,
  KinnectFeature.edit: PhosphorIcons.pencilSimple,
  KinnectFeature.filter: PhosphorIcons.funnel,
  KinnectFeature.globe: PhosphorIcons.globe,
  KinnectFeature.map: PhosphorIcons.mapPin,
  KinnectFeature.alert: PhosphorIcons.bellRinging,
  KinnectFeature.shield: PhosphorIcons.shieldCheck,
  KinnectFeature.check: PhosphorIcons.check,
  KinnectFeature.warning: PhosphorIcons.warning,
  KinnectFeature.info: PhosphorIcons.info,
};

// Pre-resolved map (avoids calling functions repeatedly).
final Map<KinnectFeature, IconData> _iconMap = _iconMapFn.map((k, fn) => MapEntry(k, fn()));

