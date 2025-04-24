import 'package:flutter/material.dart';
import 'routes/routes.dart';
import 'screens/edit_recipe_screen.dart';
import 'screens/home_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'ui/app_theme.dart';
import 'ui/recipe_screen_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Receitas',
      initialRoute: Routes.initial,
      navigatorKey: Routes.navigation,
      theme: AppTheme.appTheme,
      routes: {
        Routes.initial: (context) => const SplashScreen(),
        Routes.home: (context) => const HomeScreen(),
        Routes.recipe: (context) => const RecipeDetailScreen(),
        Routes.editRecipe: (context) => EditRecipeScreen(),
      },
    );
  }
}
