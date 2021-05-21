import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../common/error.dart';
import '../../../models/learn/character.dart';

class CharacterSelectionScreen extends StatelessWidget {
  static const String title = 'Select Character\u{2026}';
  static const String routeName = '/learn/charSelect';

  CharacterSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: CharacterSelection(),
    );
  }
}

class CharacterSelection extends StatefulWidget {
  @override
  _CharacterSelectionState createState() => _CharacterSelectionState();
}

class _CharacterSelectionState extends State<CharacterSelection> {
  List<Character>? _characters;

  FirebaseException? _error;

  void _onData(QuerySnapshot snapshot) {
    final characters = snapshot.docs
        .map((doc) => Character.fromSnapshot(doc))
        .toList(growable: false)
          ..sort((a, b) => a.index!.compareTo(b.index!));

    setState(() {
      _characters = characters;
    });
  }

  void _onError(dynamic error) {
    setState(() {
      _error = error;
    });
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('character')
        .snapshots()
        .listen(_onData, onError: _onError);
  }

  void _onTab(BuildContext context, Character character) {
    Navigator.pop<Character>(context, character);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return ErrorScreen();

    if (_characters == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      itemCount: _characters!.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) => ListTile(
        key: Key(_characters![index].id!),
        title: Text(_characters![index].name!),
        onTap: () => _onTab(context, _characters![index]),
      ),
    );
  }
}
