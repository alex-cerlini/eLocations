import 'dart:async';
import 'dart:io';
import 'package:elocations/models/elocation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String elocationTable = 'elocation';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String coladdress = 'address';
  String colCity = 'city';
  String colState = 'state';
  String colCategory = 'category';
  String colImage = 'image';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'elocations.db';

    var elocationsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return elocationsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $elocationTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $coladdress TEXT, $colCity TEXT, $colState TEXT, $colCategory TEXT, $colImage TEXT)');
  }

  Future<int> insertElocation(
    Elocation elocation,
  ) async {
    Database db = await this.database;
    var resultado = await db.insert(elocationTable, elocation.toMap());
    return resultado;
  }

  Future<Elocation> getElocation(int id) async {
    Database db = await this.database;
    List<Map> maps = await db.query(elocationTable,
        columns: [
          colId,
          colTitle,
          colDescription,
          coladdress,
          colCity,
          colState,
          colCategory,
          colImage
        ],
        where: "$colId = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Elocation.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Elocation>> getElocations() async {
    Database db = await this.database;

    var resultado = await db.query(elocationTable);

    List<Elocation> lista = resultado.isNotEmpty
        ? resultado.map((c) => Elocation.fromMap(c)).toList()
        : [];

    return lista;
  }

  Future<int> updateElocation(Elocation elocation) async {
    var db = await this.database;

    var resultado = await db.update(
      elocationTable,
      elocation.toMap(),
      where: '$colId = ?',
      whereArgs: [elocation.id],
    );
  }

  Future<int> deleteElocation(int id) async {
    var db = await this.database;

    int resultado = await db.delete(
      elocationTable,
      where: "$colId = ?",
      whereArgs: [id],
    );
    return resultado;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $elocationTable');

    int resultado = Sqflite.firstIntValue(x);
    return resultado;
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
