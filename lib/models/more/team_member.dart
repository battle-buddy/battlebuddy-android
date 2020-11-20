import 'package:cloud_firestore/cloud_firestore.dart';

class TeamMember {
  final String id;
  final String name;
  final String url;
  final bool live;

  final DocumentReference reference;

  TeamMember.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['url'] != null),
        assert(map['live'] != null),
        id = map['id'],
        name = map['name'],
        url = map['url'],
        live = map['live'];

  TeamMember.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
