import '../../utils/index.dart';

class MarketItem implements Indexable {
  final String id;
  final String name;
  final String shortName;
  final int avgPrice24h;
  final double diff24h;
  final int slots;

  bool isStarred = false;

  int? _slotPrice;

  MarketItem.fromMap(Map<String, dynamic> map)
      : assert(map['_id'] != null),
        assert(map['name'] != null),
        assert(map['shortName'] != null),
        assert(map['slots'] != null),
        id = map['_id'],
        name = map['name'],
        shortName = map['shortName'],
        avgPrice24h = (map['avgPrice24h'] ?? 0),
        diff24h = (map['diff24h']?.toDouble() ?? 0),
        slots = map['slots'],
        _slotPrice = null;

  int get slotPrice {
    _slotPrice ??= (avgPrice24h / slots).round();
    return _slotPrice!;
  }

  @override
  List<String> get indexData => [
        shortName,
        name,
      ];
}
