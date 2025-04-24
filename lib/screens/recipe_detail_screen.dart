import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ucs_flutter_trabalho_2_receitas/screens/widgets/recipe_details/ingredients_detail_widget.dart';
import '../models/recipe_model.dart';
import '../ui/app_colors.dart';
import 'widgets/recipe_details/prepare_instruction_widget.dart';
import 'widgets/star_rating_widget.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    var logger = Logger();
    logger.d(recipe.ingredients);
    logger.d(recipe.steps);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.edit),
            label: Text("Editar"),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.buttonMainColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.title,
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StarRatingWidget(rating: recipe.score),
                    Text(
                      "${recipe.date.day} / ${recipe.date.month} / ${recipe.date.year}",
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                color: AppColors.lightBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8.0,
                      children: [
                        Icon(Icons.timer_sharp),
                        Column(
                          children: [
                            Text('PREP:'),
                            Text(recipe.preparationTime),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8.0,
                      children: [
                        Icon(Icons.kitchen_outlined),
                        Column(
                          children: [
                            Text('INGR:'),
                            Text(recipe.ingredients.length.toString()),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Descrição",
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              ),
              Text(recipe.description, style: TextStyle(fontSize: 16.0)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Ingredientes",
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              ),
              IngredientsDetailWidget(ingredients: recipe.ingredients),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Modo de Preparo",
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              ),

              PrepareInstructionWidget(steps: recipe.steps),
            ],
          ),
        ),
      ),
    );
  }
}
