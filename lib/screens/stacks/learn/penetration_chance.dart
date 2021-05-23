import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../firebase.dart';
import '../../../models/items/ammunition.dart';
import '../../../models/items/armor.dart';
import '../../../models/items/chestrig.dart';
import '../../../models/items/item.dart';
import '../../../modules/ballistics_engine/penetration.dart';
import 'item_table.dart';

class PenetrationChanceScreenArguments {
  final Armored? armor;
  final Ammunition? ammo;

  PenetrationChanceScreenArguments({this.armor, this.ammo});
}

class PenetrationChanceScreen extends StatelessWidget {
  static const String title = 'Penetration Chance';
  static const String routeName = '/learn/penChance';

  PenetrationChanceScreen({Key? key}) : super(key: key);

  Future<void> _onPressHelp(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Penetration Chance Calculator'),
            content: const SingleChildScrollView(
              child: Text(
                  'This tool calculates the chance that a chosen bullet will penetrate a given body armor. Once you select a bullet and armor, you can use the slider to adjust the simulated durability of the armor to see how effective different rounds are against armor at various levels of durability!'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as PenetrationChanceScreenArguments?;

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: <IconButton>[
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _onPressHelp(context),
          ),
        ],
      ),
      body: PenetrationChance(
        armor: args?.armor,
        ammo: args?.ammo,
      ),
    );
  }
}

class PenetrationChance extends StatefulWidget {
  final Armored? armor;
  final Ammunition? ammo;

  const PenetrationChance({Key? key, this.armor, this.ammo}) : super(key: key);

  @override
  _PenetrationChanceState createState() => _PenetrationChanceState();
}

class _PenetrationChanceState extends State<PenetrationChance> {
  final PenetrationCalculator _calculator = PenetrationCalculator();

  Armored? _armor;
  Ammunition? _ammo;

  double? _currentDurability;
  double? _penetrationChance;

  @override
  void initState() {
    super.initState();

    _armor = widget.armor;
    _ammo = widget.ammo;
    _currentDurability = _armor?.armorProperties?.durability;
  }

  @override
  void dispose() {
    _calculator.dispose();
    super.dispose();
  }

  void _onItemChange() {
    if (_armor != null && _ammo != null) {
      if (_calculator.ammo == null && _calculator.armor == null) {
        _calculator.createCalculation(_armor, _ammo);
      } else if (_calculator.ammo != _ammo) {
        _calculator.ammo = _ammo;
      } else if (_calculator.armor != _armor) {
        _calculator.armor = _armor;
      }

      setState(() {
        _penetrationChance = _calculator.penetrationChance;
        _currentDurability = _armor!.armorProperties!.durability;
      });
    }
  }

  void _onValueChange(double value) {
    _calculator.durability = value;

    setState(() {
      _currentDurability = _calculator.durability;
      _penetrationChance = _calculator.penetrationChance;
    });
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
            query: ItemType.ammo.getQuery('penetration', descending: true),
            sortedBy: 'damage',
          ),
        ),
      ),
    );

    if (item == null) return;

    setState(() {
      _ammo = item;
    });

    _onItemChange();
  }

  void _onTabArmor(BuildContext context) async {
    final item = await Navigator.push<Armored>(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDualTableScreen<Armor, ChestRig>(),
        settings: RouteSettings(
          name: ItemDualTableScreen.routeName,
          arguments: ItemDualTableScreenArguments(
            title: 'Armored',
            tabNames: ['Armor', 'Chest Rigs'],
            query: <Query>[
              ItemType.armor.getQuery('armor.class', descending: true),
              ItemType.chestRig.getQuery('armor.class', descending: true),
            ],
            sortedBy: ['class', 'class'],
          ),
        ),
      ),
    );

    if (item == null) return;

    setState(() {
      _armor = item;
    });

    _onItemChange();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '${_penetrationChance?.toStringAsFixed(1) ?? '\u{2500}'} %',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: _penetrationChance != null
                          ? HSVColor.fromAHSV(
                              1,
                              _penetrationChance! / 100 * 130,
                              1,
                              0.8,
                            ).toColor()
                          : null,
                      fontSize: 60,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <SelectionCard>[
                SelectionCard(
                  key: Key(_armor?.id ?? 'armor'),
                  title: _armor?.shortName ?? 'Select\nArmor',
                  item: _armor,
                  onTab: () => _onTabArmor(context),
                ),
                SelectionCard(
                  key: Key(_ammo?.id ?? 'ammo'),
                  title: _ammo?.shortName ?? 'Select\nAmmo',
                  item: _ammo,
                  onTab: () => _onTabAmmunition(context),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Durability',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 18,
                        color: Colors.grey[400],
                      ),
                ),
                Text(
                  _currentDurability?.round().toString() ?? '-',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 18,
                        color: Colors.grey[400],
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Slider(
              value: _currentDurability ?? 0,
              min: 0,
              max: _armor?.armorProperties?.durability ?? 0,
              label: (_currentDurability?.round() ?? 0).toString(),
              onChanged: _penetrationChance != null ? _onValueChange : null,
            ),
          ),
        ],
      ),
    );
  }
}

class SelectionCard extends StatefulWidget {
  final String title;
  final Item? item;
  final void Function()? onTab;

  static const StorageImage _image = StorageImage(size: ImageSize.large);
  static const AssetImage _placeholder =
      AssetImage('assets/images/placeholders/generic.png');

  const SelectionCard({
    Key? key,
    required this.title,
    required this.item,
    this.onTab,
  }) : super(key: key);

  @override
  _SelectionCardState createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard> {
  Widget? _image;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) _image = _getStorageImage(widget.item!);
  }

  @override
  void didUpdateWidget(SelectionCard old) {
    super.didUpdateWidget(old);
    if (widget.item != old.item) {
      _image = _getStorageImage(widget.item!);
    }
  }

  Widget _getStorageImage(Item item) {
    return FadeInImage(
      image: SelectionCard._image.getItemImage(item.type, item.id),
      placeholder: SelectionCard._placeholder,
      imageErrorBuilder: (context, error, stackTrace) =>
          const Image(image: SelectionCard._placeholder, fit: BoxFit.cover),
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.39,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: _image,
              ),
            ),
          ),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.button!.copyWith(
              fontSize: 18,
              shadows: const <Shadow>[
                Shadow(blurRadius: 5),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: widget.onTab,
              ),
            ),
          )
        ],
      ),
    );
  }
}
