import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'models/common/metadata.dart';

late Metadata metadata;

Future<void> loadMetadata() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('global')
        .doc('metadata')
        .get()
        .then((snapshot) => snapshot);
    metadata = Metadata.fromSnapshot(snapshot);
  } on FirebaseException catch (_) {
    rethrow;
  }
}

late AppInfo appInfo;

class AppInfo {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  AppInfo.fromPackage(PackageInfo package)
      : appName = package.appName,
        packageName = package.packageName,
        version = package.version,
        buildNumber = package.buildNumber;
}

Future<void> loadAppInfo() async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    appInfo = AppInfo.fromPackage(packageInfo);
  } on Exception catch (_) {
    rethrow;
  }
}
