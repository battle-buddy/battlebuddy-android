import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../models/items/ammunition.dart';
import '../models/items/armor.dart';
import '../models/items/chestrig.dart';
import '../models/items/firearm.dart';
import '../models/items/item.dart';
import '../models/items/medical.dart';
import '../models/items/melee.dart';
import '../models/items/throwable.dart';

class ItemProvider<T extends Item> {
  final Query query;

  StreamSubscription<QuerySnapshot> _firebaseStream;
  List<T> _items;

  final StreamController<List<T>> _controller = StreamController();

  ItemProvider(this.query);

  void _sendData() {
    _controller.add(_items);
  }

  Future<void> _onData(QuerySnapshot snapshot) async {
    _items = snapshot.docs.map<T>(_serializeSnapshot).toList(growable: false);
    _sendData();
  }

  void _onError(Object error) {
    print(error.toString());
    _controller.addError(error);
  }

  void init() {
    _firebaseStream = query.snapshots().listen(_onData, onError: _onError);
  }

  void dispose() {
    _controller.close();
    _firebaseStream.cancel();
  }

  Stream<List<T>> get stream => _controller.stream;
}

class ItemSection<T extends SectionView> {
  final String title;
  final List<T> items;

  ItemSection({
    @required this.title,
    @required this.items,
  });
}

class ItemSectionProvider<T extends SectionView> {
  final Query query;
  final bool sortSections;

  StreamSubscription<QuerySnapshot> _firebaseStream;
  List<ItemSection<T>> _sections;

  final StreamController<List<ItemSection<T>>> _controller = StreamController();

  ItemSectionProvider(
    this.query, {
    this.sortSections = false,
  });

  void _sendData() {
    _controller.add(_sections);
  }

  Future<void> _onData(QuerySnapshot snapshot) async {
    _sections = _buildSections(snapshot);
    _sendData();
  }

  void _onError(Object error) {
    print(error.toString());
    _controller.addError(error);
  }

  void init() {
    _firebaseStream = query.snapshots().listen(_onData, onError: _onError);
  }

  void dispose() {
    _controller.close();
    _firebaseStream.cancel();
  }

  List<ItemSection<T>> _buildSections(QuerySnapshot snapshot) {
    final sections = <ItemSection<T>>[];

    for (final doc in snapshot.docs) {
      final item = _serializeSnapshot<T>(doc);

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

    if (sortSections) {
      sections.sort((a, b) => a.title.compareTo(b.title));
    }

    return sections;
  }

  Stream<List<ItemSection<T>>> get stream => _controller.stream;
}

T _serializeSnapshot<T extends Item>(DocumentSnapshot snapshot) {
  switch (T) {
    case Ammunition:
      return Ammunition.fromSnapshot(snapshot) as T;
    case Armor:
      return Armor.fromSnapshot(snapshot) as T;
    case ChestRig:
      return ChestRig.fromSnapshot(snapshot) as T;
    case Firearm:
      return Firearm.fromSnapshot(snapshot) as T;
    case Medical:
      return Medical.fromSnapshot(snapshot) as T;
    case Melee:
      return Melee.fromSnapshot(snapshot) as T;
    case Throwable:
      return Throwable.fromSnapshot(snapshot) as T;
  }

  return Item.fromSnapshot(snapshot) as T;
}
