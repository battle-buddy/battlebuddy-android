import 'package:cloud_firestore/cloud_firestore.dart';

class Attribution {
  final String title;
  final String subtitle;
  final Uri? url;
  final int index;

  final DocumentReference? reference;

  Attribution.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['subtitle'] != null),
        assert(map['index'] != null),
        title = map['title'],
        subtitle = map['subtitle'],
        url = map['link'],
        index = map['index'].toInt();

  Attribution.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);
}
