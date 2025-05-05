import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/routes.dart';
import 'screens/edit_recipe_screen.dart';
import 'screens/home_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'providers/recipes_provider.dart';
import 'ui/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecipesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipesProvider(),
      child: MaterialApp(
        title: 'App Receitas',
        initialRoute: Routes.home,
        navigatorKey: Routes.navigation,
        theme: AppTheme.appTheme,
        routes: {
          Routes.home: (context) => const HomeScreen(),
          Routes.recipe: (context) => const RecipeDetailScreen(),
          Routes.editRecipe: (context) => EditRecipeScreen(),
        },
      ),
    );
  }
}
