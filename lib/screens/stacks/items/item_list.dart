import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../common/error.dart';
import '../../../firebase.dart';
import '../../../models/items/item.dart';
import '../../../providers/item.dart';
import 'item_compare.dart';
import 'item_detail.dart';

class ItemListScreenArguments {
  final String title;
  final Query query;

  const ItemListScreenArguments({
    @required this.title,
    @required this.query,
  });
}

class ItemListScreen<T extends ExplorableItem> extends StatelessWidget {
  static const String routeName = '/items/list';

  const ItemListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemListScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: ItemList<T>(query: args.query),
    );
  }
}

class ItemList<T extends ExplorableItem> extends StatefulWidget {
  final Query query;

  const ItemList({
    Key key,
    @required this.query,
  }) : super(key: key);

  @override
  _ItemListState<T> createState() => _ItemListState<T>();
}

class _ItemListState<T extends ExplorableItem> extends State<ItemList<T>> {
  ItemProvider<T> _provider;
  List<T> _items;
  FirebaseException _error;

  void _onData(List<T> sections) {
    setState(() {
      _items = sections;
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

  Widget _buildSeparator(BuildContext context, int index) {
    return const SizedBox(height: 15);
  }

  Widget _buildListItem(BuildContext context, int index) {
    final item = _items[index];

    return ItemCard(
      key: Key(item.id),
      item: item,
      fontSize: Theme.of(context).textTheme.headline4.fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return ErrorScreen();

    if (_items == null) return const Center(child: CircularProgressIndicator());

    return ListView.separated(
      itemCount: _items.length,
      padding: const EdgeInsets.all(15),
      separatorBuilder: _buildSeparator,
      itemBuilder: _buildListItem,
    );
  }
}

class ItemSectionListScreenArguments {
  final String title;
  final Query query;
  final bool sortSections;

  const ItemSectionListScreenArguments({
    @required this.title,
    @required this.query,
    this.sortSections = false,
  });
}

class ItemSectionListScreen<T extends ExplorableSectionItem>
    extends StatelessWidget {
  static const String routeName = '/items/sectionList';

  const ItemSectionListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemSectionListScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: SectionList<T>(
        args.query,
        sortSections: args.sortSections,
      ),
    );
  }
}

class SectionList<T extends ExplorableSectionItem> extends StatefulWidget {
  final Query query;
  final bool sortSections;

  const SectionList(
    this.query, {
    Key key,
    this.sortSections,
  }) : super(key: key);

  @override
  _SectionListState<T> createState() => _SectionListState<T>();
}

class _SectionListState<T extends ExplorableSectionItem>
    extends State<SectionList<T>> {
  ItemSectionProvider<T> _provider;
  List<ItemSection<T>> _sections;
  FirebaseException _error;

  void _onData(List<ItemSection<T>> sections) {
    setState(() {
      _sections = sections;
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
    _provider = ItemSectionProvider(
      widget.query,
      sortSections: widget.sortSections,
    );
    _provider.init();
    _provider.stream.listen(_onData, onError: _onError);
  }

  @override
  void dispose() {
    _provider.dispose();
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
            _sections.expand((e) => e.items).toList(growable: false),
            HashSet.from(_sections[index].items.map<String>((e) => e.id)),
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, int index) {
    return const SizedBox(height: 15);
  }

  Widget _buildSectionItem(BuildContext context, int section, int index) {
    final item = _sections[section].items[index];

    return ItemCard<T>(key: Key(item.id), item: item);
  }

  Widget _buildSection(BuildContext context, int index) {
    final section = _sections[index];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        key: Key(section.title),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  section.title,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).textTheme.bodyText2.color,
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: section.items.length > 1
                        ? () => _onCompare(index)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        'Compare',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: section.items.length > 1
                                  ? Theme.of(context).accentColor
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                      ),
                    ),
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
      itemCount: _sections.length,
      separatorBuilder: _buildSeparator,
      itemBuilder: _buildSection,
    );
  }
}

class ItemCard<T extends ExplorableItem> extends StatefulWidget {
  final T item;
  final double fontSize;
  final double shape;

  static const StorageImage _image = StorageImage();
  static const AssetImage _placeholder =
      AssetImage('assets/images/placeholders/generic.png');

  const ItemCard({
    Key key,
    @required this.item,
    this.fontSize,
    this.shape = 8,
  }) : super(key: key);

  @override
  _ItemCardState<T> createState() => _ItemCardState<T>();
}

class _ItemCardState<T extends ExplorableItem> extends State<ItemCard<T>> {
  Widget _image;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) _image = _getStorageImage(widget.item);
  }

  @override
  void didUpdateWidget(ItemCard old) {
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
    return FutureBuilder<ImageProvider>(
      future: ItemCard._image.getItemImage(item.type, item.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Image(image: ItemCard._placeholder, fit: BoxFit.cover);
        }

        return FadeInImage(
          image: snapshot.data,
          placeholder: ItemCard._placeholder,
          imageErrorBuilder: (context, error, stackTrace) =>
              const Image(image: ItemCard._placeholder, fit: BoxFit.cover),
          fit: BoxFit.cover,
        );
      },
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
              style: Theme.of(context).textTheme.headline5.copyWith(
                fontSize: widget.fontSize ??
                    Theme.of(context).textTheme.headline5.fontSize,
                color: Theme.of(context).textTheme.bodyText2.color,
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
