// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

/// Bindings to Ballistics Engine RS
class BallisticsEngine {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  BallisticsEngine(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  BallisticsEngine.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  /// Creates a new `Ammo` instance
  ffi.Pointer<Ammo> create_ammo(
    double damage,
    double armor_damage,
    double penetration,
    double frag_chance,
  ) {
    return _create_ammo(
      damage,
      armor_damage,
      penetration,
      frag_chance,
    );
  }

  late final _create_ammo_ptr =
      _lookup<ffi.NativeFunction<_c_create_ammo>>('create_ammo');
  late final _dart_create_ammo _create_ammo =
      _create_ammo_ptr.asFunction<_dart_create_ammo>();

  /// Creates a new `Armor` instance
  ffi.Pointer<Armor> create_armor(
    int class_,
    double durability,
    double durability_max,
    double destructibility,
    double blunt_throughput,
  ) {
    return _create_armor(
      class_,
      durability,
      durability_max,
      destructibility,
      blunt_throughput,
    );
  }

  late final _create_armor_ptr =
      _lookup<ffi.NativeFunction<_c_create_armor>>('create_armor');
  late final _dart_create_armor _create_armor =
      _create_armor_ptr.asFunction<_dart_create_armor>();

  /// Creates a new `PersonHealth` instance
  ffi.Pointer<PersonHealth> create_person_health(
    double head,
    double thorax,
    double stomach,
    double arm_left,
    double arm_right,
    double leg_left,
    double leg_right,
  ) {
    return _create_person_health(
      head,
      thorax,
      stomach,
      arm_left,
      arm_right,
      leg_left,
      leg_right,
    );
  }

  late final _create_person_health_ptr =
      _lookup<ffi.NativeFunction<_c_create_person_health>>(
          'create_person_health');
  late final _dart_create_person_health _create_person_health =
      _create_person_health_ptr.asFunction<_dart_create_person_health>();

  /// Destroys and frees the memory of a `PersonHealth` instance
  void destroy_person_health(
    ffi.Pointer<PersonHealth> health,
  ) {
    return _destroy_person_health(
      health,
    );
  }

  late final _destroy_person_health_ptr =
      _lookup<ffi.NativeFunction<_c_destroy_person_health>>(
          'destroy_person_health');
  late final _dart_destroy_person_health _destroy_person_health =
      _destroy_person_health_ptr.asFunction<_dart_destroy_person_health>();

  /// Returns the current health status of a `HealthCalculator` instance
  ffi.Pointer<PersonHealth> healh_get_person_health(
    ffi.Pointer<HealthCalculator> calculator,
  ) {
    return _healh_get_person_health(
      calculator,
    );
  }

  late final _healh_get_person_health_ptr =
      _lookup<ffi.NativeFunction<_c_healh_get_person_health>>(
          'healh_get_person_health');
  late final _dart_healh_get_person_health _healh_get_person_health =
      _healh_get_person_health_ptr.asFunction<_dart_healh_get_person_health>();

  /// Creates a new `HealthCalculator` instance
  ffi.Pointer<HealthCalculator> health_create_calc(
    ffi.Pointer<PersonHealth> person,
    ffi.Pointer<Ammo> ammo,
  ) {
    return _health_create_calc(
      person,
      ammo,
    );
  }

  late final _health_create_calc_ptr =
      _lookup<ffi.NativeFunction<_c_health_create_calc>>('health_create_calc');
  late final _dart_health_create_calc _health_create_calc =
      _health_create_calc_ptr.asFunction<_dart_health_create_calc>();

  /// Destroys and frees the memory of a `HealthCalculator` instance
  void health_destroy_calc(
    ffi.Pointer<HealthCalculator> calculator,
  ) {
    return _health_destroy_calc(
      calculator,
    );
  }

  late final _health_destroy_calc_ptr =
      _lookup<ffi.NativeFunction<_c_health_destroy_calc>>(
          'health_destroy_calc');
  late final _dart_health_destroy_calc _health_destroy_calc =
      _health_destroy_calc_ptr.asFunction<_dart_health_destroy_calc>();

  /// Returns the alive status of a `HealthCalculator` instance
  int health_get_person_alive(
    ffi.Pointer<HealthCalculator> calculator,
  ) {
    return _health_get_person_alive(
      calculator,
    );
  }

  late final _health_get_person_alive_ptr =
      _lookup<ffi.NativeFunction<_c_health_get_person_alive>>(
          'health_get_person_alive');
  late final _dart_health_get_person_alive _health_get_person_alive =
      _health_get_person_alive_ptr.asFunction<_dart_health_get_person_alive>();

  /// Processes the impact of ammo on a body zone within a `HealthCalculator` instance
  ffi.Pointer<HealthCalculator> health_impact_on_zone(
    ffi.Pointer<HealthCalculator> calculator,
    int zone,
  ) {
    return _health_impact_on_zone(
      calculator,
      zone,
    );
  }

  late final _health_impact_on_zone_ptr =
      _lookup<ffi.NativeFunction<_c_health_impact_on_zone>>(
          'health_impact_on_zone');
  late final _dart_health_impact_on_zone _health_impact_on_zone =
      _health_impact_on_zone_ptr.asFunction<_dart_health_impact_on_zone>();

  /// Resets the calculation of a `HealthCalculator` instance
  ffi.Pointer<HealthCalculator> health_reset_calc(
    ffi.Pointer<HealthCalculator> calculator,
  ) {
    return _health_reset_calc(
      calculator,
    );
  }

  late final _health_reset_calc_ptr =
      _lookup<ffi.NativeFunction<_c_health_reset_calc>>('health_reset_calc');
  late final _dart_health_reset_calc _health_reset_calc =
      _health_reset_calc_ptr.asFunction<_dart_health_reset_calc>();

  /// Sets new ammo to a existing `HealthCalculator` instance
  ffi.Pointer<HealthCalculator> health_set_ammo(
    ffi.Pointer<HealthCalculator> calculator,
    ffi.Pointer<Ammo> ammo,
  ) {
    return _health_set_ammo(
      calculator,
      ammo,
    );
  }

  late final _health_set_ammo_ptr =
      _lookup<ffi.NativeFunction<_c_health_set_ammo>>('health_set_ammo');
  late final _dart_health_set_ammo _health_set_ammo =
      _health_set_ammo_ptr.asFunction<_dart_health_set_ammo>();

  /// Creates a new `PenetrationCalculator` instance
  ffi.Pointer<PenetrationCalculator> penetration_create_calc(
    ffi.Pointer<Armor> armor,
    ffi.Pointer<Ammo> ammo,
  ) {
    return _penetration_create_calc(
      armor,
      ammo,
    );
  }

  late final _penetration_create_calc_ptr =
      _lookup<ffi.NativeFunction<_c_penetration_create_calc>>(
          'penetration_create_calc');
  late final _dart_penetration_create_calc _penetration_create_calc =
      _penetration_create_calc_ptr.asFunction<_dart_penetration_create_calc>();

  /// Destroys and frees the memory of a `PenetrationCalculator` instance
  void penetration_destroy_calc(
    ffi.Pointer<PenetrationCalculator> calculator,
  ) {
    return _penetration_destroy_calc(
      calculator,
    );
  }

  late final _penetration_destroy_calc_ptr =
      _lookup<ffi.NativeFunction<_c_penetration_destroy_calc>>(
          'penetration_destroy_calc');
  late final _dart_penetration_destroy_calc _penetration_destroy_calc =
      _penetration_destroy_calc_ptr
          .asFunction<_dart_penetration_destroy_calc>();

  /// Returns the current penetration chance of a `PenetrationCalculator` instance
  double penetration_get_chance(
    ffi.Pointer<PenetrationCalculator> calculator,
  ) {
    return _penetration_get_chance(
      calculator,
    );
  }

  late final _penetration_get_chance_ptr =
      _lookup<ffi.NativeFunction<_c_penetration_get_chance>>(
          'penetration_get_chance');
  late final _dart_penetration_get_chance _penetration_get_chance =
      _penetration_get_chance_ptr.asFunction<_dart_penetration_get_chance>();

  /// Returns the current armor durability of a `PenetrationCalculator` instance
  double penetration_get_durability(
    ffi.Pointer<PenetrationCalculator> calculator,
  ) {
    return _penetration_get_durability(
      calculator,
    );
  }

  late final _penetration_get_durability_ptr =
      _lookup<ffi.NativeFunction<_c_penetration_get_durability>>(
          'penetration_get_durability');
  late final _dart_penetration_get_durability _penetration_get_durability =
      _penetration_get_durability_ptr
          .asFunction<_dart_penetration_get_durability>();

  /// Returns the maximum armor durability of a `PenetrationCalculator` instance
  double penetration_get_durability_max(
    ffi.Pointer<PenetrationCalculator> calculator,
  ) {
    return _penetration_get_durability_max(
      calculator,
    );
  }

  late final _penetration_get_durability_max_ptr =
      _lookup<ffi.NativeFunction<_c_penetration_get_durability_max>>(
          'penetration_get_durability_max');
  late final _dart_penetration_get_durability_max
      _penetration_get_durability_max = _penetration_get_durability_max_ptr
          .asFunction<_dart_penetration_get_durability_max>();

  /// Sets new ammo to a existing `PenetrationCalculator` instance
  ffi.Pointer<PenetrationCalculator> penetration_set_ammo(
    ffi.Pointer<PenetrationCalculator> calculator,
    ffi.Pointer<Ammo> ammo,
  ) {
    return _penetration_set_ammo(
      calculator,
      ammo,
    );
  }

  late final _penetration_set_ammo_ptr =
      _lookup<ffi.NativeFunction<_c_penetration_set_ammo>>(
          'penetration_set_ammo');
  late final _dart_penetration_set_ammo _penetration_set_ammo =
      _penetration_set_ammo_ptr.asFunction<_dart_penetration_set_ammo>();

  /// Sets new armor to a existing `PenetrationCalculator` instance
  ffi.Pointer<PenetrationCalculator> penetration_set_armor(
    ffi.Pointer<PenetrationCalculator> calculator,
    ffi.Pointer<Armor> armor,
  ) {
    return _penetration_set_armor(
      calculator,
      armor,
    );
  }

  late final _penetration_set_armor_ptr =
      _lookup<ffi.NativeFunction<_c_penetration_set_armor>>(
          'penetration_set_armor');
  late final _dart_penetration_set_armor _penetration_set_armor =
      _penetration_set_armor_ptr.asFunction<_dart_penetration_set_armor>();

  /// Sets armor durability of a `PenetrationCalculator` instance
  ffi.Pointer<PenetrationCalculator> penetration_set_durability(
    ffi.Pointer<PenetrationCalculator> calculator,
    double durability,
  ) {
    return _penetration_set_durability(
      calculator,
      durability,
    );
  }

  late final _penetration_set_durability_ptr =
      _lookup<ffi.NativeFunction<_c_penetration_set_durability>>(
          'penetration_set_durability');
  late final _dart_penetration_set_durability _penetration_set_durability =
      _penetration_set_durability_ptr
          .asFunction<_dart_penetration_set_durability>();
}

class Ammo extends ffi.Opaque {}

class Armor extends ffi.Opaque {}

/// Calculator for calculating the impact of ammunition on a body
class HealthCalculator extends ffi.Opaque {}

/// Calculator for calculating the impact of ammunition on armor
class PenetrationCalculator extends ffi.Opaque {}

class PersonHealth extends ffi.Struct {
  @ffi.Double()
  external double head;

