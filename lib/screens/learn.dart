import 'package:flutter/material.dart';

import '../common/cards.dart';
import '../models/items/ammunition.dart';
import '../models/items/armor.dart';
import '../models/items/chestrig.dart';
import 'stacks/learn/ballistics.dart';
import 'stacks/learn/character_select.dart';
import 'stacks/learn/damage_calc.dart';
import 'stacks/learn/item_table.dart';
import 'stacks/learn/penetration_chance.dart';
import 'stacks/learn/price_check.dart';

class LearnTab extends StatelessWidget {
  static const String title = 'Learn';
  static const ImageIcon icon = ImageIcon(
    AssetImage('assets/images/icons/learn.png'),
    size: 30,
  );

  static final Map<String, Widget Function(BuildContext)> routes = {
    PriceCheckScreen.routeName: (context) => PriceCheckScreen(),
    PenetrationChanceScreen.routeName: (context) => PenetrationChanceScreen(),
    DamageCalculatorScreen.routeName: (context) => DamageCalculatorScreen(),
    BallisticsScreen.routeName: (context) => BallisticsScreen(),
    '${ItemTableScreen.routeName}/ammunition': (context) =>
        ItemTableScreen<Ammunition>(),
    '${ItemDualTableScreen.routeName}/armored': (context) =>
        ItemDualTableScreen<Armor, ChestRig>(),
    CharacterSelectionScreen.routeName: (context) => CharacterSelectionScreen(),
  };

  LearnTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NavigationCardList(
      cards: <NavigationCard>[
        NavigationCard(
          title: 'Price Check',
          image: 'assets/images/card_heroes/price_check.png',
          routeName: PriceCheckScreen.routeName,
        ),
        NavigationCard(
          title: 'Penetration\nChance',
          image: 'assets/images/card_heroes/pen_chance.png',
          routeName: PenetrationChanceScreen.routeName,
        ),
        NavigationCard(
          title: 'Damage\nCalculator',
          image: 'assets/images/card_heroes/damage_calc.png',
          routeName: DamageCalculatorScreen.routeName,
        ),
        NavigationCard(
          title: 'Ballistics',
          image: 'assets/images/card_heroes/ballistics.png',
          routeName: BallisticsScreen.routeName,
        ),
      ],
    );
  }
}
