import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../common/error.dart';
import '../../../firebase.dart';
import '../../../models/items/item.dart';
import '../../../providers/item.dart';
import 'item_compare.dart';
import 'item_detail.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ItemListScreenArguments {
  final String title;
  final Query? query;

  const ItemListScreenArguments({
    required this.title,
    required this.query,
  });
}

class ItemListScreen<T extends ExplorableItem> extends StatefulWidget {
  static const String routeName = '/items/list';

  const ItemListScreen({Key? key}) : super(key: key);

  @override
  _ItemListScreenState<T> createState() => _ItemListScreenState<T>();
}

class _ItemListScreenState<T extends ExplorableItem>
    extends State<ItemListScreen<T>> {
  late ItemProvider<T> _provider;

  bool _searchBar = false;

  @override
  void didChangeDependencies() {
    final args =
        ModalRoute.of(context)!.settings.arguments as ItemListScreenArguments;
    _provider = ItemProvider(args.query, indexing: true, tokenLength: 2);
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
    final args =
        ModalRoute.of(context)!.settings.arguments as ItemListScreenArguments?;

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
      body: ItemList<T>(stream: _provider.stream),
    );
  }
}

class ItemList<T extends ExplorableItem> extends StatefulWidget {
  final Stream<List<T>?> stream;

  const ItemList({
    Key? key,
    required this.stream,
  }) : super(key: key);

  @override
  _ItemListState<T> createState() => _ItemListState<T>();
}

class _ItemListState<T extends ExplorableItem> extends State<ItemList<T>> {
  late StreamSubscription<List<T>?> _stream;
  List<T>? _items;
  FirebaseException? _error;

  void _onData(List<T>? sections) {
    setState(() {
      _items = sections;
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
    _stream = widget.stream.listen(_onData, onError: _onError);
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  Widget _buildSeparator(BuildContext context, int index) {
    return const SizedBox(height: 15);
  }

  Widget _buildListItem(BuildContext context, int index) {
    final item = _items![index];

    return ItemCard(
      key: Key(item.id),
      item: item,
      fontSize: Theme.of(context).textTheme.headline4!.fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return ErrorScreen();

    if (_items == null) return const Center(child: CircularProgressIndicator());

    return ListView.separated(
      itemCount: _items!.length,
      padding: const EdgeInsets.all(15),
      separatorBuilder: _buildSeparator,
      itemBuilder: _buildListItem,
    );
  }
}

class ItemSectionListScreenArguments {
  final String title;
  final Query? query;
  final bool sortSections;

  const ItemSectionListScreenArguments({
    required this.title,
    required this.query,
    this.sortSections = false,
  });
}

class ItemSectionListScreen<T extends ExplorableSectionItem>
    extends StatefulWidget {
  static const String routeName = '/items/sectionList';

  const ItemSectionListScreen({Key? key}) : super(key: key);

  @override
  _ItemSectionListScreenState<T> createState() =>
      _ItemSectionListScreenState<T>();
}

class _ItemSectionListScreenState<T extends ExplorableSectionItem>
    extends State<ItemSectionListScreen<T>> {
  late ItemSectionProvider<T> _provider;

  bool _searchBar = false;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)!.settings.arguments
        as ItemSectionListScreenArguments;
    _provider = ItemSectionProvider(
      args.query,
      sortSections: args.sortSections,
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
    final args = ModalRoute.of(context)!.settings.arguments
        as ItemSectionListScreenArguments?;

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
      body: SectionList<T>(_provider.stream),
    );
  }
}

class SectionList<T extends ExplorableSectionItem> extends StatefulWidget {
  final Stream<List<ItemSection<T>>> stream;

  const SectionList(
    this.stream, {
    Key? key,
  }) : super(key: key);

  @override
  _SectionListState<T> createState() => _SectionListState<T>();
}

class _SectionListState<T extends ExplorableSectionItem>
    extends State<SectionList<T>> {
  late StreamSubscription<List<ItemSection<T>>> _stream;
  List<ItemSection<T>>? _sections;
  FirebaseException? _error;

  void _onData(List<ItemSection<T>> sections) {
    setState(() {
      _sections = sections;
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
    _stream = widget.stream.listen(_onData, onError: _onError);
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  void _onCompare(int index) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ItemComparisonScreen<T>(),
        settings: RouteSettings(
          name: ItemComparisonScreen.routeName,
          arguments: ItemComparisonScreenArguments(
            _sections!.expand((e) => e.items).toList(growable: false),
            HashSet.from(_sections![index].items.map<String?>((e) => e.id)),
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, int index) {
    return const SizedBox(height: 15);
  }

  Widget _buildSectionItem(BuildContext context, int section, int index) {
    final item = _sections![section].items[index];

    return ItemCard<T>(key: Key(item.id), item: item);
  }

  Widget _buildSection(BuildContext context, int index) {
    final section = _sections![index];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        key: Key(section.title!),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  section.title!,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.compare_arrows),
                    iconSize: 32,
                    splashRadius: 24,
                    color: Theme.of(context).accentIconTheme.color,
                    onPressed: section.items.length > 1
                        ? () => _onCompare(index)
                        : null,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              // shrinkWrap: true,
              itemCount: section.items.length,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              separatorBuilder: (context, index) => const SizedBox(width: 15),
              itemBuilder: (context, itemIndex) =>
                  _buildSectionItem(context, index, itemIndex),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return ErrorScreen();

    if (_sections == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      shrinkWrap: false,
      itemCount: _sections!.length,
      separatorBuilder: _buildSeparator,
      itemBuilder: _buildSection,
    );
  }
}

class ItemCard<T extends ExplorableItem> extends StatefulWidget {
  final T item;
  final double? fontSize;
  final double shape;

  static const StorageImage _image = StorageImage();
  static const AssetImage _placeholder =
      AssetImage('assets/images/placeholders/generic.png');

  const ItemCard({
    Key? key,
    required this.item,
    this.fontSize,
    this.shape = 8,
  }) : super(key: key);

  @override
  _ItemCardState<T> createState() => _ItemCardState<T>();
}

class _ItemCardState<T extends ExplorableItem> extends State<ItemCard<T>> {
  Widget? _image;

  @override
  void initState() {
    super.initState();
    _image = _getStorageImage(widget.item);
  }

  @override
  void didUpdateWidget(old) {
    super.didUpdateWidget(old);
    if (widget.item.id != old.item.id) {
      _image = _getStorageImage(widget.item);
    }
  }

  void _onTab(BuildContext context, T item) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen<T>(),
        settings: RouteSettings(
          name: ItemDetailScreen.routeName,
          arguments: ItemDetailScreenArguments<T>(item: item),
        ),
      ),
    );
  }

  Widget _getStorageImage(Item item) {
    return FadeInImage(
      image: ItemCard._image.getItemImage(item.type, item.id),
      placeholder: ItemCard._placeholder,
      imageErrorBuilder: (context, error, stackTrace) =>
          const Image(image: ItemCard._placeholder, fit: BoxFit.cover),
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      color: Colors.transparent,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.shape),
      ),
      child: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.shape),
              child: _image,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              widget.item.shortName,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                fontSize: widget.fontSize ??
                    Theme.of(context).textTheme.headline5!.fontSize,
                color: Theme.of(context).textTheme.bodyText2!.color,
                fontWeight: FontWeight.w600,
                shadows: const <Shadow>[
                  Shadow(blurRadius: 5),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(onTap: () => _onTab(context, widget.item)),
            ),
          )
        ],
      ),
    );
  }
}
