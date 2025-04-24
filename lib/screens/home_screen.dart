import 'package:flutter/material.dart';
import 'package:logger/web.dart';

import '../models/ingredient_model.dart';
import '../models/instruction_model.dart';
import '../models/recipe_model.dart';
import '../routes/routes.dart';
import '../ui/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Recipe getRecipe(String id) {
    return Recipe(
      id: id,
      title: 'title $id',
      description: 'description $id',
      score: 1,
      date: DateTime.now(),
      preparationTime: '10 MIN',
      ingredients: getIngredients(),
      steps: getSteps(),
    );
  }

  getList() {
    List<Recipe> recipes = [];

    for (var i = 0; i < 10; i++) {
      recipes.add(getRecipe(i.toString()));
    }

    return recipes;
  }

  getStep(int id) {
    return Instruction(
      id: id.toString(),
      stepOrder: id,
      description:
          "description description descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription",
    );
  }

  getSteps() {
    List<Instruction> steps = [];

    for (var i = 0; i < 10; i++) {
      steps.add(getStep(i));
    }

    return steps;
  }

  getIngredients() {
    List<Ingredient> ingredients = [];

    for (var i = 0; i < 20; i++) {
      ingredients.add(
        Ingredient(
          id: i.toString(),
          name: 'nome do ingrediente $i',
          quantity: '1/2',
        ),
      );
    }

    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    List<Recipe> recipes = getList();

    var logger = Logger();
    logger.d(recipes[0]);

    return Scaffold(
      appBar: AppBar(title: Text("Receitas")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.mainColor,
                  child: Text(
                    index.toString(),
                    style: TextStyle(color: AppColors.lightBackgroundColor),
                  ),
                ),
                title: Text(recipes[index].title),
                subtitle: Text(
                  "${recipes[index].ingredients.length} ingredientes.",
                ),
                tileColor: AppColors.lightBackgroundColor,
                trailing: Text(recipes[index].preparationTime),
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      Routes.recipe,
                      arguments: recipes[index],
                    ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => {Navigator.pushNamed(context, Routes.edit, arguments: {})},
        tooltip: 'Adicionar Receita',
        backgroundColor: AppColors.buttonMainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
