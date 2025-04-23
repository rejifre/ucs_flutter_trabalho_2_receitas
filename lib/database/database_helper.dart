import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'sqls/ingredient_sql.dart';
import 'sqls/instruction_sql.dart';
import 'sqls/recipe_sql.dart';

class DatabaseHelper {
  static final String _databaseName = "meubanco.db";
  static final int _databaseVersion = 1;
  static late Database _database;

  init() async {
    String pathDB = join(await getDatabasesPath(), _databaseName);
    _database = await openDatabase(
      pathDB,
      version: _databaseVersion,
      onCreate: createDB,
      onUpgrade: updateDB,
    );
  }

  Future updateDB(Database db, int oldVersion, int newVersion) async {
    if (newVersion == 2) {}
  }

  Future createDB(Database db, int versao) async {
    db.execute(IngredientSql.createIngredientTable());
    db.execute(InstructionSql.createInstructionTable());
    db.execute(RecipeSql.criateRecipeTable());
  }

  // Método de transação para manipulação de dados
  Future<void> performTransaction(
    Future<void> Function(Transaction txn) action,
  ) async {
    await init();
    await _database.transaction((txn) async {
      await action(txn); // Aqui, a ação personalizada é chamada
    });
  }

  /// insert data in db
  /// @param table: the name of the table to be insert
  /// @param data: data map to be added
  Future<int> insert(String table, Map<String, Object?> data) async {
    await init();
    return await _database.insert(table, data);
  }

  /// update data in db
  /// @param table: the name of the table to be updated
  /// @param data: data map to be updated
  Future<int> update(String table, Map<String, Object?> data) async {
    await init();
    return await _database.update(table, data);
  }

  /// delete data to db
  /// @param table: the name of the table to delete from
  /// @param id: product id to be deleted
  Future<int> delete(String table, String id) async {
    await init();
    return await _database.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, Object?>>> getAll(
    String table, {
    String? condition,
    List<Object>? conditionArgs,
    String? orderBy,
  }) async {
    await init();
    return await _database.query(
      table,
      where: condition,
      whereArgs: conditionArgs,
    );
  }
}
