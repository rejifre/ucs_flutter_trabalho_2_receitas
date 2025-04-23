// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'ingredient_model.dart';
import 'instruction_model.dart';

class Recipe {
  String id;
  String title;
  String description;
  double score;
  DateTime date;
  String preparationTime;
  List<Ingredient> ingredients = [];
  List<Instruction> steps = [];
  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.score,
    required this.date,
    required this.preparationTime,
    required this.ingredients,
    required this.steps,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'score': score,
      'date': date.millisecondsSinceEpoch,
      'preparationTime': preparationTime,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      score: map['score'] as double,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      preparationTime: map['preparationTime'] as String,
      ingredients: List<Ingredient>.from(
        (map['ingredients'] as List<int>).map<Ingredient>(
          (x) => Ingredient.fromMap(x as Map<String, dynamic>),
        ),
      ),
      steps: List<Instruction>.from(
        (map['steps'] as List<int>).map<Instruction>(
          (x) => Instruction.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) =>
      Recipe.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, description: $description, score: $score, date: $date, preparationTime: $preparationTime, ingredients: $ingredients, steps: $steps)';
  }
}
