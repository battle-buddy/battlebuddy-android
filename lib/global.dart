import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info/package_info.dart';

import 'models/common/metadata.dart';

Metadata metadata;

Future<void> loadMetadata() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('global')
        .doc('metadata')
        .get()
        .then((snapshot) => snapshot);
    metadata = Metadata.fromSnapshot(snapshot);
  } on FirebaseException catch (e) {
    print('Error while getting metadata: $e');
    rethrow;
  }
}

AppInfo appInfo;

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
  } on Exception catch (e) {
    print('Error while getting package info: $e');
    rethrow;
  }
}
