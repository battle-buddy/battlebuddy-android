import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../common/error.dart';
import '../../../common/tiles.dart';
import '../../../models/more/team_member.dart';
import '../../../utils/url.dart';

class TheTeamScreen extends StatelessWidget {
  static const String title = 'The Team';
  static const String routeName = '/more/theTeam';

  const TheTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: const TeamList(),
    );
  }
}

class TeamList extends StatelessWidget {
  const TeamList({super.key});

  Widget _builder(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) return const ErrorScreen();

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    final docs = snapshot.data!.docs
        .map<TeamMember>((s) => TeamMember.fromSnapshot(s))
        .toList(growable: false);

    return ListView.separated(
        itemCount: snapshot.data!.size,
        separatorBuilder: (context, index) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final member = docs[index];
          return MemberTile(member: member);
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('team')
          .orderBy('index')
          .snapshots(),
      builder: _builder,
    );
  }
}

class MemberTile extends StatelessWidget {
  final TeamMember member;

  const MemberTile({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Image.asset(
            'assets/images/branding_and_logos/team_${member.id}.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
          ),
        ),
      ),
      title: Text(member.name),
      subtitle: member.live
          ? Text(
              'Live',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.red,
                  ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTab: () => openURL(member.url),
    );
  }
}
