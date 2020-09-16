import 'package:flutter/cupertino.dart';

class TeamMember {
  final String name;
  final String url;
  final bool live;

  const TeamMember({
    @required this.name,
    this.url,
    this.live = false,
  });
}
