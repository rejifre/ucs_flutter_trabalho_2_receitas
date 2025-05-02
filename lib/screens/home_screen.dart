import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/edit_recipe_screen_arguments_model.dart';
import '../models/recipe_model.dart';
import '../routes/routes.dart';
import '../services/recipes_service.dart';
import '../ui/app_colors.dart';
import '../ui/recipe_screen_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> _recipes = [];
  RecipesService service = RecipesService();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final recipes = await service.getAllRecipes();
    setState(() {
      _recipes = recipes;
    });
  }

  void _navigateToAdd() async {
    await Navigator.pushNamed(
      context,
      Routes.editRecipe,
      arguments: EditRecipeScreenArgumentsModel(
        RecipeScreenType.newRecipe,
        null,
      ),
    );

    await _loadRecipes();
  }

  void _navigateToDetail(Recipe recipe) async {
    await Navigator.pushNamed(context, Routes.recipe, arguments: recipe);
    await _loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Receitas")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: ListView.builder(
          itemCount: _recipes.length,
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
                title: Text(_recipes[index].title),
                subtitle: Text(
                  "${_recipes[index].ingredients.length} ingredientes.",
                ),
                tileColor: AppColors.lightBackgroundColor,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Icon(Icons.timer_sharp, size: 15),
                    Text(_recipes[index].preparationTime),
                  ],
                ),
                onTap: () => _navigateToDetail(_recipes[index]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        tooltip: 'Adicionar Receita',
        backgroundColor: AppColors.buttonMainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
