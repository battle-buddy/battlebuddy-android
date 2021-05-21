import 'dart:ffi';

import '../../models/items/ammunition.dart';
import '../../models/items/armor.dart';
import 'bindings.dart' as bindings;
import 'utils.dart';

class PenetrationCalculator {
  final bindings.BallisticsEngine _engine =
      bindings.BallisticsEngine(loadLibrary());
  Pointer<bindings.PenetrationCalculator>? _calculator;

  Armored? _armor;
  Ammunition? _ammo;

  void dispose() {
    if (_calculator == null) return;
    _engine.penetration_destroy_calc(_calculator!);
  }

  Pointer<bindings.Armor> _toArmorPtr(Armored? armor) {
    if (armor == null && armor!.armorProperties != null) {
      throw PenetrationCalculatorException('Armor value is null or un-armored');
    }

    final armorPtr = _engine.create_armor(
      armor.armorProperties!.armorClass,
      armor.armorProperties!.durability,
      armor.armorProperties!.durability,
      armor.armorProperties!.material.destructibility,
      armor.armorProperties!.bluntThroughput,
    );

    return armorPtr;
  }

  Pointer<bindings.Ammo> _toAmmoPtr(Ammunition? ammo) {
    if (ammo == null) {
      throw PenetrationCalculatorException('Ammo value is null');
    }

    final ammoPtr = _engine.create_ammo(
      ammo.damage,
      ammo.armorDamage,
      ammo.penetration,
      ammo.fragmentation.chance,
    );

    return ammoPtr;
  }

  void createCalculation(Armored? armor, Ammunition? ammo) {
    try {
      final armorPtr = _toArmorPtr(armor);
      final ammoPtr = _toAmmoPtr(ammo);

      _calculator = _engine.penetration_create_calc(armorPtr, ammoPtr);

      if (_calculator == null) {
        throw PenetrationCalculatorException(
            'Error while creating new calculation');
      }
    } on PenetrationCalculatorException {
      rethrow;
    }
  }

  set armor(Armored? value) {
    if (_calculator == null) {
      throw PenetrationCalculatorException(
          PenetrationCalculatorException.noCalculator);
    }

    _calculator =
        _engine.penetration_set_armor(_calculator!, _toArmorPtr(value));
    if (_calculator == null) {
      throw PenetrationCalculatorException('Error while setting armor');
    }
  }

  Armored? get armor => _armor;

  set ammo(Ammunition? value) {
    if (_calculator == null) {
      throw PenetrationCalculatorException(
          PenetrationCalculatorException.noCalculator);
    }

    _calculator = _engine.penetration_set_ammo(_calculator!, _toAmmoPtr(value));
    if (_calculator == null) {
      throw PenetrationCalculatorException('Error while setting ammo');
    }
  }

  Ammunition? get ammo => _ammo;

  set durability(double value) {
    if (_calculator == null) {
      throw PenetrationCalculatorException(
          PenetrationCalculatorException.noCalculator);
    }

    _calculator = _engine.penetration_set_durability(_calculator!, value);
    if (_calculator == null) {
      throw PenetrationCalculatorException('Error while setting durability');
    }
  }

  double get durability {
    if (_calculator == null) {
      throw PenetrationCalculatorException(
          PenetrationCalculatorException.noCalculator);
    }

    final value = _engine.penetration_get_durability(_calculator!);
    if (value.isNegative) {
      throw PenetrationCalculatorException('Error while getting durability');
    }

    return value;
  }

  double get penetrationChance {
    if (_calculator == null) {
      throw PenetrationCalculatorException(
          PenetrationCalculatorException.noCalculator);
    }

    final value = _engine.penetration_get_chance(_calculator!);
    if (value.isNegative) {
      throw PenetrationCalculatorException(
        'Error while getting penetration chance',
      );
    }

    return value;
  }

  double get maxDurability {
    if (_calculator == null) {
      throw PenetrationCalculatorException(
          PenetrationCalculatorException.noCalculator);
    }

    final value = _engine.penetration_get_durability_max(_calculator!);
    if (value.isNegative) {
      throw PenetrationCalculatorException(
        'Error while getting max durability',
      );
    }

    return value;
  }
}

class PenetrationCalculatorException implements Exception {
  static const String noCalculator = 'No calculation was created';

  String cause;

  PenetrationCalculatorException(this.cause);
}
