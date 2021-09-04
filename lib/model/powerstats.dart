import 'package:json_annotation/json_annotation.dart';

part 'powerstats.g.dart';

@JsonSerializable()
class Powerstats {
  final String intelligence;
  final String strength;
  final String speed;
  final String durability;
  final String power;
  final String combat;

  Powerstats({
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
  });

  bool isNotNull() =>
      intelligence != 'null' &&
      strength != 'null' &&
      speed != 'null' &&
      durability != 'null' &&
      power != 'null' &&
      combat != 'null';

  double convertStringToPercent(String value) {
    final intValue = int.tryParse(value);
    if (intValue == null) return 0;
    return intValue/100;
  }

  double get intelligencePercent => convertStringToPercent(intelligence);
  double get strengthPercent => convertStringToPercent(strength);
  double get speedPercent => convertStringToPercent(speed);
  double get durabilityPercent => convertStringToPercent(durability);
  double get powerPercent => convertStringToPercent(power);
  double get combatPercent => convertStringToPercent(combat);

  factory Powerstats.fromJson(final Map<String, dynamic> json) =>
      _$PowerstatsFromJson(json);

  Map<String, dynamic> toJson() => _$PowerstatsToJson(this);

  @override
  String toString() {
    return 'Powerstats{intelligence: $intelligence, strength: $strength, speed: $speed, durability: $durability, power: $power, combat: $combat}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Powerstats &&
          runtimeType == other.runtimeType &&
          intelligence == other.intelligence &&
          strength == other.strength &&
          speed == other.speed &&
          durability == other.durability &&
          power == other.power &&
          combat == other.combat;

  @override
  int get hashCode =>
      intelligence.hashCode ^
      strength.hashCode ^
      speed.hashCode ^
      durability.hashCode ^
      power.hashCode ^
      combat.hashCode;
}
