// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Ingredient {
  String id;
  String name;
  String quantity;
  Ingredient({required this.id, required this.name, required this.quantity});

  Ingredient copyWith({String? id, String? name, String? quantity}) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'quantity': quantity};
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ingredient.fromJson(String source) =>
      Ingredient.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Ingredient(id: $id, name: $name, quantity: $quantity)';

  @override
  bool operator ==(covariant Ingredient other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.quantity == quantity;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ quantity.hashCode;
}
