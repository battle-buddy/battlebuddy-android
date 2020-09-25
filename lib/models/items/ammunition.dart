import 'package:cloud_firestore/cloud_firestore.dart';

import 'item.dart';

class Ammunition extends Item implements ExplorableSectionItem, TableView {
  final String caliber;
  final double penetration;
  final double damage;
  final double armorDamage;
  final Speed velocity;
  final Fragmentation fragmentation;
  final int projectiles;
  final bool isTracer;
  final bool isSubsonic;

  Ammunition.fromMap(Map<String, dynamic> map, {DocumentReference reference})
      : assert(map['caliber'] != null),
        assert(map['penetration'] != null),
        assert(map['damage'] != null),
        assert(map['armorDamage'] != null),
        assert(map['fragmentation'] != null),
        assert(map['projectiles'] != null),
        assert(map['velocity'] != null),
        assert(map['tracer'] != null),
        assert(map['subsonic'] != null),
        caliber = map['caliber'],
        penetration = map['penetration'].toDouble(),
        damage = map['damage'].toDouble(),
        armorDamage = map['armorDamage'].toDouble(),
        fragmentation = Fragmentation.fromMap(map['fragmentation']),
        projectiles = map['projectiles'].toInt(),
        velocity = Speed(metersPerSecond: map['velocity'].toDouble()),
        isTracer = map['tracer'],
        isSubsonic = map['subsonic'],
        super.fromMap(map, reference: reference);

  Ammunition.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  ItemType get type => ItemType.ammo;

  @override
  String get sectionValue => caliber;

  @override
  List<PropertySection> get propertySections => [
        PropertySection(
          title: 'Properties',
          properties: <DisplayProperty>[
            DisplayProperty(
              name: 'Caliber',
              value: caliber,
            ),
            DisplayProperty(
              name: 'Penetration',
              value: '${penetration.toStringAsFixed(0)}',
            ),
            DisplayProperty(
              name: 'Damage',
              value: '${damage.toStringAsFixed(0)}',
            ),
            DisplayProperty(
              name: 'Armor Damage',
              value: '$armorDamage %',
            ),
            DisplayProperty(
              name: 'Fragmentation',
              value: '${fragmentation.chance * 100} %',
            ),
            DisplayProperty(
              name: 'Velocity',
              value: velocity.toString(),
            ),
            DisplayProperty(
              name: 'Tracer',
              value: isTracer ? 'Yes' : 'No',
            ),
            DisplayProperty(
              name: 'Subsonic',
              value: isSubsonic ? 'Yes' : 'No',
            ),
          ],
        )
      ];

  @override
  List<ComparableProperty> get comparableProperties => [
        ComparableProperty('Penetration', penetration),
        ComparableProperty('Damage', damage),
        ComparableProperty('Armor Damage', armorDamage,
            displayValue: '$armorDamage %'),
        ComparableProperty('Fragmentation', fragmentation.chance * 100,
            displayValue: '${fragmentation.chance * 100} %'),
        ComparableProperty('Velocity', velocity.metersPerSecond,
            displayValue: velocity.toString()),
      ];

  @override
  List<String> get tableHeaders => [
        'Name',
        'Caliber',
        'Penetration',
        'Damage',
      ];

  @override
  List get tableData => <dynamic>[
        shortName,
        caliber,
        penetration,
        damage,
      ];
}

class Fragmentation {
  final double chance;
  final int min;
  final int max;

  Fragmentation.fromMap(Map<String, dynamic> map)
      : assert(map['chance'] != null),
        assert(map['min'] != null),
        assert(map['max'] != null),
        chance = map['chance'].toDouble(),
        min = map['min'].toInt(),
        max = map['max'].toInt();
}
