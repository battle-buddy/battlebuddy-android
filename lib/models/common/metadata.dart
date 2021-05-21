import 'package:cloud_firestore/cloud_firestore.dart';

class Metadata {
  final int? totalUserCount;
  final int? totalLoyalty;
  final Timestamp? lastWipe;
  final CurrencyMetadata currency;
  final List<Loyalty> loyalty;
  final Map<String, AmmoMetadata> ammo;

  final DocumentReference? reference;

  Metadata.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['totalUserCount'] != null),
        assert(map['totalLoyalty'] != null),
        assert(map['lastWipe'] != null),
        assert(map['currency'] != null),
        assert(map['loyalty'] != null),
        assert(map['ammoMetadata'] != null),
        totalUserCount = map['totalUserCount'],
        totalLoyalty = map['totalLoyalty'],
        lastWipe = map['lastWipe'],
        currency = CurrencyMetadata.fromMap(map['currency']),
        loyalty = List<Loyalty>.from(
            map['loyalty'].map((dynamic c) => Loyalty.fromMap(c)),
            growable: false),
        ammo = Map<String, AmmoMetadata>.fromEntries(
          (map['ammoMetadata'] as Map<String, dynamic>).entries.map((e) =>
              MapEntry<String, AmmoMetadata>(
                  e.key, AmmoMetadata.fromMap(e.value))),
        );

  Metadata.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);
}

class CurrencyMetadata {
  final int rub;
  final int eur;
  final int usd;

  CurrencyMetadata.fromMap(Map<String, dynamic> map)
      : assert(map['rub'] != null),
        assert(map['eur'] != null),
        assert(map['usd'] != null),
        rub = map['rub'],
        eur = map['eur'],
        usd = map['usd'];
}

class AmmoMetadata {
  final String? displayName;
  final int? index;

  AmmoMetadata.fromMap(Map<String, dynamic> map)
      : assert(map['displayName'] != null),
        assert(map['index'] != null),
        displayName = map['displayName'],
        index = map['index'];
}

class Loyalty {
  final String? id;
  final String? name;
  final int? points;
  final Timestamp? lastLogin;

  Loyalty.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['nickname'] != null),
        assert(map['loyalty'] != null),
        assert(map['lastLogin'] != null),
        id = map['id'],
        name = map['nickname'],
        points = map['loyalty'],
        lastLogin = map['lastLogin'];
}
