import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/string.dart';
import 'armor.dart';
import 'item.dart';

enum ChestRigType {
  unarmored,
  armored,
}

class ChestRig extends Item
    implements Armored, ExplorableSectionItem, TableView {
  final ChestRigType chestRigType;
  final List<Grid> grids;
  final ArmorProperties? armor;
  final ArmorPenalties? penalties;
  final List<String>? blocking;

  ChestRig.fromMap(super.map, {super.reference})
      : chestRigType = map['armor'] != null
            ? ChestRigType.armored
            : ChestRigType.unarmored,
        grids = List<Grid>.from(
            map['grids'].map((dynamic map) => Grid.fromMap(map)),
            growable: false),
        armor =
            map['armor'] != null ? ArmorProperties.fromMap(map['armor']) : null,
        penalties = map['penalties'] != null
            ? ArmorPenalties.fromMap(map['penalties'])
            : null,
        blocking = map['blocking'] != null
            ? List<String>.from(map['blocking'], growable: false)
            : null,
        super.fromMap();

  ChestRig.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  @override
  ItemType get type => ItemType.chestRig;

  @override
  String get sectionValue =>
      armor != null ? 'Class ${armor!.armorClass}' : 'Unarmored';

  @override
  List<PropertySection> get propertySections => [
        PropertySection(
          title: 'Properties',
          properties: <DisplayProperty>[
            DisplayProperty(
              name: 'Total Capacity',
              value:
                  '${grids.fold<int>(0, (p, n) => p + (n.width * n.height))}',
            ),
            ...toGridMap(grids).entries.map(
                  (e) => DisplayProperty(
                    name: '${e.key} slots',
                    value: '${e.value}',
                  ),
                ),
          ],
        ),
        ...chestRigType == ChestRigType.armored
            ? [
                PropertySection(
                  title: 'Armor Properties',
                  properties: <DisplayProperty>[
                    DisplayProperty(
                      name: 'Class',
                      value: '${armor!.armorClass}',
                    ),
                    DisplayProperty(
                      name: 'Durability',
                      value: '${armor!.durability}',
                    ),
                    DisplayProperty(
                      name: 'Material',
                      value: '${armor!.material.displayName}',
                    ),
                    DisplayProperty(
                      name: 'Zones',
                      value: armor!.zones.join(', ').asTitle,
                    ),
                    DisplayProperty(
                      name: 'Weight',
                      value: weight.toStringAsKilograms(),
                    ),
                  ],
                ),
                PropertySection(
                  title: 'Penalties',
                  properties: <DisplayProperty>[
                    DisplayProperty(
                      name: 'Movement Speed',
                      value: '${penalties!.movementSpeed ?? 0} %',
                    ),
                    DisplayProperty(
                      name: 'Turn Speed',
                      value: '${penalties!.mouseSpeed ?? 0} %',
                    ),
                    DisplayProperty(
                      name: 'Ergonomics',
                      value: '${penalties!.ergonomics ?? 0}',
                    ),
                  ],
                ),
              ]
            : [],
      ];

  @override
  ArmorProperties? get armorProperties => armor;

  @override
  List<ComparableProperty> get comparableProperties => [
        ComparableProperty('Total Capacity',
            grids.fold<int>(0, (p, n) => p + (n.width * n.height))),
        ComparableProperty('Weight', weight.kilograms,
            isLowerBetter: true, displayValue: weight.toStringAsKilograms()),
        ComparableProperty('Class', armor?.armorClass ?? 0),
        ComparableProperty('Durability', armor?.durability ?? 0),
        ComparableProperty('Protected Zones', armor?.zones.length ?? 0),
        ComparableProperty('Speed Penalty', penalties!.movementSpeed ?? 0,
            displayValue: '${penalties!.movementSpeed ?? 0} %'),
        ComparableProperty('Turn Penalty', penalties!.mouseSpeed ?? 0,
            displayValue: '${penalties!.mouseSpeed ?? 0} %'),
        ComparableProperty('Ergonomics Penalty', penalties?.ergonomics ?? 0),
      ];

  @override
  List<String> get tableHeaders => [
        'Name',
        'Class',
        'Durability',
      ];

  @override
  List get tableData => <dynamic>[
        shortName,
        armor?.armorClass,
        armor?.durability,
      ];
}

class Grid {
  final String? id;
  final int height;
  final int width;
  final int? maxWeight;

  Grid({
    this.id,
    required this.height,
    required this.width,
    this.maxWeight,
  });

  Grid.fromMap(Map<String, dynamic> map)
      : assert(map['height'] != null),
        assert(map['width'] != null),
        id = map['id'],
        height = map['height'],
        width = map['width'],
        maxWeight = map['maxWeight'];
}

SplayTreeMap<String, int> toGridMap(List<Grid> grids) {
  var map = SplayTreeMap<String, int>();

  for (final grid in grids) {
    final key = '${grid.width}x${grid.height}';
    var g = map[key] ?? 0;
    map[key] = g += 1;
  }

  return map;
}
