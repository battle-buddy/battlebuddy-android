import 'package:cloud_firestore/cloud_firestore.dart';

import 'item.dart';

enum FirearmClass {
  assaultCarbine,
  assaultRifle,
  grenadeLauncher,
  machinegun,
  marksmanRifle,
  pistol,
  shotgun,
  smg,
  sniperRifle,
  specialWeapon,
}

enum FireMode {
  single,
  burst,
  full,
}

extension FireModeExt on FireMode {
  static const Map<FireMode, String> _displayName = {
    FireMode.single: 'Single',
    FireMode.burst: 'Burst',
    FireMode.full: 'Full',
  };

  String? get displayName => _displayName[this];
}

extension StringParsing on String? {
  FirearmClass? toFirearmClass() {
    switch (this) {
      case 'assaultCarbine':
        return FirearmClass.assaultCarbine;
      case 'assaultRifle':
        return FirearmClass.assaultRifle;
      case 'grenadeLauncher':
        return FirearmClass.grenadeLauncher;
      case 'machinegun':
        return FirearmClass.machinegun;
      case 'marksmanRifle':
        return FirearmClass.marksmanRifle;
      case 'pistol':
        return FirearmClass.pistol;
      case 'shotgun':
        return FirearmClass.shotgun;
      case 'smg':
        return FirearmClass.smg;
      case 'sniperRifle':
        return FirearmClass.sniperRifle;
      case 'specialWeapon':
        return FirearmClass.specialWeapon;
    }

    return null;
  }

  FireMode? toFireMode() {
    switch (this) {
      case 'single':
        return FireMode.single;
      case 'burst':
        return FireMode.burst;
      case 'full':
        return FireMode.full;
    }

    return null;
  }
}

extension FirearmClassExt on FirearmClass? {
  static const Map<FirearmClass, String> _displayName = {
    FirearmClass.assaultCarbine: 'Assault Carbine',
    FirearmClass.assaultRifle: 'Assault Rifle',
    FirearmClass.grenadeLauncher: 'Grenade Launcher',
    FirearmClass.machinegun: 'Machinegun',
    FirearmClass.marksmanRifle: 'Marksman Rifle',
    FirearmClass.pistol: 'Pistol',
    FirearmClass.shotgun: 'Shotgun',
    FirearmClass.smg: 'SMG',
    FirearmClass.sniperRifle: 'Sniper Rifle',
    FirearmClass.specialWeapon: 'Special Weapon',
  };

  String? get displayName => _displayName[this!];
}

class Firearm extends Item implements ExplorableSectionItem {
  final FirearmClass? firearmClass;
  final String? caliber;
  final int? rateOfFire;
  final String? actionType;
  final List<FireMode> fireModes;
  final Speed muzzleVelocity;
  final Length effectiveDist;
  final double? ergonomics;
  final bool? foldRectractable;
  final int? recoilHorizontal;
  final int? recoilVertical;

  Firearm.fromMap(Map<String, dynamic> map, {DocumentReference? reference})
      : assert(map['class'] != null),
        assert(map['caliber'] != null),
        assert(map['rof'] != null),
        assert(map['action'] != null),
        assert(map['velocity'] != null),
        assert(map['modes'] != null),
        assert(map['velocity'] != null),
        assert(map['effectiveDist'] != null),
        assert(map['ergonomicsFP'] != null),
        assert(map['foldRectractable'] != null),
        assert(map['recoilHorizontal'] != null),
        assert(map['recoilVertical'] != null),
        firearmClass = (map['class'] as String?).toFirearmClass(),
        caliber = map['caliber'],
        rateOfFire = map['rof'].toInt(),
        actionType = map['action'],
        fireModes = List<FireMode>.from(
            map['modes'].map((dynamic m) => (m as String).toFireMode()),
            growable: false),
        muzzleVelocity = Speed(metersPerSecond: map['velocity'].toDouble()),
        effectiveDist = Length(meter: map['effectiveDist'].toDouble()),
        ergonomics = map['ergonomicsFP'].toDouble(),
        foldRectractable = map['foldRectractable'],
        recoilHorizontal = map['recoilHorizontal'].toInt(),
        recoilVertical = map['recoilVertical'].toInt(),
        super.fromMap(map, reference: reference);

  Firearm.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);

  @override
  ItemType get type => ItemType.firearm;

  @override
  String? get sectionValue => firearmClass.displayName;

  @override
  List<PropertySection> get propertySections => [
        PropertySection(
          title: 'Properties',
          properties: <DisplayProperty>[
            DisplayProperty(
              name: 'Class',
              value: firearmClass.displayName,
            ),
            DisplayProperty(
              name: 'Caliber',
              value: caliber,
            ),
            DisplayProperty(
              name: 'Fold-/Retractable',
              value: foldRectractable! ? 'Yes' : 'No',
            ),
          ],
        ),
        PropertySection(
          title: 'Performance',
          properties: <DisplayProperty>[
            DisplayProperty(
              name: 'Fire Modes',
              value: fireModes.map((v) => v.displayName).join(', '),
            ),
            DisplayProperty(
              name: 'Rate Of Fire',
              value: '$rateOfFire rpm',
            ),
            DisplayProperty(
              name: 'Effective Range',
              value: effectiveDist.toString(),
            ),
          ],
        )
      ];

  @override
  List<ComparableProperty> get comparableProperties => [
        ComparableProperty('Rate of Fire', rateOfFire,
            displayValue: '$rateOfFire rpm'),
        ComparableProperty('Ergonomics', ergonomics),
        ComparableProperty('Recoil Vertical', recoilVertical,
            isLowerBetter: true),
        ComparableProperty('Recoil Horizontal', recoilHorizontal,
            isLowerBetter: true),
        ComparableProperty('Effective Distance', effectiveDist.meter,
            displayValue: effectiveDist.toString()),
        ComparableProperty('Fire Modes', fireModes.length),
      ];
}
