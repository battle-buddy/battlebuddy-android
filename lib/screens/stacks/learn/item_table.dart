import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../common/error.dart';
import '../../../models/items/item.dart';
import '../../../providers/item.dart';

class ItemTableScreenArguments {
  final String title;
  final Query query;
  final String sortedBy;

  ItemTableScreenArguments({
    @required this.title,
    @required this.query,
    this.sortedBy,
  });
}

class ItemTableScreen<T extends TableView> extends StatelessWidget {
  static const String routeName = '/learn/itemTable';

  ItemTableScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemTableScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: ItemTable<T>(
        sortedBy: args.sortedBy,
        query: args.query,
      ),
    );
  }
}

class ItemDualTableScreenArguments {
  final String title;
  final List<String> tabNames;
  final List<Query> query;
  final List<String> sortedBy;

  ItemDualTableScreenArguments({
    @required this.title,
    @required this.tabNames,
    @required this.query,
    this.sortedBy,
  });
}

class ItemDualTableScreen<T1 extends TableView, T2 extends TableView>
    extends StatelessWidget {
  static const String routeName = '/learn/itemDualTable';

  ItemDualTableScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemDualTableScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(args.title),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Tab>[
              Tab(text: args.tabNames[0]),
              Tab(text: args.tabNames[1]),
            ],
          ),
        ),
        body: TabBarView(
          children: <ItemTable>[
            ItemTable<T1>(
              sortedBy: args.sortedBy[0],
              query: args.query[0],
            ),
            ItemTable<T2>(
              sortedBy: args.sortedBy[1],
              query: args.query[1],
            ),
          ],
        ),
      ),
    );
  }
}

class ItemTable<T extends TableView> extends StatefulWidget {
  final String sortedBy;
  final Query query;

  const ItemTable({
    Key key,
    @required this.sortedBy,
    @required this.query,
  }) : super(key: key);

  @override
  _ItemTableItemTableState<T> createState() => _ItemTableItemTableState<T>();
}

class _ItemTableItemTableState<T extends TableView>
    extends State<ItemTable<T>> {
  ItemProvider<T> _provider;

  List<T> _items;
  FirebaseException _error;

  int _columnCount;
  Sorted _sortedBy;

  void _onData(List<T> items) {
    _columnCount = items.first.tableHeaders.length;

    setState(() {
      _items = items;
    });
  }

  void _onError(Object error) {
    setState(() {
      _error = error;
    });
  }

  @override
  void initState() {
    super.initState();
    _provider = ItemProvider(widget.query);
    _provider.init();
    _provider.stream.listen(_onData, onError: _onError);
  }

  @override
  void dispose() {
    _provider.dispose();
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
      _items.sort((a, b) => b.tableData[index].compareTo(a.tableData[index]));
    } else {
      _items.sort((a, b) => a.tableData[index].compareTo(b.tableData[index]));
    }

    setState(() {
      _sortedBy = Sorted(index, descending: descending);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return ErrorScreen();

    if (_items == null) return const Center(child: CircularProgressIndicator());

    final columnWidth = MediaQuery.of(context).size.width / _columnCount;

    return Column(
      children: <Widget>[
        Container(
          child: Row(
            key: const Key('header'),
            children: _items.first.tableHeaders
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
            itemCount: _items.length,
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemBuilder: (BuildContext context, int index) {
              final item = _items[index];

              return Material(
                key: Key(item.id),
                color: Colors.black54,
                child: InkWell(
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
                  onTap: () => _onTab(context, item),
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
