import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../common/error.dart';
import '../../../models/items/item.dart';
import '../../../providers/item.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ItemTableScreenArguments {
  final String title;
  final Query? query;
  final String? sortedBy;

  ItemTableScreenArguments({
    required this.title,
    required this.query,
    this.sortedBy,
  });
}

class ItemTableScreen<T extends TableView> extends StatefulWidget {
  static const String routeName = '/learn/itemTable';

  ItemTableScreen({Key? key}) : super(key: key);

  @override
  _ItemTableScreenState<T> createState() => _ItemTableScreenState<T>();
}

class _ItemTableScreenState<T extends TableView>
    extends State<ItemTableScreen<T>> {
  late ItemProvider<T> _provider;

  bool _searchBar = false;

  @override
  void didChangeDependencies() {
    final ItemTableScreenArguments args =
        ModalRoute.of(context)!.settings.arguments as ItemTableScreenArguments;
    _provider = ItemProvider(
      args.query,
      indexing: true,
      tokenLength: 2,
    );
    super.didChangeDependencies();
  }

  void _onSearchPress() {
    setState(() {
      _searchBar = !_searchBar;
    });
    if (!_searchBar) _provider.clearSearchTerm();
  }

  void _onSearchInput(String text) {
    if (text.length >= 2) {
      _provider.setSearchTerm(text);
    } else {
      _provider.clearSearchTerm();
    }
  }

  Widget _buildSearchField() {
    return TextField(
      maxLines: 1,
      keyboardAppearance: Brightness.dark,
      autocorrect: false,
      autofocus: true,
      cursorColor: Colors.red,
      decoration: const InputDecoration.collapsed(
        // border: InputBorder.none,
        hintText: 'Search\u{2026}',
      ),
      onChanged: _onSearchInput,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ItemTableScreenArguments? args =
        ModalRoute.of(context)!.settings.arguments as ItemTableScreenArguments?;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: _searchBar ? _buildSearchField() : Text(args!.title),
        actions: <IconButton>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearchPress,
          ),
        ],
      ),
      body: ItemTable<T>(_provider.stream),
    );
  }
}

class ItemDualTableScreenArguments {
  final String title;
  final List<String> tabNames;
  final List<Query?> query;
  final List<String>? sortedBy;

  ItemDualTableScreenArguments({
    required this.title,
    required this.tabNames,
    required this.query,
    this.sortedBy,
  });
}

class ItemDualTableScreen<T1 extends TableView, T2 extends TableView>
    extends StatefulWidget {
  static const String routeName = '/learn/itemDualTable';

  ItemDualTableScreen({Key? key}) : super(key: key);

  @override
  _ItemDualTableScreenState<T1, T2> createState() =>
      _ItemDualTableScreenState<T1, T2>();
}

