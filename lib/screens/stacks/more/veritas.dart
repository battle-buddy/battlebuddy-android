import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common/tiles.dart';
import '../../../utils/url.dart';

class VeritasScreen extends StatelessWidget {
  static const String title = 'Veritas';
  static const String routeName = '/more/veritas';

  const VeritasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: const VeritasInfo(),
    );
  }
}

class VeritasInfo extends StatelessWidget {
  const VeritasInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <TileSectionList>[
        TileSectionList(
          title: 'Social',
          tiles: <CustomTile>[
            CustomTile(
              leading: FaIcon(
                FontAwesomeIcons.twitch,
                color: Theme.of(context).colorScheme.secondary,
                size: 32,
              ),
              title: const Text('Watch Live on Twitch'),
              trailing: const Icon(Icons.chevron_right),
              onTab: () => openURL('https://www.twitch.tv/veritas'),
            ),
            CustomTile(
              leading: FaIcon(
                FontAwesomeIcons.youtube,
                color: Theme.of(context).colorScheme.secondary,
                size: 32,
              ),
              title: const Text('Watch on YouTube'),
              trailing: const Icon(Icons.chevron_right),
              onTab: () => openURL(
                  'https://www.youtube.com/channel/UCkS33XH4KH0IqD2S2-f7ovA'),
            ),
            CustomTile(
              leading: FaIcon(
                FontAwesomeIcons.twitter,
                color: Theme.of(context).colorScheme.secondary,
                size: 32,
              ),
              title: const Text('Stay Up to Date'),
              trailing: const Icon(Icons.chevron_right),
              onTab: () => openURL('https://twitter.com/veriitasgames'),
            ),
            CustomTile(
              leading: FaIcon(
                FontAwesomeIcons.discord,
                color: Theme.of(context).colorScheme.secondary,
                size: 32,
              ),
              title: const Text('Join our Community Discord'),
              trailing: const Icon(Icons.chevron_right),
              onTab: () => openURL('https://discord.gg/g99WEgG'),
            ),
            CustomTile(
              leading: FaIcon(
                FontAwesomeIcons.instagram,
                color: Theme.of(context).colorScheme.secondary,
                size: 32,
              ),
              title: const Text('Media on Instagram'),
              trailing: const Icon(Icons.chevron_right),
              onTab: () => openURL('https://www.instagram.com/veritaswtf'),
            ),
            CustomTile(
              leading: ImageIcon(
                const AssetImage('assets/images/icons/veritas.png'),
                color: Theme.of(context).colorScheme.secondary,
                size: 32,
              ),
              title: const Text('More about Veritas'),
              trailing: const Icon(Icons.chevron_right),
              onTab: () => openURL('https://www.veritas.wtf/'),
            ),
          ],
        ),
        TileSectionList(
          title: 'My Music',
          tiles: [
            CustomTile(
              leading: FaIcon(
                FontAwesomeIcons.spotify,
                color: Theme.of(context).colorScheme.secondary,
                size: 30,
              ),
              title: const Text('Listen on Spotify'),
              trailing: const Icon(Icons.chevron_right),
              onTab: () => openURL(
                  'https://open.spotify.com/artist/2S6iwClVoSNnpOcCzyMeUj'),
            ),
            CustomTile(
              leading: FaIcon(
                FontAwesomeIcons.soundcloud,
                color: Theme.of(context).colorScheme.secondary,
                size: 30,
              ),
              title: const Text('Listen on Soundcloud'),
              trailing: const Icon(Icons.chevron_right),
              onTab: () => openURL('https://soundcloud.com/veritaswtf'),
            ),
          ],
        ),
      ],
    );
  }
}
