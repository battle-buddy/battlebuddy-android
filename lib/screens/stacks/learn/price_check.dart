import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/error.dart';
import '../../../models/learn/market_item.dart';
import '../../../providers/market.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class PriceCheckScreenArguments {}

class PriceCheckScreen extends StatefulWidget {
  static const String title = 'Price Check';
  static const String routeName = '/learn/priceCheck';

  PriceCheckScreen({Key? key}) : super(key: key);

  @override
  _PriceCheckScreenState createState() => _PriceCheckScreenState();
}

class _PriceCheckScreenState extends State<PriceCheckScreen> {
  final MarketProvider _provider = MarketProvider();

  bool _searchBar = false;
  bool _showStarred = false;

  void _onStarPress() {
    setState(() {
      _showStarred = !_showStarred;
    });
    _provider.filterByStars(filter: _showStarred);
  }

  void _onSearchPress() {
    setState(() {
      _searchBar = !_searchBar;
    });
    if (!_searchBar) _provider.clearSearchTerm();
  }

  void _onSearchInput(String text) {
    if (text.length >= 3) {
      _provider.setSearchTerm(text);
    } else {
      _provider.clearSearchTerm();
    }
  }

  void _onItemPress(MarketItem item) {
    if (item.isStarred!) {
      _provider.addStar(item.id);
    } else {
      _provider.deleteStar(item.id);
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
    // final PriceCheckScreenArguments args =
    //     ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: _searchBar
            ? _buildSearchField()
            : const Text(PriceCheckScreen.title),
        actions: <IconButton>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearchPress,
          ),
          IconButton(
            icon: Icon(_showStarred ? Icons.star : Icons.star_border),
            onPressed: _onStarPress,
          ),
        ],
      ),
      body: PriceCheckList(
        stream: _provider.stream,
        onPress: _onItemPress,
      ),
    );
  }
}

class PriceCheckList extends StatefulWidget {
  final Stream<List<MarketItem>> stream;
  final Function(MarketItem item)? onPress;

  const PriceCheckList({Key? key, required this.stream, this.onPress})
      : super(key: key);

  @override
  _PriceCheckListState createState() => _PriceCheckListState();
}

class _PriceCheckListState extends State<PriceCheckList> {
  late StreamSubscription<List<MarketItem>> _stream;
  List<MarketItem>? _items;
  FirebaseException? _error;

  void _onData(List<MarketItem> items) {
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
    _stream = widget.stream.listen(_onData, onError: _onError);
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  Widget _separatorBuilder(BuildContext context, int index) =>
      const Divider(height: 0);

  Widget itemBuilder(BuildContext context, int index) {
    final item = _items![index];

    return PriceCheckItem(
        key: Key(item.id), item: item, onPress: widget.onPress);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return ErrorScreen();

    if (_items == null) return const Center(child: CircularProgressIndicator());

    return ListView.separated(
      itemCount: _items!.length,
      separatorBuilder: _separatorBuilder,
      itemBuilder: itemBuilder,
    );
  }
}

class PriceCheckItem extends StatefulWidget {
  final MarketItem item;
  final Function(MarketItem item)? onPress;

  static final _currencyFormat =
      NumberFormat.currency(name: 'RUB', symbol: '\u{20BD}', decimalDigits: 0);

  const PriceCheckItem({
    Key? key,
    required this.item,
    required this.onPress,
  }) : super(key: key);

  @override
  _PriceCheckItemState createState() => _PriceCheckItemState();
}

class _PriceCheckItemState extends State<PriceCheckItem> {
  bool? _isStarred;

  void _onPress() {
    setState(() {
      _isStarred = !_isStarred!;
    });
    widget.item.isStarred = _isStarred;
    widget.onPress!(widget.item);
  }

  @override
  void initState() {
    super.initState();
    _isStarred = widget.item.isStarred;
  }

  @override
  void didUpdateWidget(PriceCheckItem old) {
    super.didUpdateWidget(old);
    if (widget.item.isStarred != old.item.isStarred) {
      _isStarred = widget.item.isStarred;
    }
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          PriceCheckItem._currencyFormat.format(widget.item.avgPrice24h),
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: Theme.of(context).accentColor,
                fontSize: 21,
              ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 1, bottom: 3),
          child: Text(
            '${PriceCheckItem._currencyFormat.format(widget.item.slotPrice)} / slot',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .color!
                      .withOpacity(0.8),
                  fontSize: 16,
                ),
          ),
        ),
        Text(
          widget.item.diff24h != 0
              ? '${widget.item.diff24h}% ${(widget.item.diff24h.isNegative ? '\u{25BC}' : '\u{25B2}')}'
              : '\u{2014}',
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: widget.item.diff24h.isNegative
                    ? Colors.red
                    : (widget.item.diff24h == 0
                        ? Colors.white70
                        : Colors.green),
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).accentIconTheme.color;

    return Container(
      height: 100,
      child: FlatButton(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        color: Colors.black54,
        onPressed: _onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Icon(
                _isStarred! ? Icons.star : Icons.star_border,
                color: _isStarred! ? iconColor : iconColor!.withOpacity(0.9),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 20),
                child: Text(
                  widget.item.name,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontSize: 18,
                      ),
                ),
              ),
            ),
            Container(
              child: _buildInfo(context),
            ),
          ],
        ),
      ),
    );
  }
}
