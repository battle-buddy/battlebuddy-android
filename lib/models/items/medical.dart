import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/string.dart';
import 'item.dart';

enum MedicalType {
  accessory,
  drug,
  medkit,
  stimulator,
}

extension MedicalTypeExt on MedicalType? {
  static const Map<MedicalType, String> _displayName = {
    MedicalType.accessory: 'Accessory',
    MedicalType.drug: 'Drug',
    MedicalType.medkit: 'Medkit',
    MedicalType.stimulator: 'Stimulator',
  };

  String? get displayName => _displayName[this!];
}

extension Format on MedicalType {
  String? get string {
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

extension StringParsing on String? {
  MedicalType? toMedicalType() {
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
  final MedicalType? medicalType;
  final int? resources;
  final Duration useTime;
  final Effects effects;

  Medical.fromMap(Map<String, dynamic> map, {DocumentReference? reference})
      : assert(map['type'] != null),
        assert(map['resources'] != null),
        assert(map['useTime'] != null),
        medicalType = (map['type'] as String?).toMedicalType(),
        resources = map['resources'].toInt(),
        useTime =
            Duration(milliseconds: (map['useTime'].toDouble() * 1000).toInt()),
        effects = Effects.fromMap(map['effects']),
        super.fromMap(map, reference: reference);

  Medical.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);

  @override
  ItemType get type => ItemType.medical;

  @override
  String? get sectionValue => medicalType.displayName;

  @override
  List<PropertySection> get propertySections => [
        PropertySection(
          title: 'Properties',
          properties: <DisplayProperty>[
            DisplayProperty(
              name: 'Type',
              value: medicalType.displayName,
            ),
            ...resources! > 0
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
                  value: e.value.removes!
                      ? (e.value.duration.inSeconds > 0
                          ? 'Supressed for ${e.value.duration.inMilliseconds / 1000}s'
                          : 'Removed')
                      : (e.value.value != 0
                          ? (e.value.isPercent!
                              ? (e.value.value! * 100).toString() + ' %'
                              : '${e.value.value}')
                          : 'Added for ${e.value.duration.inMilliseconds / 1000}s'),
                ),
              )
              .toList(growable: false),
        ),
        ...effects.skills != null
            ? [
                PropertySection(
                  title: 'Skills',
                  properties: effects.skills!
                      .map(
                        (e) => DisplayProperty(
                          name: '${e.name!.asTitle}',
                          value:
                              '${e.value!.truncate()} lvl. for ${e.duration.inMilliseconds / 1000}s',
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
        ComparableProperty('Use Time', useTime.inMilliseconds,
            isLowerBetter: true,
            displayValue: '${useTime.inMilliseconds / 1000} sec.'),
      ];
}

class Effects {
  final Map<String, Effect> effects;
  final List<Effect>? skills;

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
  final String? name;
  final int? resourceCosts;
  final Duration fadeIn;
  final Duration fadeOut;
  final double? chance;
  final Duration delay;
  final Duration duration;
  final double? value;
  final bool? isPercent;
  final bool? removes;
  final EffectPenalties? penalties;

  Effect.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        resourceCosts = map['resourceCosts'],
        fadeIn =
            Duration(microseconds: (map['fadeIn'].toDouble() * 1000).toInt()),
        fadeOut =
            Duration(microseconds: (map['fadeOut'].toDouble() * 1000).toInt()),
        chance = map['chance'].toDouble(),
        delay =
            Duration(microseconds: (map['delay'].toDouble() * 1000).toInt()),
        duration =
            Duration(milliseconds: (map['duration'].toDouble() * 1000).toInt()),
        value = map['value'].toDouble(),
        isPercent = map['isPercent'],
        removes = map['removes'],
        penalties = map['penalties'] != null
            ? EffectPenalties.fromMap(map['penalties'])
            : null;
}

class EffectPenalties {
  final double? healthMin;
  final double? healthMax;

  EffectPenalties.fromMap(Map<String, dynamic> map)
      : healthMin = map['healthMin']?.toDouble(),
        healthMax = map['healthMax']?.toDouble();
}
