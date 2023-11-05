import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/core/constant.dart';
import 'package:sqflite/sqflite.dart';

class MyDataBase {
  Future<void> createAddToCartTable() async {
    String path = await getDatabasesPath();
    String dataBasePath = '$path/AddToCartTable.db';
    log(dataBasePath);
    try {
      await openDatabase(
        dataBasePath,
        version: 1,
        onCreate: (db, version) async {
          db.execute(
              'CREATE TABLE AddToCartTable (id INTEGER PRIMARY KEY , imgUrl TEXT NOT NULL, quantity INTEGER NOT NULL, productName TEXT NOT NULL ,price DOUBLE NOT NULL, companyMaker TEXT NOT NULL , color TEXT NOT NULL , size  TEXT NOT NULL)');
        },
      );
      log('Add to cart table created');
    } catch (e) {
      log(e.toString());
    }
  }

  //! working on it
  Future<void> createOrdersTable() async {
    String path = await getDatabasesPath();
    String dataBasePath = '$path/orders.db';
    await openDatabase(
      dataBasePath,
      version: 1,
      onCreate: (db, version) async {
        db.execute(
            'CREATE TABLE orders (id INTEGER PRIMARY KEY , text orderDate TEXT NOT NULL , dueDate TEXT NOT NULL , quantity INTEGER NOT NULL , subtotal DOUBLE NOT NULL , trackingNumber TEXT NOT NULL , isPandeing BOOLEAN NOT NULL)');
      },
    );
    log('orders table created');
  }

  Future<void> createReviewTable() async {
    String path = await getDatabasesPath();
    String dataBasePath = '$path/reviews.db';
    await openDatabase(
      dataBasePath,
      version: 1,
      onCreate: (db, version) async {
        db.execute(
            'CREATE TABLE reviews (id INTEGER PRIMARY KEY , description TEXT NOT NULL , stars INTEGER NOT NULL , date TEXT NOT NULL , userName TEXT NOT NULL , userImage TEXT , productId INTEGER NOT NULL )');
      },
    );
    log('created');
  }

  Future<void> insertReviewTable() async {
    Database db = await openDatabase(Constant.reviewsDataBasePath);
    for (var element in Constant.reviews) {
      db.insert('reviews', element);
    }
    log('done');
  }

  Future<void> createTable() async {
    String path = await getDatabasesPath();
    String dataBasePath = '$path/prducts.db';
    await openDatabase(
      dataBasePath,
      version: 1,
      onCreate: (db, version) async {
        db.execute(
            'CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT NOT NULL , price DECIMAL NOT NULL , makerCompany TEXT NOT NULL , sizes TEXT NOT NULL , colors TEXT NOT NULL , discription TEXT NOT NULL , imgUrl TEXT NOT NULL ,discount INTEGER NOT NULL , date TEXT NOT NULL , category TEXT , rating INTEGER , isFavorate BOOLEAN)');
        SharedPreferences sh = await SharedPreferences.getInstance();
        sh.setString('DataBasePath', dataBasePath);
      },
    );
    log('created');
  }

  Future<void> createSearchHistoryTable() async {
    String path = await getDatabasesPath();
    String dataBasePath = '$path/searchHistory.db';
    try {
      await openDatabase(
        dataBasePath,
        version: 1,
        onCreate: (db, version) async {
          db.execute(
              'CREATE TABLE searchHistory (id INTEGER PRIMARY KEY , word TEXT NOT NULL , count INTEGER NOT NULL )');
        },
      );
      log('created');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> insertData() async {
    Database db = await openDatabase(Constant.productDataBasePath);
    for (var element in Constant.data) {
      db.insert('products', element);
    }
    log('done');
  }
}
