import 'package:flutter/material.dart';
import 'package:ucs_flutter_trabalho_2_receitas/repositories/recipe_repository.dart';
import 'package:ucs_flutter_trabalho_2_receitas/ui/recipe_screen_type.dart';

import '../models/edit_recipe_screen_arguments_model.dart';
import '../models/recipe_model.dart';
import '../routes/routes.dart';
import '../ui/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> _recipes = [];
  RecipeRepository repository = RecipeRepository();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() async {
    var recipes = await repository.getAllRecipes();
    setState(() {
      _recipes = recipes;
    });
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
                trailing: Text(_recipes[index].preparationTime),
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      Routes.recipe,
                      arguments: _recipes[index],
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