class _ItemDualTableScreenState<T1 extends TableView, T2 extends TableView>
    extends State<ItemDualTableScreen<T1, T2>> {
  ItemProvider<T1>? _provider0;
  ItemProvider<T2>? _provider1;

  StreamSubscription<List<T1>?>? _subscription0;
  StreamSubscription<List<T2>?>? _subscription1;

  Stream<List<T1>?>? _stream0;
  Stream<List<T2>?>? _stream1;

  int _selectedTab = 0;
  bool _searchBar = false;

  @override
  void didChangeDependencies() {
    final ItemDualTableScreenArguments args =
        ModalRoute.of(context)!.settings.arguments as ItemDualTableScreenArguments;

    _provider0 = ItemProvider<T1>(
      args.query[0],
      indexing: true,
      tokenLength: 2,
    );
    _stream0 = _provider0!.stream.asBroadcastStream(
      onListen: (stream) {
        _subscription0 ??= stream;
        _onListen(_provider0, stream);
      },
      onCancel: (stream) => stream.pause(),
    );

    _provider1 = ItemProvider<T2>(
      args.query[1],
      indexing: true,
      tokenLength: 2,
    );
    _stream1 = _provider1!.stream.asBroadcastStream(
      onListen: (stream) {
        _subscription1 ??= stream;
        _onListen(_provider1, stream);
      },
      onCancel: (stream) => stream.pause(),
    );

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _subscription0?.cancel();
    _subscription1?.cancel();
    super.dispose();
  }

  Future<void> _onListen(
      ItemProvider? provider, StreamSubscription stream) async {
    if (stream.isPaused) {
      stream.resume();
      await provider!.getData();
    }
  }

  void _onSearchPress() {
    setState(() {
      _searchBar = !_searchBar;
    });

    if (!_searchBar) {
      if (_selectedTab == 1) {
        _provider1!.clearSearchTerm();
      } else {
        _provider0!.clearSearchTerm();
      }
    }
  }

  void _onSearchInput(String text) {
    if (text.length >= 2) {
      if (_selectedTab == 1) {
        _provider1!.setSearchTerm(text);
      } else {
        _provider0!.setSearchTerm(text);
      }
    } else {
      if (_selectedTab == 1) {
        _provider1!.clearSearchTerm();
      } else {
        _provider0!.clearSearchTerm();
      }
    }
  }

  Widget _buildSearchField() {
    return TextField(
      maxLines: 1,
      keyboardAppearance: Brightness.dark,
      autocorrect: false,
      autofocus: true,
      cursorColor: Colors.red,
      decoration: const InputDecoration.collapsed(
        // border: InputBorder.none,
        hintText: 'Search\u{2026}',
      ),
      onChanged: _onSearchInput,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ItemDualTableScreenArguments args =
        ModalRoute.of(context)!.settings.arguments as ItemDualTableScreenArguments;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: _searchBar ? _buildSearchField() : Text(args.title),
          actions: <IconButton>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _onSearchPress,
            ),
          ],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Tab>[
              Tab(text: args.tabNames[0]),
              Tab(text: args.tabNames[1]),
            ],
            onTap: (index) => _selectedTab = index,
          ),
        ),
        body: TabBarView(
          children: <ItemTable>[
            ItemTable<T1>(_stream0),
            ItemTable<T2>(_stream1),
          ],
        ),
      ),
    );
  }
}

class ItemTable<T extends TableView> extends StatefulWidget {
  final Stream<List<T>?>? stream;

  const ItemTable(this.stream, {Key? key}) : super(key: key);

  @override
  _ItemTableItemTableState<T> createState() => _ItemTableItemTableState<T>();
}

class _ItemTableItemTableState<T extends TableView>
    extends State<ItemTable<T>> {
  late StreamSubscription<List<T>?> _stream;
  List<T>? _items;

  FirebaseException? _error;

  List<String>? _headers;
  Sorted? _sortedBy;

  void _onData(List<T>? items) {
    _headers ??= items!.first.tableHeaders;

    setState(() {
      _items = items;
    });
  }

  void _onError(Object error) {
    setState(() {
      _error = error as FirebaseException?;
    });
  }

  @override
  void initState() {
    super.initState();
    _stream = widget.stream!.listen(_onData, onError: _onError);
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  void _onTab(BuildContext context, T item) {
    Navigator.pop<T>(context, item);
  }

  void _onSort(int index) {
    var descending = _sortedBy?.descending ?? false;

    if (index == _sortedBy?.index) {
      descending = !descending;
    }

    if (descending) {
      _items!.sort((a, b) => b.tableData[index].compareTo(a.tableData[index]));
    } else {
      _items!.sort((a, b) => a.tableData[index].compareTo(b.tableData[index]));
    }

    setState(() {
      _sortedBy = Sorted(index, descending: descending);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return ErrorScreen();

    if (_items == null) return const Center(child: CircularProgressIndicator());

    final columnWidth = MediaQuery.of(context).size.width / _headers!.length;

    return Column(
      children: <Widget>[
        Container(
          child: Row(
            key: const Key('header'),
            children: _headers!
                .asMap()
                .entries
                .map(
                  (header) => Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: InkWell(
                      onTap: () => _onSort(header.key),
                      child: Container(
                        width: columnWidth,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        child: Text(
                          header.value,
                          style: Theme.of(context).textTheme.subtitle2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: _items!.length,
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemBuilder: (BuildContext context, int index) {
              final item = _items![index];

              return Material(
                key: Key(item.id!),
                color: Colors.black54,
                child: InkWell(
                  onTap: () => _onTab(context, item),
                  child: Row(
                    children: item.tableData
                        .map(
                          (dynamic e) => Container(
                            width: columnWidth,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 20,
                            ),
                            child: Text(
                              e.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Sorted {
  final int index;
  final bool descending;

  Sorted(this.index, {this.descending = false});
}
