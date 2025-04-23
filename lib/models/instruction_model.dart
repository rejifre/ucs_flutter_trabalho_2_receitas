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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'step_order': stepOrder,
      'description': description,
    };
  }

  factory Instruction.fromMap(Map<String, dynamic> map) {
    return Instruction(
      id: map['id'] as String,
      stepOrder: map['step_order'] as int,
      description: map['instruction'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Instruction.fromJson(String source) =>
      Instruction.fromMap(json.decode(source) as Map<String, dynamic>);
}
