import 'package:flutter/material.dart';
import 'package:ucs_flutter_trabalho_2_receitas/ui/app_colors.dart';

import '../models/recipe_model.dart';
import 'widgets/star_rating_widget.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(recipe.title),
            Text(recipe.date.toString()),
            Row(
              children: [
                Column(
                  children: [
                    StarRatingWidget(rating: 3.5),
                    Text(recipe.score.toString()),
                  ],
                ),
                Column(children: [Text(recipe.preparationTime)]),
              ],
            ),
            Text(recipe.description),
          ],
        ),
      ),
    );
  }
}
