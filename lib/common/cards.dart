import 'package:flutter/material.dart';

class NavigationCard extends StatelessWidget {
  final String title;
  final String image;
  final String routeName;
  final Object arguments;
  final MaterialPageRoute Function() pageRoute;

  static const double _shape = 8;

  const NavigationCard({
    Key key,
    @required this.title,
    @required this.image,
    this.routeName,
    this.arguments,
    this.pageRoute,
  }) : super(key: key);

  void _onTab(BuildContext context) {
    if (pageRoute == null) {
      Navigator.pushNamed(context, routeName, arguments: arguments);
    } else {
      Navigator.push<void>(context, pageRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      color: Colors.transparent,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_shape),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_shape),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline4.copyWith(
                color: Theme.of(context).textTheme.bodyText2.color,
                fontWeight: FontWeight.bold,
                shadows: const <Shadow>[
                  Shadow(blurRadius: 5),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => _onTab(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NavigationCardList extends StatelessWidget {
  final List<NavigationCard> cards;

  const NavigationCardList({Key key, @required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: cards.length,
      padding: const EdgeInsets.all(10),
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) => cards[index],
    );
  }
}
