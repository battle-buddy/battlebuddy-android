import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../common/error.dart';
import '../../../utils/url.dart';

// class BallisticsScreenArguments {
//   BallisticsScreenArguments();
// }

class BallisticsScreen extends StatelessWidget {
  static const String title = 'Ballistics';
  static const String routeName = '/learn/ballistics';

  const BallisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final BallisticsScreenArguments args =
    //     ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: const BallisticsArticle(),
    );
  }
}

class BallisticsArticle extends StatelessWidget {
  const BallisticsArticle({super.key});

  Future<Map<String, String>> _loadText(BuildContext context) async {
    final data = await DefaultAssetBundle.of(context)
        .loadString('assets/texts/ballistics.json');
    final Map<String, dynamic> jsonMap = json.decode(data);

    return jsonMap.map((k, dynamic v) => MapEntry(k, v as String));
  }

  // TODO: implement embedded video player
  Widget _buildVideoPlaceholder(BuildContext context, String videoID) {
    return Material(
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: InkWell(
          onTap: () =>
              openURL(Uri.parse('https://youtube.com/watch?v=$videoID')),
          child: const Center(
            child: Icon(
              Icons.ondemand_video,
              color: Colors.red,
              size: 34,
            ),
          ),
        ),
      ),
    );
  }

  Widget _builder(
      BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
    if (snapshot.hasError) return const ErrorScreen();

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = snapshot.data!;

    return ListView(
      children: <ArticleSection>[
        ArticleSection(
          headerImage: Image.asset('assets/images/card_heroes/ballistics.png'),
          title: Text(
            data['headline']!,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'Veritas - 13/07/2019',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(data['body_1']!),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(data['body_2']!),
              ),
            ],
          ),
        ),
        ArticleSection(
          headerImage: Image.asset('assets/images/card_heroes/armor.jpg'),
          title: Text(data['body_2_1_title']!),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(data['body_2_1']!),
              ),
            ],
          ),
        ),
        ArticleSection(
          title: Text(data['body_2_2_title']!),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(data['body_2_2_1']!),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: _buildVideoPlaceholder(context, '3KbFMHp4NOE'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(data['body_2_2_2']!),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(data['body_2_2_3']!),
              ),
            ],
          ),
        ),
        ArticleSection(
          headerImage: Image.asset('assets/images/card_heroes/gen4.png'),
          title: Text(data['body_2_3_title']!),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(data['body_2_3']!),
              ),
            ],
          ),
        ),
        ArticleSection(
          title: Text(data['body_2_4_title']!),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(data['body_2_4']!),
              ),
            ],
          ),
        ),
        ArticleSection(
          title: Text(data['body_2_5_title']!),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(data['body_2_5']!),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: _buildVideoPlaceholder(context, 'XDK-aLkGvkA'),
              ),
            ],
          ),
        ),
        ArticleSection(
          title: Text(data['body_3_title']!),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(data['body_3']!),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadText(context),
      builder: _builder,
    );
  }
}

class ArticleSection extends StatelessWidget {
  final Widget title;
  final Widget body;
  final Widget? headerImage;

  const ArticleSection({
    super.key,
    required this.title,
    required this.body,
    this.headerImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...headerImage != null
              ? [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: headerImage,
                  )
                ]
              : [],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.titleLarge!,
              child: title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
