import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../common/error.dart';

class PenetrationChanceHelpScreen extends StatelessWidget {
  static const String title = 'Penetration Chance Calculator';
  static const String routeName = '/learn/penChanceHelp';

  PenetrationChanceHelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: PenetrationChanceHelp(),
    );
  }
}

class PenetrationChanceHelp extends StatelessWidget {
  Future<Map<String, String>> _loadText(BuildContext context) async {
    final data = await DefaultAssetBundle.of(context)
        .loadString('assets/texts/help.json');
    final Map<String, dynamic> jsonMap = json.decode(data);

    return jsonMap.map((k, dynamic v) => MapEntry(k, v as String));
  }

  Widget _builder(
      BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
    if (snapshot.hasError) return ErrorScreen();

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = snapshot.data;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Text(data['penetration_chance']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadText(context),
      builder: _builder,
    );
  }
}
