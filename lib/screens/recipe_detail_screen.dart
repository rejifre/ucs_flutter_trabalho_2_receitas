import 'package:flutter/material.dart';

import '../models/recipe_model.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key});

  @override
  State<RecipeDetailScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RecipeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: Column(
        children: [
          Text(recipe.description),
          Text(recipe.preparationTime),
          Text(recipe.date.toString()),
          Text(recipe.score.toString()),
        ],
      ),
    );
  }
}
