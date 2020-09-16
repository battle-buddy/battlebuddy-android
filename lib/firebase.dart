import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';

import 'models/items/item.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

Future<void> initializeSession() async {
  print('Initializing anonymous session...');

  try {
    await Firebase.initializeApp();
    final creds = await FirebaseAuth.instance.signInAnonymously();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(creds.user.uid)
        .set(<String, dynamic>{'lastLogin': Timestamp.now()},
            SetOptions(merge: true));

    print('Anonymous session initialized ${creds.user.uid}');
  } on FirebaseException catch (e) {
    print('Initialization failed: $e');
    rethrow;
  }
}

enum ImageSize {
  full,
  large,
  medium,
}

extension Format on ImageSize {
  String get string {
    switch (this) {
      case ImageSize.full:
        return 'full';
      case ImageSize.large:
        return 'large';
      case ImageSize.medium:
        return 'medium';
    }

    return null;
  }
}

class StorageImage {
  final ImageSize size;

  static final StorageReference _storageReference =
      FirebaseStorage.instance.ref();

  const StorageImage({this.size = ImageSize.medium});

  Future<ImageProvider<FirebaseImage>> getItemImage(
      ItemType type, String id) async {
    final filename = '${id}_${size.string}.jpg';

    var ref = _storageReference.getRoot();
    switch (type) {
      case ItemType.ammo:
        ref = ref.child('ammo');
        break;
      case ItemType.armor:
      case ItemType.bodyArmor:
      case ItemType.helmet:
      case ItemType.attachment:
        ref = ref.child('armor');
        break;
      case ItemType.chestRig:
        ref = ref.child('rigs');
        break;
      case ItemType.firearm:
        ref = ref.child('guns');
        break;
      case ItemType.medical:
        ref = ref.child('meds');
        break;
      case ItemType.melee:
        ref = ref.child('melee');
        break;
      case ItemType.throwable:
        ref = ref.child('throwables');
        break;
    }

    try {
      final path = await ref.child(filename).getPath();
      final bucket = await ref.getBucket();
      return FirebaseImage(
        'gs://$bucket/$path',
        firebaseApp: Firebase.app(),
      );
    } on FirebaseException {
      rethrow;
    }
  }
}
