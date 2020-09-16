import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/string.dart';
import 'item.dart';

enum MedicalType {
  accessory,
  drug,
  medkit,
  stimulator,
}

extension MedicalTypeExt on MedicalType {
  static const Map<MedicalType, String> _displayName = {
    MedicalType.accessory: 'Accessory',
    MedicalType.drug: 'Drug',
    MedicalType.medkit: 'Medkit',
    MedicalType.stimulator: 'Stimulator',
  };

  String get displayName => _displayName[this];
}

extension Format on MedicalType {
  String get string {
    switch (this) {
      case MedicalType.accessory:
        return 'accessory';
      case MedicalType.drug:
        return 'drug';
      case MedicalType.medkit:
        return 'medkit';
      case MedicalType.stimulator:
        return 'stimulator';
    }

    return null;
  }
}

extension StringParsing on String {
  MedicalType toMedicalType() {
    switch (this) {
      case 'accessory':
        return MedicalType.accessory;
      case 'drug':
        return MedicalType.drug;
      case 'medkit':
        return MedicalType.medkit;
      case 'stimulator':
        return MedicalType.stimulator;
    }

    return null;
  }
}

class Medical extends Item implements ExplorableSectionItem {
  final MedicalType medicalType;
  final int resources;
  final Duration useTime;
  final Effects effects;

  Medical.fromMap(Map<String, dynamic> map, {DocumentReference reference})
      : assert(map['type'] != null),
        assert(map['resources'] != null),
        assert(map['useTime'] != null),
        medicalType = (map['type'] as String).toMedicalType(),
        resources = map['resources'].toInt(),
        useTime = Duration(seconds: map['useTime'].toInt()),
        effects = Effects.fromMap(map['effects']),
        super.fromMap(map, reference: reference);

  Medical.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  ItemType get type => ItemType.medical;

  @override
  String get sectionValue => medicalType.displayName;

  @override
  List<PropertySection> get propertySections => [
        PropertySection(
          title: 'Properties',
          properties: <DisplayProperty>[
            DisplayProperty(
              name: 'Type',
              value: medicalType.displayName,
            ),
            ...resources > 0
                ? [
                    DisplayProperty(
                      name: 'Resources',
                      value: '$resources',
                    )
                  ]
                : [],
            DisplayProperty(
              name: 'Use Time',
              value: '${useTime.inSeconds} sec.',
            ),
          ],
        ),
        PropertySection(
          title: 'Effects',
          properties: effects.effects.entries
              .map(
                (e) => DisplayProperty(
                  name: '${e.key.asTitle}',
                  value: e.value.removes
                      ? (e.value.duration.inSeconds > 0
                          ? 'Supressed for ${e.value.duration.inSeconds}s'
                          : 'Removed')
                      : (e.value.value != 0
                          ? '${e.value.value} ${e.value.isPercent ? '%' : ''}'
                          : 'Added for ${e.value.duration.inSeconds}s'),
                ),
              )
              .toList(growable: false),
        ),
        ...effects.skills != null
            ? [
                PropertySection(
                  title: 'Skills',
                  properties: effects.skills
                      .map(
                        (e) => DisplayProperty(
                          name: '${e.name.asTitle}',
                          value:
                              '${e.value.truncate()} lvl. for ${e.duration.inSeconds}s',
                        ),
                      )
                      .toList(growable: false),
                )
              ]
            : [],
      ];

  @override
  List<ComparableProperty> get comparableProperties => [
        ComparableProperty('Resources', resources),
        ComparableProperty('Use Time', useTime.inSeconds,
            isLowerBetter: true, displayValue: '${useTime.inSeconds} sec.'),
      ];
}

class Effects {
  final Map<String, Effect> effects;
  final List<Effect> skills;

  static const List<String> toMap = <String>[
    'energy',
    'energyRate',
    'hydration',
    'hydrationRate',
    'stamina',
    'staminaRate',
    'health',
    'healthRate',
    'bloodloss',
    'fracture',
    'contusion',
    'pain',
    'tunnelVision',
    'tremor',
    'toxication',
    'radExposure',
    'mobility',
    'recoil',
    'reloadSpeed',
    'lootSpeed',
    'unlockSpeed',
    'destroyedPart',
    'weightLimit',
    'damageModifier',
  ];

  Effects.fromMap(Map<String, dynamic> map)
      : effects = Map<String, Effect>.fromEntries(
          map.entries
              .where((e) => toMap.contains(e.key))
              .map((e) => MapEntry(e.key, Effect.fromMap(e.value))),
        ),
        skills = map['skill'] != null
            ? List<Effect>.from(
                map['skill'].map((dynamic e) => Effect.fromMap(e)),
              )
            : null;
}

class Effect {
  final String name;
  final int resourceCosts;
  final Duration fadeIn;
  final Duration fadeOut;
  final double chance;
  final Duration delay;
  final Duration duration;
  final double value;
  final bool isPercent;
  final bool removes;
  final EffectPenalties penalties;

  Effect.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        resourceCosts = map['resourceCosts'],
        fadeIn = Duration(milliseconds: map['fadeIn'].toInt()),
        fadeOut = Duration(milliseconds: map['fadeOut'].toInt()),
        chance = map['chance'].toDouble(),
        delay = Duration(milliseconds: map['delay'].toInt()),
        duration = Duration(seconds: map['duration'].toInt()),
        value = map['value'].toDouble(),
        isPercent = map['isPercent'],
        removes = map['removes'],
        penalties = map['penalties'] != null
            ? EffectPenalties.fromMap(map['penalties'])
            : null;
}

class EffectPenalties {
  final double healthMin;
  final double healthMax;

  EffectPenalties.fromMap(Map<String, dynamic> map)
      : healthMin = map['healthMin']?.toDouble(),
        healthMax = map['healthMax']?.toDouble();
}
