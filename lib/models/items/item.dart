import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/index.dart';

enum ItemType {
  ammo,
  armor,
  bodyArmor,
  chestRig,
  firearm,
  helmet,
  medical,
  melee,
  throwable,
  attachment,
}

extension Database on ItemType {
  CollectionReference get collection {
    final instance = FirebaseFirestore.instance;

    switch (this) {
      case ItemType.ammo:
        return instance.collection('ammunition');
      case ItemType.armor:
      case ItemType.bodyArmor:
      case ItemType.helmet:
      case ItemType.attachment:
        return instance.collection('armor');
      case ItemType.chestRig:
        return instance.collection('tacticalrig');
      case ItemType.firearm:
        return instance.collection('firearm');
      case ItemType.medical:
        return instance.collection('medical');
      case ItemType.melee:
        return instance.collection('melee');
      case ItemType.throwable:
        return instance.collection('grenade');
    }
  }

  Query getQuery(String? sortBy, {bool descending = false}) {
    final ref = collection;

    var query =
        sortBy != null ? ref.orderBy(sortBy, descending: descending) : null;

    switch (this) {
      case ItemType.ammo:
        query ??= ref.orderBy('caliber', descending: descending);
        break;
      case ItemType.armor:
        query ??= ref.orderBy('armor.class', descending: descending);
        break;
      case ItemType.bodyArmor:
        query ??= ref.orderBy('armor.class', descending: descending);
        query = query.where('type', isEqualTo: 'body');
        break;
      case ItemType.chestRig:
        query ??= ref.orderBy('shortName', descending: descending);
        break;
      case ItemType.firearm:
        query ??= ref.orderBy('class', descending: descending);
        break;
      case ItemType.helmet:
        query ??= ref.orderBy('armor.class', descending: descending);
        query = query.where('type', isEqualTo: 'helmet');
        break;
      case ItemType.medical:
        query ??= ref.orderBy('type', descending: descending);
        break;
      case ItemType.melee:
        query ??= ref.orderBy('shortName', descending: descending);
        break;
      case ItemType.throwable:
        query ??= ref.orderBy('type', descending: descending);
        break;
      case ItemType.attachment:
        query ??= ref.orderBy('armor.class', descending: descending);
        query = query.where('type', whereIn: <String>['visor', 'attachment']);
        break;
    }

    return query;
  }
}

ItemType? itemTypeByReference(DocumentReference reference) {
  switch (reference.path.split('/')[0]) {
    case 'ammunition':
      return ItemType.ammo;
    case 'armor':
      return ItemType.armor;
    case 'tacticalrig':
      return ItemType.chestRig;
    case 'firearm':
      return ItemType.firearm;
    case 'helmet':
      return ItemType.helmet;
    case 'medical':
      return ItemType.medical;
    case 'melee':
      return ItemType.melee;
    case 'grenade':
      return ItemType.throwable;
    case 'visor':
      return ItemType.attachment;
  }

  return null;
}

class ItemTypeException implements Exception {
  ItemTypeException(this.cause);

  String cause;
}

enum ItemKind {
  ammunition,
  armor,
  backpack,
  barter,
  clothing,
  common,
  container,
  firearm,
  food,
  grenade,
  headphone,
  key,
  magazine,
  map,
  medical,
  melee,
  modification,
  barrel,
  bipod,
  charge,
  device,
  foregrip,
  gasblock,
  goggles,
  handguard,
  launcher,
  mount,
  muzzle,
  pistolgrip,
  receiver,
  sight,
  sightSpecial,
  stock,
  money,
  tacticalrig,
}

