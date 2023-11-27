import 'package:flutter/material.dart';

import '../../../common/error.dart';
import '../../../common/tiles.dart';
import '../../../firebase.dart';
import '../../../models/items/ammunition.dart' show Ammunition;
import '../../../models/items/armor.dart' show Armor, Armored;
import '../../../models/items/chestrig.dart' show ChestRig;
import '../../../models/items/firearm.dart' show Firearm;
import '../../../models/items/item.dart';
import '../../../models/items/medical.dart' show Medical;
import '../../../models/items/melee.dart' show Melee;
import '../../../models/items/throwable.dart' show Throwable;
import '../learn/damage_calc.dart';
import '../learn/penetration_chance.dart';
import 'item_select.dart';

class ItemDetailScreenArguments<T extends ExplorableItem> {
  final T item;

  const ItemDetailScreenArguments({required this.item});
}

class ItemDetailScreen<T extends ExplorableItem> extends StatelessWidget {
  static const String routeName = '/items/detail';

  const ItemDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as ItemDetailScreenArguments<ExplorableItem>;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.item.name),
      ),
      body: ItemDetail<T>(item: args.item as T),
    );
  }
}

class ItemDetail<T extends ExplorableItem> extends StatefulWidget {
  final T item;

  static const StorageImage _image = StorageImage(size: ImageSize.full);
  static const AssetImage _placeholder =
      AssetImage('assets/images/placeholders/generic.png');

  const ItemDetail({super.key, required this.item});

  @override
  _ItemDetailState<T> createState() => _ItemDetailState<T>();
}

class _ItemDetailState<T extends ExplorableItem> extends State<ItemDetail<T>> {
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

  Widget _getStorageImage(Item item) {
    return FadeInImage(
      image: ItemDetail._image.getItemImage(item.type, item.id),
      placeholder: ItemDetail._placeholder,
      imageErrorBuilder: (context, error, stackTrace) =>
          const Image(image: ItemDetail._placeholder, fit: BoxFit.cover),
      fit: BoxFit.cover,
    );
  }

  Future<void> _onCompare() {
    late Function(BuildContext) builder;
    var arguments = ItemSelectScreenArguments(
      query: widget.item.type.getQuery(null),
      selectedID: widget.item.id,
      sortSections: widget.item.type == ItemType.chestRig,
    );

    switch (widget.item.type) {
      case ItemType.ammo:
        builder = (context) => const ItemSectionSelectScreen<Ammunition>();
        break;
      case ItemType.bodyArmor:
        builder = (context) => const ItemSectionSelectScreen<Armor>();
        break;
      case ItemType.chestRig:
        builder = (context) => const ItemSectionSelectScreen<ChestRig>();
        break;
      case ItemType.firearm:
        builder = (context) => const ItemSectionSelectScreen<Firearm>();
        break;
      case ItemType.helmet:
        builder = (context) => const ItemSectionSelectScreen<Armor>();
        break;
      case ItemType.medical:
        builder = (context) => const ItemSectionSelectScreen<Medical>();
        break;
      case ItemType.melee:
        builder = (context) => const ItemSelectScreen<Melee>();
        arguments = ItemSelectScreenArguments(
          query: widget.item.type.getQuery(null),
          selectedID: widget.item.id,
        );
        break;
      case ItemType.throwable:
        builder = (context) => const ItemSectionSelectScreen<Throwable>();
        break;
      case ItemType.armor:
      case ItemType.attachment:
        builder = (context) => const ItemSectionSelectScreen<Armor>();
        break;
      default:
        throw const ErrorScreen();
    }

    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: builder as Widget Function(BuildContext),
        settings: RouteSettings(
          name: ItemSectionSelectScreen.routeName,
          arguments: arguments,
        ),
      ),
    );
  }

  Future<void> _onPenChance() {
    return Navigator.pushNamed<void>(
      context,
      PenetrationChanceScreen.routeName,
      arguments: PenetrationChanceScreenArguments(
        ammo: widget.item is Ammunition ? widget.item as Ammunition : null,
        armor: widget.item is Armored ? widget.item as Armored : null,
      ),
    );
  }

  Future<void> _onDamageCalc() {
    return Navigator.pushNamed<void>(
      context,
      DamageCalculatorScreen.routeName,
      arguments: DamageCalculatorScreenArguments(
        ammo: widget.item is Ammunition ? widget.item as Ammunition : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 9,
          child: _image,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Text(
            widget.item.description,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  color: Colors.white70,
                ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: PropertyList(
            sections: widget.item.propertySections,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Text(
                'Explore',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            CustomTileList(
              tiles: [
                CustomTile(
                  title: const Text('Compare'),
                  trailing: const Icon(Icons.chevron_right),
                  onTab: _onCompare,
                ),
                ...(widget.item is Ammunition) || (widget.item is Armored)
                    ? <CustomTile>[
                        CustomTile(
                          title: const Text('Penetration Chance'),
                          trailing: const Icon(Icons.chevron_right),
                          onTab: _onPenChance,
                        ),
                      ]
                    : [],
                ...widget.item is Ammunition
                    ? <CustomTile>[
                        CustomTile(
                          title: const Text('Damage Calculator'),
                          trailing: const Icon(Icons.chevron_right),
                          onTab: _onDamageCalc,
                        ),
                      ]
                    : [],
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class PropertyList extends StatelessWidget {
  final List<PropertySection>? sections;
  final Color? dividerColor;

  const PropertyList({
    super.key,
    this.sections,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections!
          .expand(
            (e) => [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text(
                  e.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: CustomTileList(
                  color: dividerColor,
                  tiles: e.properties.map(
                    (e) => CustomTile(
                      title: Text(e.name),
                      trailing: Text(e.value),
                    ),
                  ),
                ),
              ),
            ],
          )
          .toList(growable: false),
    );
  }
}
