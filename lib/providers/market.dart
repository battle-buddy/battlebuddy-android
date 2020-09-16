import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/learn/market_item.dart';
import '../utils/index.dart';

class MarketProvider {
  final int tokenLength;

  StreamSubscription<QuerySnapshot> _firebaseStream;
  List<MarketItem> _items = [];
  InvertedIndex _index;

  bool _showStarred = false;
  String _searchTerm = '';

  final HashSet<int> _starred = HashSet();

  final StreamController<List<MarketItem>> _controller = StreamController();

  Future<SharedPreferences> _preferences;

  static const String _storageKey = 'market_stars';

  MarketProvider({this.tokenLength = 3});

  void _sendData() {
    if (_searchTerm.isNotEmpty) {
      final results = _index.search(_searchTerm);

      List<MarketItem> items;
      if (_showStarred) {
        items = results
            .where((e) => _starred.contains(e[0]))
            .map((e) => (_items[e[0]]))
            .toList(growable: false);
      } else {
        items = results.map((e) => (_items[e[0]])).toList(growable: false);
      }

      _controller.add(items);
    } else {
      if (_showStarred) {
        final items =
            _starred.map((idx) => _items[idx]).toList(growable: false);
        items.sort((a, b) => b.slotPrice.compareTo(a.slotPrice));
        _controller.add(items);
      } else {
        _controller.add(_items);
      }
    }
  }

  Future<void> _onData(QuerySnapshot snapshot) async {
    _items = snapshot.docs
        .expand((doc) =>
            doc.data().values.map((dynamic v) => MarketItem.fromMap(v)))
        .toList(growable: false);

    _items.sort((a, b) => b.slotPrice.compareTo(a.slotPrice));

    if (_starred.isEmpty) await _getCommittedStars();

    _index = InvertedIndex.fromList(_items, tokenLength: tokenLength);

    _sendData();
  }

  void _onError(Object error) {
    print(error.toString());
    _controller.addError(error);
  }

  void init() {
    _preferences = SharedPreferences.getInstance();
    _firebaseStream = FirebaseFirestore.instance
        .collection('market')
        .snapshots()
        .listen(_onData, onError: _onError);
  }

  void dispose() {
    _controller.close();
    _firebaseStream.cancel();
  }

  Future<void> _getCommittedStars() async {
    try {
      final prefs = await _preferences;
      if (!prefs.containsKey(_storageKey)) return;

      final ids = prefs.getStringList(_storageKey);
      _starred.addAll(
        ids.map((id) => _items.indexWhere((item) => item.id == id)),
      );

      for (final idx in _starred) {
        _items[idx].isStarred = true;
      }
    } on Exception catch (e) {
      print('Error while getting committed starred IDs: $e');
    }
  }

  Future<void> _setCommittedStars() async {
    try {
      final prefs = await _preferences;
      final ids = _starred.map((idx) => _items[idx].id).toList(growable: false);
      await prefs.setStringList(_storageKey, ids);
    } on Exception catch (e) {
      print('Error while committing starred IDs: $e');
    }
  }

  Future<void> addStar(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (_starred.add(index)) {
      _items[index].isStarred = true;
      await _setCommittedStars();
    }
  }

  Future<void> deleteStar(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (_starred.remove(index)) {
      _items[index].isStarred = false;
      await _setCommittedStars();
    }
  }

  Future<void> filterByStars({bool filter}) async {
    if (_showStarred == filter || _starred == null || _starred.isEmpty) return;
    _showStarred = filter;
    _sendData();
  }

  Future<void> setSearchTerm(String term) async {
    if (term.length < 3) return;
    _searchTerm = term;
    _sendData();
  }

  Future<void> clearSearchTerm() async {
    _searchTerm = '';
    _sendData();
  }

  Stream<List<MarketItem>> get stream => _controller.stream;
}
