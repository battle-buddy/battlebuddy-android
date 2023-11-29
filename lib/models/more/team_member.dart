import 'package:cloud_firestore/cloud_firestore.dart';

class TeamMember {
  final String id;
  final String name;
  final Uri url;
  final bool live;

  final DocumentReference reference;

  TeamMember.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['url'] != null),
        assert(map['live'] != null),
        id = map['id'],
        name = map['name'],
        url = Uri.parse(map['url']),
        live = map['live'];

  TeamMember.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);
}
