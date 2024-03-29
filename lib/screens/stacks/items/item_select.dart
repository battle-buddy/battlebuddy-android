import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../common/error.dart';
import '../../../models/items/item.dart';
import '../../../providers/item.dart';
import 'item_compare.dart';

class ItemSelectScreenArguments {
  final Query query;
  final String? selectedID;
  final bool sortSections;

  const ItemSelectScreenArguments({
    required this.query,
    this.selectedID,
    this.sortSections = false,
  });
}

class ItemSelectScreen<T extends ExplorableItem> extends StatefulWidget {
  static const String title = 'Compare to\u{2026}';
  static const String routeName = '/items/select';

  const ItemSelectScreen({super.key});

  @override
  State<ItemSelectScreen<T>> createState() => _ItemSelectScreenState<T>();
}

class _ItemSelectScreenState<T extends ExplorableItem>
    extends State<ItemSelectScreen<T>> {
  ItemComparisonScreenArguments<T>? _compareArgs;

  void _onNext() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ItemComparisonScreen<T>(),
        settings: RouteSettings(
          name: ItemComparisonScreen.routeName,
          arguments: _compareArgs,
        ),
      ),
    );
  }

  void _onChange(List<T> items, HashSet<String> selection) {
    setState(() {
      _compareArgs = ItemComparisonScreenArguments(items, selection);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ItemSelectScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text(ItemSelectScreen.title),
      ),
      bottomNavigationBar: SizedBox(
        height: 45,
        child: TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            disabledBackgroundColor: Theme.of(context).colorScheme.background,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          label: const Text('Compare'),
          icon: const Icon(Icons.navigate_next),
          onPressed:
              _compareArgs != null && _compareArgs!.selectedIDs.length > 1
                  ? _onNext
                  : null,
        ),
      ),
      body: ItemSelectList<T>(
        args.query,
        selectedID: args.selectedID,
        onChange: _onChange,
      ),
    );
  }
}

class ItemSelectList<T extends Item> extends StatefulWidget {
  final Query query;
  final String? selectedID;
  final void Function(List<T>, HashSet<String>)? onChange;

  const ItemSelectList(
    this.query, {
    super.key,
    this.selectedID,
    this.onChange,
  });

  @override
  State<ItemSelectList<T>> createState() => _ItemSelectListState<T>();
}

class _ItemSelectListState<T extends Item> extends State<ItemSelectList<T>> {
  late ItemProvider<T> _provider;
  List<T>? _items;
  FirebaseException? _error;

  HashSet<String>? _selection;

  void _onData(List<T>? items) {
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

    _provider = ItemProvider(widget.query);
    _provider.stream.listen(_onData, onError: _onError);

    _selection = HashSet();
    if (widget.selectedID != null) _selection!.add(widget.selectedID!);
  }

  void onChange(Item item, {bool? value}) {
    if (value!) {
      _selection!.add(item.id);
    } else {
      _selection!.remove(item.id);
    }

    setState(() {
      _selection = _selection;
    });

    widget.onChange!(_items!, _selection!);
  }

  Widget _buildSeparator(BuildContext context, int index) {
    return const Divider(height: 0);
  }