extension StringParsing on String {
  ItemKind toItemKind() {
    switch (this) {
      case 'ammunition':
        return ItemKind.ammunition;
      case 'armor':
        return ItemKind.armor;
      case 'backpack':
        return ItemKind.backpack;
      case 'barter':
        return ItemKind.barter;
      case 'clothing':
        return ItemKind.clothing;
      case 'container':
        return ItemKind.container;
      case 'firearm':
        return ItemKind.firearm;
      case 'food':
        return ItemKind.food;
      case 'grenade':
        return ItemKind.grenade;
      case 'headphone':
        return ItemKind.headphone;
      case 'key':
        return ItemKind.key;
      case 'magazine':
        return ItemKind.magazine;
      case 'map':
        return ItemKind.map;
      case 'medical':
        return ItemKind.medical;
      case 'melee':
        return ItemKind.melee;
      case 'modification':
        return ItemKind.modification;
      case 'modificationBarrel':
        return ItemKind.barrel;
      case 'modificationBipod':
        return ItemKind.bipod;
      case 'modificationCharge':
        return ItemKind.charge;
      case 'modificationDevice':
        return ItemKind.device;
      case 'modificationForegrip':
        return ItemKind.foregrip;
      case 'modificationGasblock':
        return ItemKind.gasblock;
      case 'modificationGoggles':
        return ItemKind.goggles;
      case 'modificationHandguard':
        return ItemKind.handguard;
      case 'modificationLauncher':
        return ItemKind.launcher;
      case 'modificationMount':
        return ItemKind.mount;
      case 'modificationMuzzle':
        return ItemKind.muzzle;
      case 'modificationPistolgrip':
        return ItemKind.pistolgrip;
      case 'modificationReceiver':
        return ItemKind.receiver;
      case 'modificationSight':
        return ItemKind.sight;
      case 'modificationSightSpecial':
        return ItemKind.sightSpecial;
      case 'modificationStock':
        return ItemKind.stock;
      case 'money':
        return ItemKind.money;
      case 'tacticalrig':
        return ItemKind.tacticalrig;
      default:
        return ItemKind.common;
    }
  }
}

class Item implements Indexable {
  final String id;
  final String name;
  final String shortName;
  final String description;
  final Mass weight;
  final ItemKind kind;

  final DocumentReference? reference;

  ItemType? _type;

  Item({
    required this.id,
    required this.name,
    required this.shortName,
    required this.description,
    required this.weight,
    required this.kind,
    this.reference,
  });

  Item.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['_id'] != null),
        assert(map['name'] != null),
        assert(map['shortName'] != null),
        assert(map['description'] != null),
        assert(map['weight'] != null),
        assert(map['_kind'] != null),
        id = map['_id'],
        name = map['name'],
        shortName = map['shortName'],
        description = map['description'],
        weight = Mass(kg: map['weight'].toDouble()),
        kind = (map['_kind'] as String).toItemKind(),
        _type = null;

  Item.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  @override
  String toString() => 'Item<$type:$id>';

  ItemType get type {
    if (reference != null) {
      _type ??= itemTypeByReference(reference!);
    }

    if (_type == null) {
      throw ItemTypeException('unknown item type');
    }

    return _type!;
  }

  @override
  List<String> get indexData => [
        shortName,
        name,
      ];
}

abstract class SectionView extends Item {
  SectionView.fromSnapshot(DocumentSnapshot<Object?> snapshot)
      : super.fromSnapshot(snapshot);

  String? get sectionValue;
}

abstract class DetailView extends Item {
  DetailView.fromSnapshot(DocumentSnapshot<Object?> snapshot)
      : super.fromSnapshot(snapshot);

  List<PropertySection> get propertySections;
}

class PropertySection {
  final String title;
  final List<DisplayProperty> properties;

  PropertySection({
    required this.title,
    required this.properties,
  });
}

class DisplayProperty {
  final String name;
  final String value;

  DisplayProperty({
    required this.name,
    required this.value,
  });
}

abstract class ComparisonView extends Item {
  ComparisonView.fromSnapshot(DocumentSnapshot<Object?> snapshot)
      : super.fromSnapshot(snapshot);

  List<ComparableProperty> get comparableProperties;
}

class ComparableProperty {
  final String name;
  final num value;
  final bool isLowerBetter;
  final String? displayValue;

  ComparableProperty(this.name, this.value,
      {this.isLowerBetter = false, this.displayValue});
}

abstract class TableView extends Item {
  TableView.fromSnapshot(DocumentSnapshot<Object?> snapshot)
      : super.fromSnapshot(snapshot);

  List<String> get tableHeaders;
  List<dynamic> get tableData;
}

abstract class ExplorableItem extends Item
    implements DetailView, ComparisonView {
  ExplorableItem.fromSnapshot(DocumentSnapshot<Object?> snapshot)
      : super.fromSnapshot(snapshot);
}

abstract class ExplorableSectionItem implements ExplorableItem, SectionView {}

class Speed {
  final double metersPerSecond;

  Speed({double metersPerSecond = 0.0}) : metersPerSecond = metersPerSecond;

  @override
  String toString() => '$metersPerSecond m/s';
}

class Length {
  final double meter;

  Length({double meter = 0.0}) : meter = meter;

  @override
  String toString() => '$meter m';
}

class Mass {
  final double kilograms;
  final double grams;

  Mass({double kg = 0, double g = 0})
      : kilograms = kg != 0 ? kg : g / 1000,
        grams = g != 0 ? g : kg * 1000;

  @override
  String toString() => '$grams g';

  String toStringAsGrams() => '$grams g';

  String toStringAsKilograms() => '$kilograms kg';
}
