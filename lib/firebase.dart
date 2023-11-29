import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'models/items/item.dart';

late FirebaseAnalytics analytics;

Future<void> initializeSession() async {
  try {
    await Firebase.initializeApp();
    final creds = await FirebaseAuth.instance.signInAnonymously();
    analytics = FirebaseAnalytics.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(creds.user!.uid)
        .set(<String, dynamic>{'lastLogin': Timestamp.now()},
            SetOptions(merge: true));

    if (!kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      await FirebaseCrashlytics.instance.setUserIdentifier(creds.user!.uid);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
  } on FirebaseException catch (_) {
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
  }
}

class StorageImage {
  final ImageSize size;

  static final FirebaseStorage _storage = FirebaseStorage.instance;

  const StorageImage({this.size = ImageSize.medium});

  FirebaseImageProvider getItemImage(ItemType? type, String? id) {
    final filename = '${id}_${size.string}.jpg';

    var ref = _storage.ref();
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
      default:
    }

    final path = ref.child(filename).fullPath;
    final bucket = ref.bucket;
    return FirebaseImageProvider(
        FirebaseUrl(
          'gs://$bucket/$path',
          app: Firebase.app(),
        ),
        options: const CacheOptions(
          checkForMetadataChange: true,
          metadataRefreshInBackground: false,
        ));
  }

  FirebaseImageProvider getCharacterImage(String? id) {
    final filename = '${id}_avatar.png';
    final ref = _storage.ref().child('character');

    final path = ref.child(filename).fullPath;
    final bucket = ref.bucket;
    return FirebaseImageProvider(
        FirebaseUrl(
          'gs://$bucket/$path',
          app: Firebase.app(),
        ),
        options: const CacheOptions(
          checkForMetadataChange: true,
          metadataRefreshInBackground: false,
        ));
  }
}
