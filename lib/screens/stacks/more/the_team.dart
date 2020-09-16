import 'package:flutter/material.dart';

import '../../../common/tiles.dart';
import '../../../models/more/team_member.dart';
import '../../../utils/url.dart';

// TODO: implement backend data
class TheTeamScreen extends StatelessWidget {
  static const String title = 'The Team';
  static const String routeName = '/more/theTeam';

  TheTeamScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: TeamList(),
    );
  }
}

class TeamList extends StatelessWidget {
  static const List<TeamMember> members = [
    TeamMember(name: 'GhostFreak66', url: 'https://twitch.tv/GhostFreak66'),
    TeamMember(name: 'Slushpuppy', url: 'https://twitch.tv/Slushpuppy'),
    TeamMember(name: 'Pestily', url: 'https://twitch.tv/Pestily'),
    TeamMember(name: 'Anton', url: 'https://twitch.tv/Anton'),
    TeamMember(name: 'Veritas', url: 'https://twitch.tv/Veritas'),
    TeamMember(name: 'Sigma', url: 'https://twitch.tv/sigma'),
  ];

  TeamList({Key key}) : super(key: key);

  // Widget _builder(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //   if (snapshot.hasError) {
  //     return const Center(
  //       child: Icon(
  //         Icons.error_outline,
  //         color: Theme.of(context).accentColor,
  //       ),
  //     );
  //   }

  //   if (snapshot.connectionState == ConnectionState.waiting) {
  //     return const Center(child: CircularProgressIndicator());
  //   }

  //   final docs = snapshot.data.docs
  //       .map<Attribution>((s) => Attribution.fromSnapshot(s))
  //       .toList(growable: false);
  //   docs.sort((a, b) => a.index.compareTo(b.index));

  //   return ListView.separated(
  //       itemCount: members.length,
  //       separatorBuilder: (context, index) => SizedBox(height: 10),
  //       itemBuilder: (context, index) {
  //         final member = members[index];
  //         return MemberTile(key: Key(member.name), member: member);
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: members.length,
        separatorBuilder: (context, index) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final member = members[index];
          return MemberTile(key: Key(member.name), member: member);
        });
  }
}

class MemberTile extends StatelessWidget {
  final TeamMember member;

  const MemberTile({
    Key key,
    @required this.member,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Image.asset(
            'assets/images/branding_and_logos/team_${member.name.toLowerCase()}.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
          ),
        ),
      ),
      title: Text(member.name),
      trailing: member.url != null ? const Icon(Icons.chevron_right) : null,
      onTab: member.url != null ? () => openURL(member.url) : null,
    );
  }
}
