import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';

import '../common/tiles.dart';
import '../global.dart' as globals;
import '../screens/stacks/more/veritas.dart';
import '../utils/url.dart';
import 'stacks/more/attributions.dart';
import 'stacks/more/the_team.dart';

class MoreTab extends StatelessWidget {
  static const String title = 'More';
  static const ImageIcon icon = ImageIcon(
    AssetImage('assets/images/icons/more.png'),
    size: 30,
  );

  static final Map<String, Widget Function(BuildContext)> routes = {
    VeritasScreen.routeName: (context) => const VeritasScreen(),
    AttributionScreen.routeName: (context) => const AttributionScreen(),
    TheTeamScreen.routeName: (context) => const TheTeamScreen(),
  };

  const MoreTab({super.key});

  Future<void> _onAppReview() async {
    if (!Platform.isAndroid) return;

    final inAppReview = InAppReview.instance;

    await inAppReview.openStoreListing();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <TileSectionList>[
        TileSectionList(
          title: 'About Battle Buddy',
          tiles: <CustomTile>[
            CustomTile(
              title: const Text('App Version'),
              leading: FaIcon(
                FontAwesomeIcons.compassDrafting,
                color: Theme.of(context).colorScheme.secondary,
                size: 32,
              ),
              subtitle: Text(
                  '${globals.appInfo.version} (${globals.appInfo.buildNumber})'),
            ),
            CustomTile(
              title: const Text('Developed by Veritas'),
              leading: ImageIcon(
                const AssetImage('assets/images/icons/veritas.png'),
                color: Theme.of(context).colorScheme.secondary,
                size: 32,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTab: () =>
                  Navigator.pushNamed(context, VeritasScreen.routeName),
            ),
            CustomTile(
              title: const Text('Attributions'),
              leading: FaIcon(
                FontAwesomeIcons.solidStar,
                color: Theme.of(context).colorScheme.secondary,
                size: 32,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTab: () =>
                  Navigator.pushNamed(context, AttributionScreen.routeName),
            ),
          ],
        ),
        TileSectionList(
          title: 'Community Stats',
          tiles: <CustomTile>[
            CustomTile(
              title: Text(NumberFormat.decimalPattern()
                  .format(globals.metadata.totalUserCount)),
              subtitle: const Text('Battle Buddies have joined the fight!'),
              leading: FaIcon(
                FontAwesomeIcons.gamepad,
                color: Theme.of(context).colorScheme.secondary,
                size: 32,
              ),
            ),
            CustomTile(
              title: Text(DateTime.now()
                  .difference(globals.metadata.lastWipe.toDate())
                  .inDays
                  .toString()),
              subtitle: const Text('days since last wipe...'),
              leading: FaIcon(
                FontAwesomeIcons.toiletPaper,
                color: Theme.of(context).colorScheme.secondary,
                size: 32,
              ),
            ),
            CustomTile(
              title: const Text('Battlestate Games Limited'),
              leading: FaIcon(
                FontAwesomeIcons.twitter,
                color: Theme.of(context).colorScheme.secondary,
                size: 30,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTab: () =>
                  openURL(Uri.parse('https://twitter.com/bstategames')),
            ),
          ],
        ),
        TileSectionList(
          title: 'Want to Support the Development?',
          tiles: <CustomTile>[
            CustomTile(
              title: const Text('Feedback or Feature Ideas?'),
              subtitle: const Text('Join our discord!'),
              leading: FaIcon(
                FontAwesomeIcons.discord,
                color: Theme.of(context).colorScheme.secondary,
                size: 34,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTab: () => openURL(Uri.parse('https://discord.gg/g99WEgG')),
            ),
            CustomTile(
              title: const Text('Rate the app'),
              leading: Icon(
                Icons.rate_review,
                color: Theme.of(context).colorScheme.secondary,
                size: 34,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTab: _onAppReview,
            ),
            CustomTile(
              title: const Text('View on GitHub'),
              leading: FaIcon(
                FontAwesomeIcons.github,
                color: Theme.of(context).colorScheme.secondary,
                size: 34,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTab: () => openURL(Uri.parse(
                  'https://github.com/battle-buddy/battlebuddy-android')),
            ),
            CustomTile(
              title: const Text('Check Out The Team'),
              leading: ImageIcon(
                const AssetImage('assets/images/icons/the_team.png'),
                color: Theme.of(context).colorScheme.secondary,
                size: 34,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTab: () =>
                  Navigator.pushNamed(context, TheTeamScreen.routeName),
            ),
          ],
        ),
      ],
    );
  }
}
