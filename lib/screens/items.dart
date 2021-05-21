import 'package:flutter/material.dart';

import '../common/cards.dart';
import '../models/items/ammunition.dart';
import '../models/items/armor.dart';
import '../models/items/chestrig.dart';
import '../models/items/firearm.dart';
import '../models/items/item.dart';
import '../models/items/medical.dart';
import '../models/items/melee.dart';
import '../models/items/throwable.dart';
import 'stacks/items/item_list.dart';

class ItemsTab extends StatelessWidget {
  static const String title = 'Items';
  static const ImageIcon icon = ImageIcon(
    AssetImage('assets/images/icons/items.png'),
    size: 30,
  );

  static final Map<String, Widget Function(BuildContext)> routes = {};

  ItemsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationCardList(
      cards: <NavigationCard>[
        NavigationCard(
          title: 'Firearms',
          image: 'assets/images/card_heroes/firearms.png',
          pageRoute: () => MaterialPageRoute<void>(
            builder: (context) => const ItemSectionListScreen<Firearm>(),
            settings: RouteSettings(
              name: '${ItemSectionListScreen.routeName}/firearms',
              arguments: ItemSectionListScreenArguments(
                title: 'Firearms',
                query: ItemType.firearm.getQuery('class'),
              ),
            ),
          ),
        ),
        NavigationCard(
          title: 'Ammunition',
          image: 'assets/images/card_heroes/ammo.jpg',
          pageRoute: () => MaterialPageRoute<void>(
            builder: (context) => const ItemSectionListScreen<Ammunition>(),
            settings: RouteSettings(
              name: '${ItemSectionListScreen.routeName}/ammunition',
              arguments: ItemSectionListScreenArguments(
                title: 'Ammunition',
                query: ItemType.ammo.getQuery('caliber'),
              ),
            ),
          ),
        ),
        NavigationCard(
          title: 'Body Armor',
          image: 'assets/images/card_heroes/armor.jpg',
          pageRoute: () => MaterialPageRoute<void>(
            builder: (context) => const ItemSectionListScreen<Armor>(),
            settings: RouteSettings(
              name: '${ItemSectionListScreen.routeName}/bodyArmor',
              arguments: ItemSectionListScreenArguments(
                title: 'Body Armor',
                query: ItemType.bodyArmor.getQuery('armor.class'),
              ),
            ),
          ),
        ),
        NavigationCard(
          title: 'Chest Rigs',
          image: 'assets/images/card_heroes/chest_rigs.png',
          pageRoute: () => MaterialPageRoute<void>(
            builder: (context) => const ItemSectionListScreen<ChestRig>(),
            settings: RouteSettings(
              name: '${ItemSectionListScreen.routeName}/chestRigs',
              arguments: ItemSectionListScreenArguments(
                title: 'Chest Rigs',
                query: ItemType.chestRig.getQuery(null),
                sortSections: true,
              ),
            ),
          ),
        ),
        NavigationCard(
          title: 'Helmets',
          image: 'assets/images/card_heroes/helmets.png',
          pageRoute: () => MaterialPageRoute<void>(
            builder: (context) => const ItemSectionListScreen<Armor>(),
            settings: RouteSettings(
              name: '${ItemSectionListScreen.routeName}/helmets',
              arguments: ItemSectionListScreenArguments(
                title: 'Helmets',
                query: ItemType.helmet.getQuery('armor.class'),
              ),
            ),
          ),
        ),
        NavigationCard(
          title: 'Attachments',
          image: 'assets/images/card_heroes/attachments.png',
          pageRoute: () => MaterialPageRoute<void>(
            builder: (context) => const ItemSectionListScreen<Armor>(),
            settings: RouteSettings(
              name: '${ItemSectionListScreen.routeName}/attachments',
              arguments: ItemSectionListScreenArguments(
                title: 'Attachments',
                query: ItemType.attachment.getQuery('armor.class'),
              ),
            ),
          ),
        ),
        NavigationCard(
          title: 'Medical',
          image: 'assets/images/card_heroes/medical.png',
          pageRoute: () => MaterialPageRoute<void>(
            builder: (context) => const ItemSectionListScreen<Medical>(),
            settings: RouteSettings(
              name: '${ItemSectionListScreen.routeName}/medical',
              arguments: ItemSectionListScreenArguments(
                title: 'Medical',
                query: ItemType.medical.getQuery('type'),
              ),
            ),
          ),
        ),
        NavigationCard(
          title: 'Melee Weapons',
          image: 'assets/images/card_heroes/melee.jpg',
          pageRoute: () => MaterialPageRoute<void>(
            builder: (context) => const ItemListScreen<Melee>(),
            settings: RouteSettings(
              name: '${ItemListScreen.routeName}/meleeWeapons',
              arguments: ItemListScreenArguments(
                title: 'Melee Weapons',
                query: ItemType.melee.getQuery(null),
              ),
            ),
          ),
        ),
        NavigationCard(
          title: 'Throwables',
          image: 'assets/images/card_heroes/throwables.jpg',
          routeName: '${ItemListScreen.routeName}/throwables',
          pageRoute: () => MaterialPageRoute<void>(
            builder: (context) => const ItemSectionListScreen<Throwable>(),
            settings: RouteSettings(
              name: '${ItemSectionListScreen.routeName}/throwables',
              arguments: ItemSectionListScreenArguments(
                title: 'Throwables',
                query: ItemType.throwable.getQuery('type'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
