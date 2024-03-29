import 'dart:developer';

import 'package:shop_app/core/constant.dart';
import 'package:sqflite/sqflite.dart';

class MyDataBase {
  Future<void> createRecommendedProductTable() async {
    String path = await getDatabasesPath();
    String dataBasePath = '$path/recommended.db';
    try {
      await openDatabase(
        dataBasePath,
        version: 2,
        onCreate: (db, version) async {
          db.execute(
              'CREATE TABLE recommended (id INTEGER PRIMARY KEY , productId INT NOT NULL, freq INT NOT NULL)');
        },
      );
      log('recommended table created');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> createBorderTable() async {
    String path = await getDatabasesPath();
    String dataBasePath = '$path/elegance.db';
    try {
      await openDatabase(
        dataBasePath,
        version: 1,
        onCreate: (db, version) async {
          db.execute(
              'CREATE TABLE borders (id INTEGER PRIMARY KEY , borderName TEXT NOT NULL)');
        },
      );
      log('borders table created');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> createBorderProductsTable() async {
    String path = await getDatabasesPath();
    String dataBasePath = '$path/borderProducts.db';
    try {
      await openDatabase(
        dataBasePath,
        version: 1,
        onCreate: (db, version) async {
          db.execute(
              'CREATE TABLE borderProducts (id INTEGER PRIMARY KEY, productId INT NOT NULL,borderId INT NOT NULL)');
        },
      );
      log('borders products table created');
    } catch (e) {
      log(e.toString());
    }
  }

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
              'CREATE TABLE AddToCartTable (id INTEGER PRIMARY KEY , order_id INT NOT NULL, imgUrl TEXT NOT NULL, quantity INTEGER NOT NULL, productId INT NOT NULL, productName TEXT NOT NULL ,price DOUBLE NOT NULL, companyMaker TEXT NOT NULL , color TEXT NOT NULL , size  TEXT NOT NULL)');
        },
      );
      log('Add to cart table created');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> createLoactionsTable() async {
    String path = await getDatabasesPath();
    String dataBasePath = '$path/locations.db';
    try {
      await openDatabase(
        dataBasePath,
        version: 1,
        onCreate: (db, version) async {
          db.execute(
              'CREATE TABLE locations (id TEXT PRIMARY KEY , firstName TEXT NOT NULL,lastName TEXT NOT NULL, phoneNumber TEXT NOT NULL , emailAddress TEXT NOT NULL, addressName TEXT NOT NULL , longitude_code TEXT NOT NULL , latitude_code  TEXT NOT NULL,city TEXT NOT NULL ,country TEXT NOT NULL ,address TEXT NOT NULL)');
        },
      );
      log('locations table created');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> createOrdersTable() async {
    String path = await getDatabasesPath();
    String dataBasePath = '$path/orders.db';
    await openDatabase(
      dataBasePath,
      version: 1,
      onCreate: (db, version) async {
        db.execute('''CREATE TABLE orders (
            id INTEGER PRIMARY KEY , 
            email TEXT NOT NULL, 
            ordersIds TEXT NOT NULL ,
            totalPrice DOUBLE NOT NULL ,
            createdAt TEXT NOT NULL,
            deliveryAddress TEXT NOT NULL,
            shoppingMethod TEXT NOT NULL,
            orderId TEXT NOT NULL,
            latitude TEXT NOT NULL,
            longitude TEXT NOT NULL,
            trackingNumber TEXT NOT NULL,
            colors TEXT NOT NULL,
            sizes TEXT NOT NULL,
            quntities INT NOT NULL
            )''');
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
            'CREATE TABLE reviews (id INTEGER PRIMARY KEY , description TEXT NOT NULL , stars INTEGER NOT NULL , date TEXT NOT NULL , userName TEXT NOT NULL , email TEXT NOT NULL, userImage TEXT , productId INTEGER NOT NULL )');
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

  Future<void> createProductTable() async {
    String path = await getDatabasesPath();
    String dataBasePath = '$path/prducts.db';
    try {
      await openDatabase(
        dataBasePath,
        version: 1,
        onCreate: (db, version) async {
          db.execute(
              '''CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT NOT NULL , price DECIMAL NOT NULL , 
              makerCompany TEXT NOT NULL , sizes TEXT NOT NULL , colors TEXT NOT NULL , discription TEXT NOT NULL , 
              imgUrl TEXT NOT NULL ,discount DECIMAL NOT NULL , date TEXT NOT NULL , category TEXT , rating INTEGER ,
              isFavorate BOOLEAN,isNew BOOLEAN,isDiscountUpdated BOOLEAN)
              ''');
        },
      );
      log('products table created');
    } catch (e) {
      log(e.toString());
    }
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
}
