// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:isu_corp_test/models/ticket.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    // Getting the app dir
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "tickets.db");

    // Open the database(or create it if not exist)
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create the database structure
    await db.execute(
        "CREATE TABLE tickets (id INTEGER PRIMARY KEY AUTOINCREMENT, clientName TEXT, address TEXT, phoneNumber TEXT, date TEXT)");
  }

  // Insert coming data into the database
  Future<void> insertData(Map<String, dynamic> data) async {
    final db = await database;
    await db!
        .insert('tickets', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Getting the entire table tickets from database
  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    return await db!.query('tickets');
  }

  // Updating the ticket with the incoming id with the newData
  Future<void> updateData(int id, Map<String, dynamic> newData) async {
    final db = await database;
    await db!.update(
      'tickets',
      newData,
      where: 'id = $id',
    );
  }

  // Delete the ticket with the id provide
  Future<void> deleteData(int id) async {
    final db = await database;
    await db!.delete(
      'tickets',
      where: 'id = $id',
    );
  }

  // Getting the las record in the database
  Future<Ticket> getLastInsertion() async {
    final db = await database;
    // Executing the SQL query to get the last inserted record
    final result = await db!.rawQuery('SELECT * FROM tickets ORDER BY id DESC');

    // Returning the first result if any
    final Map<String, dynamic>? resultMap =
        result.isNotEmpty ? result.first as Map<String, dynamic> : null;
    return Ticket.fromJson(resultMap as Map<String, dynamic>);
  }
}
