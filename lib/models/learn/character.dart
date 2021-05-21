import 'package:cloud_firestore/cloud_firestore.dart';

import '../../modules/ballistics_engine/bindings.dart' as bindings;

class Character {
  final String? id;
  final String? name;
  final Health health;
  final int? index;

  final DocumentReference? reference;

  Character.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['_id'] != null),
        assert(map['name'] != null),
        assert(map['health'] != null),
        assert(map['index'] != null),
        id = map['_id'],
        name = map['name'],
        health = Health.fromMap(map['health']),
        index = map['index'].toInt();

  Character.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);
}

class Health {
  final double? head;
  final double? thorax;
  final double? stomach;
  final double? armLeft;
  final double? armRight;
  final double? legLeft;
  final double? legRight;

  Health.fromMap(Map<String, dynamic> map)
      : assert(map['head'] != null),
        assert(map['thorax'] != null),
        assert(map['stomach'] != null),
        assert(map['left_arm'] != null),
        assert(map['right_arm'] != null),
        assert(map['left_leg'] != null),
        assert(map['right_leg'] != null),
        head = map['head'].toDouble(),
        thorax = map['thorax'].toDouble(),
        stomach = map['stomach'].toDouble(),
        armLeft = map['left_arm'].toDouble(),
        armRight = map['right_arm'].toDouble(),
        legLeft = map['left_leg'].toDouble(),
        legRight = map['right_leg'].toDouble();

  Health.fromReference(bindings.PersonHealth health)
      : head = health.head,
        thorax = health.thorax,
        stomach = health.stomach,
        armLeft = health.arm_left,
        armRight = health.arm_right,
        legLeft = health.leg_left,
        legRight = health.leg_right;

  double get total =>
      head! + thorax! + stomach! + armLeft! + armRight! + legLeft! + legRight!;
}
