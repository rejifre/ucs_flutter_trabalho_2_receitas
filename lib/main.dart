import 'package:flutter/material.dart';
import 'package:ucs_flutter_trabalho_2_receitas/routes/routes.dart';
import 'package:ucs_flutter_trabalho_2_receitas/screens/home_screen.dart';
import 'package:ucs_flutter_trabalho_2_receitas/screens/recipe_detail_screen.dart';
import 'package:ucs_flutter_trabalho_2_receitas/screens/splash_screen.dart';
import 'package:ucs_flutter_trabalho_2_receitas/ui/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: Routes.initial,
      navigatorKey: Routes.navigation,
      theme: AppTheme.appTheme,
      routes: {
        Routes.initial: (context) => const SplashScreen(),
        Routes.home: (context) => const HomeScreen(),
        Routes.recipe: (context) => const RecipeDetailScreen(),
      },
    );
  }
}
