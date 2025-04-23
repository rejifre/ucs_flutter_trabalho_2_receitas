import 'package:flutter/material.dart';

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
      ingredients: [],
      steps: [],
    );
  }

  getList() {
    List<Recipe> recipes = [];

    for (var i = 0; i < 20; i++) {
      recipes.add(getRecipe(i.toString()));
    }

    return recipes;
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
            () => {Navigator.pushNamed(context, Routes.edit, arguments: {})},
        tooltip: 'Adicionar Receita',
        backgroundColor: AppColors.mainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
