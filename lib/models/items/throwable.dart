import 'package:cloud_firestore/cloud_firestore.dart';

import 'item.dart';

enum ThrowableType {
  fragmentation,
  flash,
  smoke,
}

extension ThrowableTypeExt on ThrowableType {
  static const Map<ThrowableType, String> _displayName = {
    ThrowableType.fragmentation: 'Fragmentation',
    ThrowableType.flash: 'Flash',
    ThrowableType.smoke: 'Smoke',
  };

  String get displayName => _displayName[this];
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
    }

    return null;
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
    }

    return null;
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

  Throwable.fromMap(Map<String, dynamic> map, {DocumentReference reference})
      : assert(map['type'] != null),
        assert(map['delay'] != null),
        assert(map['fragCount'] != null),
        assert(map['minDistance'] != null),
        assert(map['maxDistance'] != null),
        assert(map['contusionDistance'] != null),
        assert(map['strength'] != null),
        assert(map['emitTime'] != null),
        throwableType = map['type'].toString().parseThrowableType,
        delay = Duration(seconds: map['delay'].toInt()),
        fragCount = map['fragCount'].toInt(),
        minDistance = Length(meter: map['minDistance'].toDouble()),
        maxDistance = Length(meter: map['maxDistance'].toDouble()),
        contusionDistance = Length(meter: map['contusionDistance'].toDouble()),
        strength = map['strength'].toDouble(),
        emitTime = Duration(seconds: map['emitTime'].toInt()),
        super.fromMap(map, reference: reference);

  Throwable.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

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
              value: '${delay.inSeconds} sec.',
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
                      value: '${emitTime.inSeconds} sec.',
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
        ComparableProperty('Delay', delay.inSeconds,
            isLowerBetter: true, displayValue: '${delay.inSeconds} sec.'),
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
