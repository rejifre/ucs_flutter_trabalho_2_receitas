import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:ucs_flutter_trabalho_2_receitas/ui/recipe_screen_type.dart';
import 'package:uuid/uuid.dart';

import '../models/edit_recipe_screen_arguments_model.dart';
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

  Recipe getDefaultRecipe() {
    return Recipe(
      id: Uuid().v4(),
      title: '',
      description: '',
      score: 0,
      date: DateTime.now(),
      preparationTime: '',
      ingredients: [],
      steps: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Recipe> recipes = getList();

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
            () => {
              Navigator.pushNamed(
                context,
                Routes.editRecipe,
                arguments: EditRecipeScreenArgumentsModel(
                  RecipeScreenType.editRecipe,
                  null,
                ),
              ),
            },
        tooltip: 'Adicionar Receita',
        backgroundColor: AppColors.buttonMainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
