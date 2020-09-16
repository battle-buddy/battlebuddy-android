import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/string.dart';
import 'item.dart';

enum ArmorType {
  attachment,
  body,
  faceCover,
  helmet,
  visor,
}

extension Format on ArmorType {
  static const Map<ArmorType, String> _string = {
    ArmorType.attachment: 'attachment',
    ArmorType.body: 'body',
    ArmorType.faceCover: 'faceCover',
    ArmorType.helmet: 'helmet',
    ArmorType.visor: 'visor',
  };

  String get string => _string[this];
}

extension StringParsing on String {
  ArmorType toArmorType() {
    switch (this) {
      case 'attachment':
        return ArmorType.attachment;
      case 'body':
        return ArmorType.body;
      case 'faceCover':
        return ArmorType.faceCover;
      case 'helmet':
        return ArmorType.helmet;
      case 'visor':
        return ArmorType.visor;
    }

    return null;
  }
}

class Armor extends Item implements Armored, ExplorableSectionItem, TableView {
  final ArmorType armorType;
  final ArmorProperties properties;
  final ArmorPenalties penalties;
  final List<String> blocking;

  Armor.fromMap(Map<String, dynamic> map, {DocumentReference reference})
      : assert(map['type'] != null),
        assert(map['armor'] != null),
        assert(map['penalties'] != null),
        assert(map['blocking'] != null),
        armorType = (map['type'] as String).toArmorType(),
        properties = ArmorProperties.fromMap(map['armor']),
        penalties = ArmorPenalties.fromMap(map['penalties']),
        blocking = List<String>.from(map['blocking'], growable: false),
        super.fromMap(map, reference: reference);

  Armor.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  ItemType get type {
    switch (armorType) {
      case ArmorType.attachment:
        return ItemType.attachment;
      case ArmorType.body:
        return ItemType.bodyArmor;
      case ArmorType.faceCover:
        return ItemType.attachment;
      case ArmorType.helmet:
        return ItemType.helmet;
      case ArmorType.visor:
        return ItemType.attachment;
    }

    return ItemType.armor;
  }

  @override
  String get sectionValue => 'Class ${properties.armorClass}';

  @override
  List<PropertySection> get propertySections => [
        PropertySection(
          title: 'Properties',
          properties: <DisplayProperty>[
            DisplayProperty(
              name: 'Class',
              value: '${properties.armorClass}',
            ),
            DisplayProperty(
              name: 'Durability',
              value: '${properties.durability}',
            ),
            DisplayProperty(
              name: 'Material',
              value: '${properties.material.displayName}',
            ),
            DisplayProperty(
              name: 'Zones',
              value: properties.zones.join(', ').asTitle,
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
              value: '${penalties.movementSpeed ?? 0} %',
            ),
            DisplayProperty(
              name: 'Turn Speed',
              value: '${penalties.mouseSpeed ?? 0} %',
            ),
            DisplayProperty(
              name: 'Ergonomics',
              value: '${penalties.ergonomics ?? 0}',
            ),
          ],
        )
      ];

  @override
  ArmorProperties get armorProperties => properties;

  @override
  List<ComparableProperty> get comparableProperties => [
        ComparableProperty('Class', properties.armorClass),
        ComparableProperty('Weight', weight.kilograms,
            isLowerBetter: true, displayValue: weight.toStringAsKilograms()),
        ComparableProperty('Durability', properties.durability),
        ComparableProperty('Protected Zones', properties.zones.length),
        ComparableProperty('Speed Penalty', penalties.movementSpeed ?? 0,
            displayValue: '${penalties.movementSpeed ?? 0} %'),
        ComparableProperty('Turn Penalty', penalties.mouseSpeed ?? 0,
            displayValue: '${penalties.mouseSpeed ?? 0} %'),
        ComparableProperty('Ergonomics Penalty', penalties.ergonomics ?? 0),
      ];

  @override
  List<String> get tableHeaders => [
        'Name',
        'Type',
        'Class',
        'Durability',
      ];

  @override
  List get tableData => <dynamic>[
        shortName,
        armorType.string.asTitle,
        properties.armorClass,
        properties.durability,
      ];
}

class ArmorProperties {
  final int armorClass;
  final double durability;
  final ArmorMaterial material;
  final double bluntThroughput;
  final List<String> zones;

  ArmorProperties({
    this.armorClass,
    this.durability,
    this.material,
    this.bluntThroughput,
    this.zones,
  });

  ArmorProperties.fromMap(Map<String, dynamic> map)
      : assert(map['class'] != null),
        assert(map['durability'] != null),
        assert(map['material'] != null),
        assert(map['bluntThroughput'] != null),
        assert(map['zones'] != null),
        armorClass = map['class'].toInt(),
        durability = map['durability'].toDouble(),
        material = ArmorMaterial.fromMap(map['material']),
        bluntThroughput = map['bluntThroughput'].toDouble(),
        zones = List<String>.from(map['zones'], growable: false);
}

class ArmorMaterial {
  final String name;
  final double destructibility;

  static const Map<String, String> _displayNames = {
    'aluminium': 'Aluminium',
    'aramid': 'Aramid',
    'ceramic': 'Ceramic',
    'combined': 'Combined',
    'glass': 'Glass',
    'steel': 'Steel',
    'titanium': 'Titanium',
    'uhmwpe': 'UHMWPE',
  };

  ArmorMaterial({
    @required this.name,
    @required this.destructibility,
  });

  ArmorMaterial.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['destructibility'] != null),
        name = map['name'],
        destructibility = map['destructibility'].toDouble();

  String get displayName => _displayNames[name];
}

class ArmorPenalties {
  final double mouseSpeed;
  final double movementSpeed;
  final double ergonomics;
  final String deafness;

  ArmorPenalties({
    this.mouseSpeed,
    this.movementSpeed,
    this.ergonomics,
    this.deafness,
  });

  ArmorPenalties.fromMap(Map<String, dynamic> map)
      : mouseSpeed = map['mouse']?.toDouble(),
        movementSpeed = map['speed']?.toDouble(),
        ergonomics = map['ergonomicsFP']?.toDouble(),
        deafness = map['deafness'];
}

abstract class Armored extends Item {
  ArmorProperties get armorProperties;
}
