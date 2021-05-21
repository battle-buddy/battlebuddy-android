import 'package:cloud_firestore/cloud_firestore.dart';

import 'item.dart';

class Melee extends Item implements ExplorableItem {
  final MeleeAttack slash;
  final MeleeAttack stab;

  Melee.fromMap(Map<String, dynamic> map, {DocumentReference? reference})
      : assert(map['slash'] != null),
        assert(map['stab'] != null),
        slash = MeleeAttack.fromMap(map['slash']),
        stab = MeleeAttack.fromMap(map['stab']),
        super.fromMap(map, reference: reference);

  Melee.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);

  @override
  ItemType get type => ItemType.melee;

  @override
  List<PropertySection> get propertySections => [
        PropertySection(
          title: 'Slash',
          properties: <DisplayProperty>[
            DisplayProperty(
              name: 'Damage',
              value: '${slash.damage}',
            ),
            DisplayProperty(
              name: 'Range',
              value: '${slash.range} m',
            ),
            DisplayProperty(
              name: 'Consumption',
              value: '${slash.consumption} stam.',
            ),
          ],
        ),
        PropertySection(
          title: 'Stab',
          properties: <DisplayProperty>[
            DisplayProperty(
              name: 'Damage',
              value: '${stab.damage}',
            ),
            DisplayProperty(
              name: 'Range',
              value: '${stab.range} m',
            ),
            DisplayProperty(
              name: 'Consumption',
              value: '${stab.consumption} stam.',
            ),
          ],
        )
      ];

  @override
  List<ComparableProperty> get comparableProperties => [
        ComparableProperty('Slash Damage', slash.damage),
        ComparableProperty('Slash Range', slash.range,
            displayValue: '${slash.range} m'),
        ComparableProperty('Slash Consumption', slash.consumption,
            isLowerBetter: true, displayValue: '${slash.consumption} stam.'),
        ComparableProperty('Stab Damage', stab.damage),
        ComparableProperty('Stab Range', stab.range,
            displayValue: '${stab.range} m'),
        ComparableProperty('Stab Consumption', stab.consumption,
            isLowerBetter: true, displayValue: '${stab.consumption} stam.'),
      ];
}

class MeleeAttack {
  final double? damage;
  final double? rate;
  final double? range;
  final double? consumption;

  MeleeAttack.fromMap(Map<String, dynamic> map)
      : assert(map['damage'] != null),
        assert(map['rate'] != null),
        assert(map['range'] != null),
        assert(map['consumption'] != null),
        damage = map['damage'].toDouble(),
        rate = map['rate'].toDouble(),
        range = map['range'].toDouble(),
        consumption = map['consumption'].toDouble();
}
