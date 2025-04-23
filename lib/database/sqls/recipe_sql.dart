class RecipeSql {
  static String criateRecipeTable() {
    return "CREATE TABLE recipe (id TEXT PRIMARY KEY, title TEXT NOT NULL, description TEXT, score REAL, date INTEGER NOT NULL, preparationTime TEXT)";
  }
}
