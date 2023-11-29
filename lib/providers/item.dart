import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/items/ammunition.dart';
import '../models/items/armor.dart';
import '../models/items/chestrig.dart';
import '../models/items/firearm.dart';
import '../models/items/item.dart';
import '../models/items/medical.dart';
import '../models/items/melee.dart';
import '../models/items/throwable.dart';
import '../utils/index.dart';

class ItemProvider<T extends Item> {
  final Query query;
  final bool indexing;
  final int tokenLength;

  StreamSubscription<QuerySnapshot>? _firebaseStream;
  List<T>? _items;
  InvertedIndex? _index;

  String _searchTerm = '';

  late StreamController<List<T>?> _controller;

  factory ItemProvider(
    Query query, {
    bool indexing = false,
    int tokenLength = 3,
  }) {
    final p = ItemProvider<T>._internal(query,
        indexing: indexing, tokenLength: tokenLength);

    p._controller = StreamController(
      onListen: p._onListen,
      onPause: p._onPause,
      onResume: p._onResume,
      onCancel: p._onCancel,
    );

    return p;
  }

  ItemProvider._internal(
    this.query, {
    this.indexing = false,
    this.tokenLength = 3,
  });

  void _sendData() {
    if (_searchTerm.isNotEmpty && _index != null) {
      final results = _index!.search(_searchTerm);
      final items = results.map((e) => (_items![e[0]])).toList(growable: false);
      _controller.add(items);
    } else {
      _controller.add(_items);
    }
  }

  Future<void> _onData(QuerySnapshot snapshot) async {
    _items = snapshot.docs.map<T>(_serializeSnapshot).toList(growable: false);

    if (indexing) {
      _index = InvertedIndex.fromList(_items!, tokenLength: tokenLength);
    }

    _sendData();
  }

  void _onError(Object error) {
    _controller.addError(error);
  }

  void _onPause() {
    _firebaseStream?.pause();
  }

  void _onResume() {
    _firebaseStream?.resume();
  }

  void _onListen() {
    _firebaseStream = query.snapshots().listen(_onData, onError: _onError);
  }

  void _onCancel() {
    _firebaseStream?.cancel();
    _controller.close();
  }

  Future<void> setSearchTerm(String term) async {
    if (term.length < tokenLength) return;
    _searchTerm = term;
    _sendData();
  }

  Future<void> clearSearchTerm() async {
    _searchTerm = '';
    _sendData();
  }

  Future<void> getData() async => _sendData();

  Stream<List<T>?> get stream => _controller.stream;
}

class ItemSection<T extends SectionView> {
  final String? title;
  final List<T> items;

  ItemSection({
    required this.title,
    required this.items,
  });
}

class ItemSectionProvider<T extends SectionView> {
  final Query? query;
  final bool? sortSections;
  final bool indexing;
  final int tokenLength;

  StreamSubscription<QuerySnapshot>? _firebaseStream;
  late List<T> _items;
  InvertedIndex? _index;

  String _searchTerm = '';

  late StreamController<List<ItemSection<T>>> _controller;

  factory ItemSectionProvider(
    Query? query, {
    bool? sortSections,
    bool indexing = false,
    int tokenLength = 3,
  }) {
    final p = ItemSectionProvider<T>._internal(
      query,
      sortSections: sortSections,
      indexing: indexing,
      tokenLength: tokenLength,
    );

    p._controller = StreamController(
      onListen: p._onListen,
      onPause: p._onPause,
      onResume: p._onResume,
      onCancel: p._onCancel,
    );

    return p;
  }

  ItemSectionProvider._internal(
    this.query, {
    this.sortSections = false,
    this.indexing = false,
    this.tokenLength = 3,
  });

  void _sendData() {
    if (_searchTerm.isNotEmpty && _index != null) {
      final results = _index!.search(_searchTerm);
      final items = results.map((e) => (_items[e[0]])).toList(growable: false);
      _controller.add(_buildSections(items));
    } else {
      _controller.add(_buildSections(_items));
    }
  }

  Future<void> _onData(QuerySnapshot snapshot) async {
    _items = snapshot.docs.map<T>(_serializeSnapshot).toList(growable: false);

    if (indexing) {
      _index = InvertedIndex.fromList(_items, tokenLength: tokenLength);
    }

    _sendData();
  }

  void _onError(Object error) {
    _controller.addError(error);
  }

  void _onPause() {
    _firebaseStream?.pause();
  }

  void _onResume() {
    _firebaseStream?.resume();
  }

  void _onListen() {
    _firebaseStream = query!.snapshots().listen(_onData, onError: _onError);
  }

  void _onCancel() {
    _firebaseStream?.cancel();
    _controller.close();
  }

  List<ItemSection<T>> _buildSections(List<T> items) {
    final sections = <ItemSection<T>>[];

    for (final item in items) {
      final title = item.sectionValue;
      final index = sections.indexWhere((e) => e.title == title);

      if (index == -1) {
        sections.add(ItemSection(
          title: title,
          items: [item],
        ));
      } else {
        sections[index].items.add(item);
      }
    }

    if (sortSections!) {
      sections.sort((a, b) => a.title!.compareTo(b.title!));
    }

    return sections;
  }

  Future<void> setSearchTerm(String term) async {
    if (term.length < tokenLength) return;
    _searchTerm = term;
    _sendData();
  }

  Future<void> clearSearchTerm() async {
    _searchTerm = '';
    _sendData();
  }

  Stream<List<ItemSection<T>>> get stream => _controller.stream;
}

T _serializeSnapshot<T extends Item>(DocumentSnapshot snapshot) {
  switch (T) {
    case const (Ammunition):
      return Ammunition.fromSnapshot(snapshot) as T;
    case const (Armor):
      return Armor.fromSnapshot(snapshot) as T;
    case const (ChestRig):
      return ChestRig.fromSnapshot(snapshot) as T;
    case const (Firearm):
      return Firearm.fromSnapshot(snapshot) as T;
    case const (Medical):
      return Medical.fromSnapshot(snapshot) as T;
    case const (Melee):
      return Melee.fromSnapshot(snapshot) as T;
    case const (Throwable):
      return Throwable.fromSnapshot(snapshot) as T;
  }

  return Item.fromSnapshot(snapshot) as T;
}
