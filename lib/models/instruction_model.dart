// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Instruction {
  String id;
  int stepOrder;
  String description;
  Instruction({
    required this.id,
    required this.stepOrder,
    required this.description,
  });

  Instruction copyWith({String? id, int? stepOrder, String? description}) {
    return Instruction(
      id: id ?? this.id,
      stepOrder: stepOrder ?? this.stepOrder,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'stepOrder': stepOrder,
      'description': description,
    };
  }

  factory Instruction.fromMap(Map<String, dynamic> map) {
    return Instruction(
      id: map['id'] as String,
      stepOrder: map['stepOrder'] as int,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Instruction.fromJson(String source) =>
      Instruction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Instruction(id: $id, stepOrder: $stepOrder, description: $description)';

  @override
  bool operator ==(covariant Instruction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.stepOrder == stepOrder &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ stepOrder.hashCode ^ description.hashCode;
}
