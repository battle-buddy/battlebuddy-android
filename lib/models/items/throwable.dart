import 'package:cloud_firestore/cloud_firestore.dart';

import 'item.dart';

enum ThrowableType {
  fragmentation,
  flash,
  smoke,
  undefined,
}

extension ThrowableTypeExt on ThrowableType {
  static const Map<ThrowableType, String> _displayName = {
    ThrowableType.fragmentation: 'Fragmentation',
    ThrowableType.flash: 'Flash',
    ThrowableType.smoke: 'Smoke',
    ThrowableType.undefined: 'Undefined',
  };

  String get displayName => _displayName[this]!;
}

extension Format on ThrowableType {
  String get string {
    switch (this) {
      case ThrowableType.fragmentation:
        return 'fragmentation';
      case ThrowableType.flash:
        return 'flash';
      case ThrowableType.smoke:
        return 'smoke';
      case ThrowableType.undefined:
        return 'undefined';
    }
  }
}

extension StringParsing on String {
  ThrowableType get parseThrowableType {
    switch (this) {
      case 'frag':
        return ThrowableType.fragmentation;
      case 'flash':
        return ThrowableType.flash;
      case 'smoke':
        return ThrowableType.smoke;
      default:
        return ThrowableType.undefined;
    }
  }
}

class Throwable extends Item implements ExplorableSectionItem {
  final ThrowableType throwableType;
  final Duration delay;
  final int fragCount;
  final Length minDistance;
  final Length maxDistance;
  final Length contusionDistance;
  final double strength;
  final Duration emitTime;

  Throwable.fromMap(super.map, {super.reference})
      : assert(map['type'] != null),
        assert(map['delay'] != null),
        assert(map['fragCount'] != null),
        assert(map['minDistance'] != null),
        assert(map['maxDistance'] != null),
        assert(map['contusionDistance'] != null),
        assert(map['strength'] != null),
        assert(map['emitTime'] != null),
        throwableType = map['type'].toString().parseThrowableType,
        delay =
            Duration(milliseconds: (map['delay'].toDouble() * 1000).toInt()),
        fragCount = map['fragCount'].toInt(),
        minDistance = Length(meter: map['minDistance'].toDouble()),
        maxDistance = Length(meter: map['maxDistance'].toDouble()),
        contusionDistance = Length(meter: map['contusionDistance'].toDouble()),
        strength = map['strength'].toDouble(),
        emitTime =
            Duration(milliseconds: (map['emitTime'].toDouble() * 1000).toInt()),
        super.fromMap();

  Throwable.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  @override
  ItemType get type => ItemType.throwable;

  @override
  String get sectionValue => throwableType.displayName;

  @override
  List<PropertySection> get propertySections => [
        PropertySection(
          title: 'Properties',
          properties: <DisplayProperty>[
            DisplayProperty(
              name: 'Type',
              value: throwableType.displayName,
            ),
            DisplayProperty(
              name: 'Delay',
              value: '${delay.inMilliseconds / 1000} sec.',
            ),
            ...throwableType == ThrowableType.fragmentation
                ? [
                    DisplayProperty(
                      name: 'Explosion Radius',
                      value: '${minDistance.meter} - ${maxDistance.meter} m',
                    ),
                    DisplayProperty(
                      name: 'Fragmentation Count',
                      value: '$fragCount',
                    )
                  ]
                : [],
            ...throwableType == ThrowableType.smoke
                ? [
                    DisplayProperty(
                      name: 'Burn Time',
                      value: '${emitTime.inMilliseconds / 1000} sec.',
                    )
                  ]
                : [],
            ...throwableType == ThrowableType.flash
                ? [
                    DisplayProperty(
                      name: 'Contusion Distance',
                      value: contusionDistance.toString(),
                    )
                  ]
                : []
          ],
        ),
      ];

  @override
  List<ComparableProperty> get comparableProperties => [
        ComparableProperty('Delay', delay.inMilliseconds,
            isLowerBetter: true,
            displayValue: '${delay.inMilliseconds / 1000} sec.'),
        ComparableProperty(
          'Maximum Radius',
          throwableType == ThrowableType.flash
              ? contusionDistance.meter
              : maxDistance.meter,
          displayValue: throwableType == ThrowableType.flash
              ? contusionDistance.toString()
              : maxDistance.meter.toString(),
        ),
        ComparableProperty('Fragments', fragCount),
      ];
}
