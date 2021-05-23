import 'package:flutter/material.dart';

class TileSectionList extends StatelessWidget {
  final String title;
  final Iterable<CustomTile> tiles;
  final Color? color;

  const TileSectionList({
    Key? key,
    required this.title,
    required this.tiles,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.grey[400]),
            ),
          ),
          CustomTileList(tiles: tiles),
        ],
      ),
    );
  }
}

class CustomTileList extends StatelessWidget {
  final Iterable<CustomTile> tiles;
  final Color? color;

  const CustomTileList({
    Key? key,
    required this.tiles,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ListTile.divideTiles(
        context: context,
        tiles: tiles,
        color: color,
      ).toList(growable: false),
    );
  }
}

class CustomTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Color color;
  final void Function()? onTab;

  const CustomTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.color = Colors.black45,
    this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: ListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        onTap: onTab,
      ),
    );
  }
}

// class CustomListTile extends StatelessWidget {
//   final Widget leading;
//   final Widget title;
//   final Widget subtitle;
//   final Widget trailing;
//   final double height;
//   final EdgeInsetsGeometry padding;
//   final void Function() onPress;

//   const CustomListTile({
//     Key key,
//     this.leading,
//     @required this.title,
//     this.subtitle,
//     this.trailing,
//     this.height,
//     this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//     this.onPress,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.black54,
//       child: InkWell(
//         onTap: onPress,
//         child: Container(
//           height: height,
//           padding: padding,
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Container(
//                       padding: const EdgeInsets.only(bottom: 5),
//                       child: Text(
//                         doc.title,
//                         style: Theme.of(context).textTheme.subtitle1.copyWith(
//                               fontWeight: FontWeight.w500,
//                             ),
//                       ),
//                     ),
//                     Container(
//                       child: Text(
//                         doc.subtitle,
//                         style: Theme.of(context).textTheme.bodyText2.copyWith(
//                               fontSize: 14,
//                             ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               ...doc.url != null
//                   ? [
//                       Container(
//                         padding: const EdgeInsets.only(left: 5),
//                         child: Icon(Icons.chevron_right),
//                       )
//                     ]
//                   : [],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
