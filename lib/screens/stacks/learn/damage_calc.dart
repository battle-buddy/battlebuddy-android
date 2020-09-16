import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../common/error.dart';
import '../../../models/items/ammunition.dart';
import '../../../models/items/item.dart';
import '../../../models/learn/character.dart';
import '../../../modules/ballistics_engine/health.dart';
import 'item_table.dart';

class DamageCalculatorScreenArguments {
  final Ammunition ammo;

  DamageCalculatorScreenArguments({this.ammo});
}

class DamageCalculatorScreen extends StatelessWidget {
  static const String title = 'Damage Calculator';
  static const String routeName = '/learn/damageCalc';

  DamageCalculatorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DamageCalculatorScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: DamageCalculator(
        ammo: args?.ammo,
      ),
    );
  }
}

class DamageCalculator extends StatefulWidget {
  final Ammunition ammo;

  const DamageCalculator({Key key, this.ammo}) : super(key: key);

  @override
  _DamageCalculatorState createState() => _DamageCalculatorState();
}

class _DamageCalculatorState extends State<DamageCalculator> {
  final HealthCalculator _calculator = HealthCalculator();

  Ammunition _ammo;

  Health _health;
  Health _healthInitial;

  Exception _error;

  void _onData(DocumentSnapshot snapshot) {
    final character = Character.fromSnapshot(snapshot);

    setState(() {
      _health = character.health;
      _healthInitial = character.health;
    });

    if (_ammo != null) {
      _calculator.createCalculation(_health, _ammo);
    }
  }

  void _onError(dynamic error) {
    setState(() {
      _error = error;
    });
  }

  @override
  void initState() {
    super.initState();

    _ammo = widget.ammo;

    FirebaseFirestore.instance
        .collection('character')
        .doc('pmc')
        .get()
        .then(_onData)
        .catchError(_onError);
  }

  @override
  void dispose() {
    _calculator.dispose();
    super.dispose();
  }

  void _onItemChange() {
    if (_ammo != null) {
      if (_calculator.ammo == null) {
        _calculator.createCalculation(_health, _ammo);
      } else if (_calculator.ammo != _ammo) {
        _calculator.ammo = _ammo;
      }
    }
  }

  void _onTabAmmunition(BuildContext context) async {
    final item = await Navigator.push<Ammunition>(
      context,
      MaterialPageRoute(
        builder: (context) => ItemTableScreen<Ammunition>(),
        settings: RouteSettings(
          name: ItemDualTableScreen.routeName,
          arguments: ItemTableScreenArguments(
            title: 'Ammunition',
            query: ItemType.ammo.getQuery('damage', descending: true),
            sortedBy: 'damage',
          ),
        ),
      ),
    );

    setState(() {
      _ammo = item;
    });

    _onItemChange();
  }

  void _onTabReset() {
    _calculator.reset();

    setState(() {
      _health = _calculator.health;
    });
  }