  @ffi.Double()
  external double thorax;

  @ffi.Double()
  external double stomach;

  @ffi.Double()
  external double arm_left;

  @ffi.Double()
  external double arm_right;

  @ffi.Double()
  external double leg_left;

  @ffi.Double()
  external double leg_right;
}

typedef _c_create_ammo = ffi.Pointer<Ammo> Function(
  ffi.Double damage,
  ffi.Double armor_damage,
  ffi.Double penetration,
  ffi.Double frag_chance,
);

typedef _dart_create_ammo = ffi.Pointer<Ammo> Function(
  double damage,
  double armor_damage,
  double penetration,
  double frag_chance,
);

typedef _c_create_armor = ffi.Pointer<Armor> Function(
  ffi.Int32 class_,
  ffi.Double durability,
  ffi.Double durability_max,
  ffi.Double destructibility,
  ffi.Double blunt_throughput,
);

typedef _dart_create_armor = ffi.Pointer<Armor> Function(
  int class_,
  double durability,
  double durability_max,
  double destructibility,
  double blunt_throughput,
);

typedef _c_create_person_health = ffi.Pointer<PersonHealth> Function(
  ffi.Double head,
  ffi.Double thorax,
  ffi.Double stomach,
  ffi.Double arm_left,
  ffi.Double arm_right,
  ffi.Double leg_left,
  ffi.Double leg_right,
);

typedef _dart_create_person_health = ffi.Pointer<PersonHealth> Function(
  double head,
  double thorax,
  double stomach,
  double arm_left,
  double arm_right,
  double leg_left,
  double leg_right,
);

typedef _c_destroy_person_health = ffi.Void Function(
  ffi.Pointer<PersonHealth> health,
);

typedef _dart_destroy_person_health = void Function(
  ffi.Pointer<PersonHealth> health,
);

typedef _c_healh_get_person_health = ffi.Pointer<PersonHealth> Function(
  ffi.Pointer<HealthCalculator> calculator,
);

typedef _dart_healh_get_person_health = ffi.Pointer<PersonHealth> Function(
  ffi.Pointer<HealthCalculator> calculator,
);

typedef _c_health_create_calc = ffi.Pointer<HealthCalculator> Function(
  ffi.Pointer<PersonHealth> person,
  ffi.Pointer<Ammo> ammo,
);

typedef _dart_health_create_calc = ffi.Pointer<HealthCalculator> Function(
  ffi.Pointer<PersonHealth> person,
  ffi.Pointer<Ammo> ammo,
);

typedef _c_health_destroy_calc = ffi.Void Function(
  ffi.Pointer<HealthCalculator> calculator,
);

typedef _dart_health_destroy_calc = void Function(
  ffi.Pointer<HealthCalculator> calculator,
);

typedef _c_health_get_person_alive = ffi.Int32 Function(
  ffi.Pointer<HealthCalculator> calculator,
);

typedef _dart_health_get_person_alive = int Function(
  ffi.Pointer<HealthCalculator> calculator,
);

typedef _c_health_impact_on_zone = ffi.Pointer<HealthCalculator> Function(
  ffi.Pointer<HealthCalculator> calculator,
  ffi.Uint32 zone,
);

typedef _dart_health_impact_on_zone = ffi.Pointer<HealthCalculator> Function(
  ffi.Pointer<HealthCalculator> calculator,
  int zone,
);

typedef _c_health_reset_calc = ffi.Pointer<HealthCalculator> Function(
  ffi.Pointer<HealthCalculator> calculator,
);

typedef _dart_health_reset_calc = ffi.Pointer<HealthCalculator> Function(
  ffi.Pointer<HealthCalculator> calculator,
);

typedef _c_health_set_ammo = ffi.Pointer<HealthCalculator> Function(
  ffi.Pointer<HealthCalculator> calculator,
  ffi.Pointer<Ammo> ammo,
);

typedef _dart_health_set_ammo = ffi.Pointer<HealthCalculator> Function(
  ffi.Pointer<HealthCalculator> calculator,
  ffi.Pointer<Ammo> ammo,
);

typedef _c_penetration_create_calc = ffi.Pointer<PenetrationCalculator>
    Function(
  ffi.Pointer<Armor> armor,
  ffi.Pointer<Ammo> ammo,
);

typedef _dart_penetration_create_calc = ffi.Pointer<PenetrationCalculator>
    Function(
  ffi.Pointer<Armor> armor,
  ffi.Pointer<Ammo> ammo,
);

typedef _c_penetration_destroy_calc = ffi.Void Function(
  ffi.Pointer<PenetrationCalculator> calculator,
);

typedef _dart_penetration_destroy_calc = void Function(
  ffi.Pointer<PenetrationCalculator> calculator,
);

typedef _c_penetration_get_chance = ffi.Double Function(
  ffi.Pointer<PenetrationCalculator> calculator,
);

typedef _dart_penetration_get_chance = double Function(
  ffi.Pointer<PenetrationCalculator> calculator,
);

typedef _c_penetration_get_durability = ffi.Double Function(
  ffi.Pointer<PenetrationCalculator> calculator,
);

typedef _dart_penetration_get_durability = double Function(
  ffi.Pointer<PenetrationCalculator> calculator,
);

typedef _c_penetration_get_durability_max = ffi.Double Function(
  ffi.Pointer<PenetrationCalculator> calculator,
);

typedef _dart_penetration_get_durability_max = double Function(
  ffi.Pointer<PenetrationCalculator> calculator,
);

typedef _c_penetration_set_ammo = ffi.Pointer<PenetrationCalculator> Function(
  ffi.Pointer<PenetrationCalculator> calculator,
  ffi.Pointer<Ammo> ammo,
);

typedef _dart_penetration_set_ammo = ffi.Pointer<PenetrationCalculator>
    Function(
  ffi.Pointer<PenetrationCalculator> calculator,
  ffi.Pointer<Ammo> ammo,
);

typedef _c_penetration_set_armor = ffi.Pointer<PenetrationCalculator> Function(
  ffi.Pointer<PenetrationCalculator> calculator,
  ffi.Pointer<Armor> armor,
);

typedef _dart_penetration_set_armor = ffi.Pointer<PenetrationCalculator>
    Function(
  ffi.Pointer<PenetrationCalculator> calculator,
  ffi.Pointer<Armor> armor,
);

typedef _c_penetration_set_durability = ffi.Pointer<PenetrationCalculator>
    Function(
  ffi.Pointer<PenetrationCalculator> calculator,
  ffi.Double durability,
);

typedef _dart_penetration_set_durability = ffi.Pointer<PenetrationCalculator>
    Function(
  ffi.Pointer<PenetrationCalculator> calculator,
  double durability,
);