  Widget _buildSection(BuildContext context, int index) {
    final item = _items![index];

    return ItemTile(
      key: Key(item.id),
      item: item,
      isSelected: _selection!.contains(item.id),
      onChange: onChange,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return const ErrorScreen();

    if (_items == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      shrinkWrap: false,
      itemCount: _items!.length,
      separatorBuilder: _buildSeparator,
      itemBuilder: _buildSection,
    );
  }
}

class ItemSectionSelectScreen<T extends ExplorableSectionItem>
    extends StatefulWidget {
  static const String title = 'Compare to\u{2026}';
  static const String routeName = '/items/sectionSelect';

  const ItemSectionSelectScreen({super.key});

  @override
  State<ItemSectionSelectScreen<T>> createState() =>
      _ItemSectionSelectScreenState<T>();
}

class _ItemSectionSelectScreenState<T extends ExplorableSectionItem>
    extends State<ItemSectionSelectScreen<T>> {
  ItemComparisonScreenArguments<T>? _compareArgs;

  void _onNext() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ItemComparisonScreen<T>(),
        settings: RouteSettings(
          name: ItemComparisonScreen.routeName,
          arguments: _compareArgs,
        ),
      ),
    );
  }

  void _onChange(List<T> items, HashSet<String> selection) {
    setState(() {
      _compareArgs = ItemComparisonScreenArguments(items, selection);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ItemSelectScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text(ItemSectionSelectScreen.title),
      ),
      bottomNavigationBar: SizedBox(
        height: 45,
        child: TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            disabledBackgroundColor: Theme.of(context).colorScheme.background,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          label: const Text('Compare'),
          icon: const Icon(Icons.navigate_next),
          onPressed:
              _compareArgs != null && _compareArgs!.selectedIDs.length > 1
                  ? _onNext
                  : null,
        ),
      ),
      body: ItemSelectSectionList<T>(
        args.query,
        sortSections: args.sortSections,
        selectedID: args.selectedID,
        onChange: _onChange,
      ),
    );
  }
}

class ItemSelectSectionList<T extends SectionView> extends StatefulWidget {
  final Query? query;
  final bool sortSections;
  final String? selectedID;
  final void Function(List<T>, HashSet<String>)? onChange;

  const ItemSelectSectionList(
    this.query, {
    super.key,
    this.sortSections = false,
    this.selectedID,
    this.onChange,
  });

  @override
  State<ItemSelectSectionList<T>> createState() =>
      _ItemSelectSectionListState<T>();
}

class _ItemSelectSectionListState<T extends SectionView>
    extends State<ItemSelectSectionList<T>> {
  late ItemSectionProvider<T> _provider;
  List<ItemSection<T>>? _sections;
  FirebaseException? _error;

  HashSet<String>? _selection;

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

    _provider = ItemSectionProvider(
      widget.query,
      sortSections: widget.sortSections,
    );
    _provider.stream.listen(_onData, onError: _onError);

    _selection = HashSet();
    if (widget.selectedID != null) _selection!.add(widget.selectedID!);
  }

  void onChange(Item item, {bool? value}) {
    if (value!) {
      _selection!.add(item.id);
    } else {
      _selection!.remove(item.id);
    }

    setState(() {
      _selection = _selection;
    });

    widget.onChange!(
        _sections!.expand((e) => e.items).toList(growable: false), _selection!);
  }

  Widget _buildSeparator(BuildContext context, int index) {
    return const SizedBox(height: 15);
  }

  Widget _buildSection(BuildContext context, int index) {
    final section = _sections![index];

    return Column(
      key: Key(section.title!),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            section.title!,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.grey[400]),
          ),
        ),
        Column(
          children: ListTile.divideTiles(
            context: context,
            tiles: section.items.map(
              (item) => ItemTile(
                key: Key(item.id),
                item: item,
                isSelected: _selection!.contains(item.id),
                onChange: onChange,
              ),
            ),
          ).toList(growable: false),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return const ErrorScreen();

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

class ItemTile extends StatefulWidget {
  final Item item;
  final bool isSelected;
  final void Function(Item, {bool value}) onChange;

  const ItemTile({
    super.key,
    required this.item,
    this.isSelected = false,
    required this.onChange,
  });

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  bool? _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(ItemTile old) {
    super.didUpdateWidget(old);
    if (old.isSelected != widget.isSelected) {
      _isSelected = widget.isSelected;
    }
  }

  // ignore: avoid_positional_boolean_parameters
  void onChanged(bool? value) {
    widget.onChange(widget.item, value: value!);
    setState(() {
      _isSelected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: CheckboxListTile(
        title: Text(
          widget.item.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        value: _isSelected,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
