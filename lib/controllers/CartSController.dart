import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../models/CartModel.dart';

class CartSController {
  static Database? _database;
  static final CartSController instance = CartSController._();

  CartSController._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path_ = path.join(databasesPath, 'cart.db');

    return await openDatabase(path_, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE carts(
          cartId INTEGER PRIMARY KEY,
          product_id INTEGER,
          quantity INTEGER,
          name TEXT,
          price INTEGER,
          description TEXT,
          categoryId INTEGER,
          imagesList TEXT
        )
      ''');
    });
  }

  Future<void> addToCart(CartModel cartItem, BuildContext context) async {
    final db = await instance.database;
    // Check if the product is already in the cart
    final List<Map<String, dynamic>> maps = await db.query(
      'carts',
      where: 'product_id = ?',
      whereArgs: [cartItem.productId],
    );

    if (maps.isNotEmpty) {
      // Show Snackbar if the item is already in the cart
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This product is already in your cart.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Add the item to the cart
      await db.insert('carts', cartItem.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to Cart'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> removeFromCart(int cartId) async {
    final db = await instance.database;
    await db.delete('carts', where: 'cartId = ?', whereArgs: [cartId]);
  }

  Future<void> updateItemQuantity(int cartId, int newQuantity) async {
    final db = await instance.database;
    await db.update('carts', {'quantity': newQuantity},
        where: 'cartId = ?', whereArgs: [cartId]);
  }

  Future<List<CartModel>> loadCart() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('carts');
    print(maps);
    return List.generate(maps.length, (i) {
      return CartModel.fromJson(maps[i]);
    });
  }

  Future<void> clearCart() async {
    final db = await instance.database;
    await db.delete('carts');
  }

  Future<double> calculateTotal() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('carts');
    double total = 0.0;
    maps.forEach((map) {
      total += map['price'] * map['quantity'];
    });
    return total;
  }
}
