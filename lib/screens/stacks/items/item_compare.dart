import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../common/error.dart';
import '../../../models/items/item.dart';

class ItemComparisonScreenArguments<T extends ComparisonView> {
  final List<T> items;
  final HashSet<String> selectedIDs;

  const ItemComparisonScreenArguments(this.items, this.selectedIDs);
}

class ItemComparisonScreen<T extends ComparisonView> extends StatelessWidget {
  static const String title = 'Compare';
  static const String routeName = '/items/compare';

  const ItemComparisonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as ItemComparisonScreenArguments<ComparisonView>;

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: ItemComparisonList(
        items: args.items,
        selectedIDs: args.selectedIDs,
      ),
    );
  }
}

class ItemComparisonList<T extends ComparisonView> extends StatefulWidget {
  final List<T> items;
  final HashSet<String> selectedIDs;

  const ItemComparisonList({
    Key? key,
    required this.items,
    required this.selectedIDs,
  }) : super(key: key);

  @override
  _ItemComparisonListState<T> createState() => _ItemComparisonListState<T>();
}

class _ItemComparisonListState<T extends ComparisonView>
    extends State<ItemComparisonList<T>> {
  List<GraphSection>? _sections;
  Exception? _error;

  @override
  void initState() {
    super.initState();
    _buildSections(widget.items, widget.selectedIDs);
  }

  Future<void> _buildSections(List<T> items, HashSet<String> selected) async {
    final sections = <GraphSection>[];
    final properties = items.first.comparableProperties;

    for (final prop in properties.asMap().entries) {
      final index = prop.key;
      final value = prop.value.value;

      final selectedItems = <T>[];

      var minValue = value;
      var maxValue = value;

      for (final item in items) {
        final value = item.comparableProperties[index].value!;
        minValue = min(value, minValue!);
        maxValue = max(value, maxValue!);

        if (selected.contains(item.id)) selectedItems.add(item);
      }

      if (minValue == 0.0 && maxValue == 0.0) continue;

      final graphs = <PropertyGraph>[];

      for (final item in selectedItems) {
        final currentProp = item.comparableProperties[index];
        final value = currentProp.value!;
        final percent = (value - minValue!) / (maxValue! - minValue) * 1.0;

        final graph = PropertyGraph(
          name: item.shortName,
          value: currentProp.displayValue ?? currentProp.value.toString(),
          percent: prop.value.isLowerBetter ? 1.0 - percent : percent,
        );

        graphs.add(graph);
      }

      sections.add(GraphSection(title: prop.value.name, graphs: graphs));
    }

    setState(() {
      _sections = sections;
    });
  }

  List<Color> _calculateColorRange(BuildContext context, int length) {
    final color = HSLColor.fromColor(Theme.of(context).accentColor)
        .withHue(354)
        .toColor();
    final redValue = (255 / length).round();

    return List.generate(
      length,
      (i) => color.withRed(i * redValue),
      growable: false,
    ).reversed.toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return ErrorScreen();

    if (_sections == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: _sections!.length,
      separatorBuilder: (context, index) => const SizedBox(height: 30),
      itemBuilder: (context, index) {
        final section = _sections![index];
        final colors = _calculateColorRange(context, section.graphs.length);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              key: Key(section.title),
              padding: const EdgeInsets.only(bottom: 10, left: 5),
              child: Text(
                section.title.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: 18),
              ),
            ),
            ...section.graphs.asMap().entries.map(
                  (graph) => GraphBar(
                    key: Key('${section.title}#${graph.key}'),
                    name: graph.value.name,
                    value: graph.value.value,
                    percent: graph.value.percent,
                    color: colors[graph.key],
                  ),
                ),
          ],
        );
      },
    );
  }
}

class GraphBar extends StatelessWidget {
  final String? name;
  final String value;
  final double percent;
  final Color? color;

  const GraphBar({
    Key? key,
    required this.name,
    required this.value,
    this.percent = 0.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0.5),
      child: LinearPercentIndicator(
        percent: max(percent, 0.01),
        lineHeight: 28,
        linearStrokeCap: LinearStrokeCap.butt,
        center: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Text>[
              Text(
                name!,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Text(value),
            ],
          ),
        ),
        animation: true,
        animateFromLastPercent: true,
        animationDuration: 400,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(0),
        progressColor: color,
      ),
    );
  }
}

class GraphSection {
  final String title;
  final List<PropertyGraph> graphs;

  const GraphSection({
    required this.title,
    required this.graphs,
  });
}

class PropertyGraph {
  final String? name;
  final String value;
  final double percent;

  const PropertyGraph({
    required this.name,
    required this.value,
    required this.percent,
  });
}
