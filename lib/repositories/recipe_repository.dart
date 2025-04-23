import '../models/ingredient_model.dart';
import '../models/instruction_model.dart';
import '../models/recipe_model.dart';
import '/database/database_helper.dart';

class RecipeRepository {
  static final DatabaseHelper _db = DatabaseHelper();

  static const String recipeTable = 'recipe';
  static const String ingredienTable = 'ingredient';
  static const String instructionTable = 'instruction';

  Future<void> insert(Recipe recipe) async {
    await _db.performTransaction((txn) async {
      // Insere a receita principal
      int recipeId = await txn.insert(recipeTable, recipe.toMap());

      // Insere os ingredientes
      for (var ingredient in recipe.ingredients) {
        await txn.insert(ingredienTable, {
          'recipe_id': recipeId,
          'name': ingredient,
        });
      }

      // Insere os passos
      for (int i = 0; i < recipe.steps.length; i++) {
        await txn.insert(instructionTable, {
          'recipe_id': recipeId,
          'description': recipe.steps[i],
          'step_order': i + 1,
        });
      }
    });
  }

  // Método de transação para realizar atualizações
  Future<void> update(Recipe recipe) async {
    await _db.performTransaction((txn) async {
      // 1. Atualizar a receita principal
      await txn.update(
        recipeTable,
        recipe.toMap(),
        where: 'id = ?',
        whereArgs: [recipe.id],
      );

      // 2. Remover ingredientes antigos e adicionar os novos
      await txn.delete(
        ingredienTable,
        where: 'recipe_id = ?',
        whereArgs: [recipe.id],
      );

      for (var ingredient in recipe.ingredients) {
        await txn.insert(ingredienTable, {
          'recipe_id': recipe.id,
          'name': ingredient,
        });
      }

      // 3. Remover passos antigos e adicionar os novos
      await txn.delete(
        instructionTable,
        where: 'recipe_id = ?',
        whereArgs: [recipe.id],
      );

      for (int i = 0; i < recipe.steps.length; i++) {
        await txn.insert(instructionTable, {
          'recipe_id': recipe.id,
          'description': recipe.steps[i],
          'step_order': i + 1,
        });
      }
    });
  }

  // Deletar uma receita
  Future<void> delete(String recipeId) async {
    await _db.delete(recipeTable, recipeId);
  }

  // Listar todas as receitas
  Future<List<Recipe>> getAllRecipes() async {
    List<Map<String, dynamic>> recipesMap = await _db.getAll('recipes');

    List<Recipe> recipes = [];
    for (var recipeMap in recipesMap) {
      Recipe recipe = Recipe.fromMap(recipeMap);

      // Consultando os ingredientes e passos
      List<Map<String, dynamic>> ingredients = await _db.getAll(
        ingredienTable,
        condition: 'recipe_id = ?',
        conditionArgs: [recipe.id],
      );

      for (var ingr in ingredients) {
        Ingredient ingredient = Ingredient.fromMap(ingr);

        recipe.ingredients.add(ingredient);
      }

      List<Map<String, dynamic>> steps = await _db.getAll(
        instructionTable,
        condition: 'recipe_id = ?',
        conditionArgs: [recipe.id],
        orderBy: 'step_order',
      );

      for (var step in steps) {
        Instruction instruction = Instruction.fromMap(step);

        recipe.steps.add(instruction);
      }

      recipes.add(recipe);
    }

    return recipes;
  }
}
