import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../common/error.dart';
import '../../../models/more/attribution.dart';
import '../../../utils/url.dart';

class AttributionScreen extends StatelessWidget {
  static const String title = 'Attributions';
  static const String routeName = '/more/attributions';

  const AttributionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: const AttributionList(),
    );
  }
}

class AttributionList extends StatelessWidget {
  const AttributionList({Key? key}) : super(key: key);

  Widget _builder(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) return const ErrorScreen();

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    final docs = snapshot.data!.docs
        .map<Attribution>((s) => Attribution.fromSnapshot(s))
        .toList(growable: false);

    return ListView.separated(
        itemCount: snapshot.data!.size,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final doc = docs[index];
          return AttributionCard(doc: doc);
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('attributions')
          .orderBy('index')
          .snapshots(),
      builder: _builder,
    );
  }
}

class AttributionCard extends StatelessWidget {
  final Attribution doc;

  const AttributionCard({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: InkWell(
        onTap: doc.url != null ? () => openURL(doc.url!) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        doc.title,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Container(
                      child: Text(
                        doc.subtitle,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 14,
                            ),
                      ),
                    )
                  ],
                ),
              ),
              ...doc.url != null
                  ? [
                      Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: const Icon(Icons.chevron_right),
                      )
                    ]
                  : [],
            ],
          ),
        ),
      ),
    );
  }
}