  void _onTabZone(Zone zone) {
    if (_health == null || _ammo == null) return;

    _calculator.impactOnZone(zone);

    setState(() {
      _health = _calculator.health;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return ErrorScreen();

    if (_health == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final totalStyle = Theme.of(context).textTheme.bodyText2.copyWith(
      shadows: const <Shadow>[
        Shadow(blurRadius: 5),
      ],
      fontSize: 30,
      fontWeight: FontWeight.w500,
      color: HSVColor.fromAHSV(
        1,
        _health.total / _healthInitial.total * 130,
        1,
        0.7,
      ).toColor(),
    );

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/backgrounds/skeleton.png'),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ZoneBar(
                key: const Key('head'),
                title: 'Head',
                value: _health.head,
                maxValue: _healthInitial?.head,
                onTab: () => _onTabZone(Zone.head),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ZoneBar(
                key: const Key('throax'),
                title: 'Thorax',
                value: _health.thorax,
                maxValue: _healthInitial?.thorax,
                onTab: () => _onTabZone(Zone.thorax),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ZoneBar(
                key: const Key('armRight'),
                title: 'Right Arm',
                value: _health.armRight,
                maxValue: _healthInitial?.armRight,
                onTab: () => _onTabZone(Zone.armRight),
              ),
              ZoneBar(
                key: const Key('stomach'),
                title: 'Stomach',
                value: _health.stomach,
                maxValue: _healthInitial?.stomach,
                onTab: () => _onTabZone(Zone.stomach),
              ),
              ZoneBar(
                key: const Key('armLeft'),
                title: 'Left Arm',
                value: _health.armLeft,
                maxValue: _healthInitial?.armLeft,
                onTab: () => _onTabZone(Zone.armLeft),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ZoneBar(
                key: const Key('legRight'),
                title: 'Right Leg',
                value: _health.legRight,
                maxValue: _healthInitial?.legRight,
                onTab: () => _onTabZone(Zone.legRight),
              ),
              ZoneBar(
                key: const Key('legLeft'),
                title: 'Left Leg',
                value: _health.legLeft,
                maxValue: _healthInitial?.legLeft,
                onTab: () => _onTabZone(Zone.legLeft),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                key: const Key('currentPoints'),
                width: 60,
                alignment: Alignment.center,
                child: _health != null
                    ? AnimatedCount(
                        count: _health.total.floor(),
                        duration: 250,
                        style: totalStyle,
                      )
                    : Text(
                        '${_health.total?.floor() ?? '-'}',
                        style: totalStyle,
                      ),
              ),
              Container(
                key: const Key('separator'),
                child: Text(
                  '/',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                    shadows: const <Shadow>[
                      Shadow(blurRadius: 5),
                    ],
                  ),
                ),
              ),
              Container(
                key: const Key('initialPoints'),
                width: 54,
                alignment: Alignment.center,
                child: Text(
                  '${_healthInitial?.total?.floor() ?? '-'}',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                    shadows: const <Shadow>[
                      Shadow(blurRadius: 5),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 140,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: FlatButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () => _onTabAmmunition(context),
                    child: Text(_ammo?.shortName ?? 'Select Ammo'),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: IconButton(
                    color: Theme.of(context).accentColor,
                    iconSize: 36,
                    icon: const Icon(Icons.refresh),
                    onPressed:
                        _health != null && _health.total != _healthInitial.total
                            ? _onTabReset
                            : null,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ZoneBar extends StatefulWidget {
  final String title;
  final double value;
  final double maxValue;
  final Function onTab;
  final int animationDuration;

  const ZoneBar({
    Key key,
    @required this.title,
    @required this.value,
    @required this.maxValue,
    this.onTab,
    this.animationDuration = 250,
  }) : super(key: key);

  @override
  _ZoneBarState createState() => _ZoneBarState();
}

class _ZoneBarState extends State<ZoneBar> {
  double _value;
  double _maxValue;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _maxValue = widget.maxValue;
  }

  @override
  void didUpdateWidget(ZoneBar old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      _value = widget.value;
    }
    if (widget.maxValue != old.maxValue) {
      _maxValue = widget.maxValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2.copyWith(
          fontSize: 13,
          color: Colors.grey[100],
        );

    return GestureDetector(
      key: widget.key,
      onTap: widget.onTab,
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: _value > 0
                ? Colors.transparent
                : Colors.red[800].withOpacity(0.8),
          ),
          color: Colors.black54,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 2, left: 2, right: 2),
              child: Text(
                widget.title ?? 'Body Zone',
                style: textStyle,
              ),
            ),
            LinearPercentIndicator(
              key: widget.key,
              percent: (_value ?? 1) / (_maxValue ?? 1),
              lineHeight: 22,
              linearStrokeCap: LinearStrokeCap.butt,
              center: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedCount(
                    key: widget.key,
                    count: _value?.floor(),
                    duration: widget.animationDuration,
                    style: textStyle,
                  ),
                  Text(
                    ' / ${_maxValue.floor()}',
                    style: textStyle,
                  ),
                ],
              ),
              animation: true,
              animateFromLastPercent: true,
              animationDuration: widget.animationDuration,
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
              progressColor: HSVColor.fromAHSV(
                1,
                (_value ?? 1) / (_maxValue ?? 1) * 130,
                1,
                0.5,
              ).toColor(),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCount extends ImplicitlyAnimatedWidget {
  final int count;
  final TextStyle style;

  AnimatedCount({
    Key key,
    @required this.count,
    @required int duration,
    Curve curve = Curves.linear,
    this.style,
  }) : super(
          key: key,
          duration: Duration(milliseconds: duration),
          curve: curve,
        );

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedCountState();
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween _count;

  @override
  Widget build(BuildContext context) {
    return Text(
      _count.evaluate(animation).toString(),
      style: widget.style,
    );
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _count = visitor(
        _count, widget.count, (dynamic value) => IntTween(begin: value));
  }
}
