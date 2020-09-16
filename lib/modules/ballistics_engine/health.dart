import 'dart:ffi';

import '../../models/items/ammunition.dart';
import '../../models/learn/character.dart';
import 'bindings.dart' as bindings;
import 'utils.dart';

class HealthCalculator {
  final bindings.BallisticsEngine _engine =
      bindings.BallisticsEngine(loadLibrary());
  Pointer<bindings.HealthCalculator> _calculator;

  Ammunition _ammo;

  void dispose() {
    if (_calculator == null) return;
    _engine.health_destroy_calc(_calculator);
  }

  Pointer<bindings.PersonHealth> _toPersonHealthPtr(Health health) {
    if (health == null) {
      throw HealthCalculatorException('Health value is null');
    }

    final healthPtr = _engine.create_person_health(
      health.head,
      health.thorax,
      health.stomach,
      health.armLeft,
      health.armRight,
      health.legLeft,
      health.legRight,
    );

    if (healthPtr == null) {
      throw HealthCalculatorException(
        'Error while creating health pointer',
      );
    }

    return healthPtr;
  }

  Pointer<bindings.Ammo> _toAmmoPtr(Ammunition ammo) {
    if (ammo == null) {
      throw HealthCalculatorException('Ammo value is null');
    }

    final ammoPtr = _engine.create_ammo(
      ammo.damage,
      ammo.armorDamage,
      ammo.penetration,
      ammo.fragmentation.chance,
    );

    if (ammoPtr != null) {
      _ammo = ammo;
    } else {
      throw HealthCalculatorException(
        'Error while creating ammo pointer',
      );
    }

    return ammoPtr;
  }

  void createCalculation(Health health, Ammunition ammo) {
    try {
      final healthPtr = _toPersonHealthPtr(health);
      final ammoPtr = _toAmmoPtr(ammo);

      _calculator = _engine.health_create_calc(healthPtr, ammoPtr);

      if (_calculator == null) {
        throw HealthCalculatorException('Error while creating new calculation');
      }
    } on HealthCalculatorException {
      rethrow;
    }
  }

  set ammo(Ammunition value) {
    if (_calculator == null) {
      throw HealthCalculatorException(HealthCalculatorException.noCalculator);
    }

    _calculator = _engine.health_set_ammo(_calculator, _toAmmoPtr(value));
    if (_calculator == null) {
      throw HealthCalculatorException('Error while setting ammo');
    }
  }

  Ammunition get ammo => _ammo;

  Health get health {
    if (_calculator == null) {
      throw HealthCalculatorException(HealthCalculatorException.noCalculator);
    }

    final statusPtr = _engine.healh_get_person_health(_calculator);
    if (statusPtr == null) {
      throw HealthCalculatorException('Error while getting person status');
    }

    final status = Health.fromReference(statusPtr.ref);

    _engine.destroy_person_health(statusPtr);

    return status;
  }

  void impactOnZone(Zone zone) {
    if (_calculator == null) {
      throw HealthCalculatorException(HealthCalculatorException.noCalculator);
    }

    _calculator = _engine.health_impact_on_zone(_calculator, zone.index);
    if (_calculator == null) {
      throw HealthCalculatorException('Error while processing impact one zone');
    }
  }

  void reset() {
    if (_calculator == null) {
      throw HealthCalculatorException(HealthCalculatorException.noCalculator);
    }

    _calculator = _engine.health_reset_calc(_calculator);
    if (_calculator == null) {
      throw HealthCalculatorException('Error while resetting calculator');
    }
  }
}

class HealthCalculatorException implements Exception {
  static const String noCalculator = 'No calculation was created';

  String cause;

  HealthCalculatorException(this.cause);
}

enum Zone {
  head,
  thorax,
  stomach,
  armLeft,
  armRight,
  legLeft,
  legRight,
}
