import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:Inkspire/models/CardModel.dart';

class Cardcontroller {
  static final Cardcontroller _instance = Cardcontroller._internal();
  factory Cardcontroller() => _instance;
  Cardcontroller._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'payment.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE card_details(id INTEGER PRIMARY KEY AUTOINCREMENT, card_number TEXT)',
        );
      },
    );
  }

  Future<void> insertCard(CardModel card) async {
    final db = await database;
    await db.insert(
      'card_details',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<CardModel?> getLastCard() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'card_details',
      orderBy: 'id DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return CardModel.fromMap(maps.first);
    }
    return null;
  }
}
