import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/injection.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/constant.dart';
import '../featurs/check_out/models/address_model.dart';
import '../featurs/products_view/models/add_to_cart_product_model.dart';
import '../featurs/products_view/models/review_model.dart';
import 'data_source.dart';

class InsertDataLocalDataSource {
  Future<void> setRecommendedProducts() async {
    var data = await sl.get<DataSource>().getRecommendedproductsFromCloud();
    List<int> productsIds = [];
    for (var element in data) {
      var temp = element.data['orders_ids'];
      for (var element in temp) {
        productsIds.add(element);
      }
    }
    productsIds.sort();
    var finalProductIds = [];
    finalProductIds.add(productsIds[0]);
    List<int> freq = [0];
    int index = 0;
    for (var i = 0; i < productsIds.length; i++) {
      freq[index]++;
      if (i < productsIds.length - 1) {
        if (productsIds[i + 1] != productsIds[i]) {
          freq.add(0);
          finalProductIds.add(productsIds[i + 1]);
          index++;
        }
      }
    }
    Database db = await openDatabase(Constant.recommendedProductsDataBasePath);
    for (var i = 0; i < finalProductIds.length; i++) {
      db.rawInsert(
          'INSERT INTO recommended(productId,freq) VALUES (${finalProductIds[i]},${freq[i]})');
    }
    log('done inserting recommended products');
  }

  Future<void> insertPersonalDataInDataBase() async {
    Map<String, dynamic> personalData =
        await sl.get<DataSource>().getPersonalDataFromCloud();
    if (personalData['cartProducts'] != null &&
        personalData['cartProducts'] != '') {
      var temp = personalData['cartProducts'].toString().split('|');
      for (var element in temp) {
        var data = jsonDecode(element);
        await sl
            .get<DataSource>()
            .addToCart(AddToCartProductModel.fromMap(data));
      }
    }
    if (personalData['borders'] != null && personalData['borders'] != '') {
      var temp = personalData['borders'].toString().split('|');
      for (var element in temp) {
        var data = jsonDecode(element);
        await sl.get<DataSource>().addBorder(data['borderName']);
      }
    }
    if (personalData['borderProducts'] != null &&
        personalData['borderProducts'] != '') {
      var temp = personalData['borderProducts'].toString().split('|');
      for (var element in temp) {
        var data = jsonDecode(element);
        await sl
            .get<DataSource>()
            .addProductToBorder(data['productId'], data['borderId']);
      }
    }
    await sl.get<DataSource>().getBorders();
    await sl.get<DataSource>().getAllFavoritProducts();
    await sl.get<DataSource>().getAddToCartProducts();
  }

  Future<void> addDataToReviewTableFromCloue(List<Document> reviews) async {
    try {
      Database db = await openDatabase(Constant.reviewsDataBasePath);

      for (var element in reviews) {
        Map<String, dynamic> data = {
          'description': element.data['description'],
          'stars': element.data['stars'],
          'date': element.data['date'],
          'userName': element.data['userName'],
          'userImage': element.data['userImage'],
          'productId': element.data['productId'],
          'email': element.data['email'],
        };
        try {
          await db.insert('reviews', data);
        } catch (e) {
          log(e.toString());
        }
      }
      log('done inserting data in local dataBase');
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }

  Future<void> addReviewToProduct(ReviewModel review) async {
    Database db = await openDatabase(Constant.reviewsDataBasePath);
    if (review.userImage != null) {
      db.rawInsert(
          'INSERT INTO reviews(description, stars, date, userName, userImage, productId,email) VALUES("${review.description}",${review.stars},"${review.date}","${review.userName}","${review.userImage}",${review.productId},"${review.email}")');
    } else {
      db.rawInsert(
          'INSERT INTO reviews(description, stars, date, userName, productId,email) VALUES("${review.description}",${review.stars},"${review.date}","${review.userName}",${review.productId},"${review.email}")');
    }
  }

  Future<void> addBorder(String borderName) async {
    Database db = await openDatabase(Constant.borderDataBasePath);
    db.rawInsert('INSERT INTO borders(borderName) VALUES("$borderName")');
  }

  Future<void> addProductToBorder(int productId, int borderId) async {
    Database db = await openDatabase(Constant.broderProductsDataBasePath);
    db.insert('borderProducts', {'productId': productId, 'borderId': borderId});
    // await db.rawInsert(
    //     'INSERT INTO borderProducts(productId,borderId) VALUES($productId,$borderId)');
  }

  Future<void> addOrder(
    List<int> ordersIds,
    double totalPrice,
    String orderDate,
    String deliveryAddress,
    String shoppingMethod,
    int orderId,
    String trakingNumber,
    String latitude,
    String longitude,
    String colors,
    String sizes,
    String amounts,
  ) async {
    String ids = '';
    for (var i = 0; i < ordersIds.length; i++) {
      if (i == ordersIds.length - 1) {
        ids += ordersIds[i].toString();
      } else {
        ids += '${ordersIds[i]}|';
      }
    }

    Database db = await openDatabase(Constant.ordersDataBasePath);
    try {
      db.rawDelete('DELETE FROM orders');
      await db.rawInsert(
          '''INSERT INTO orders(email, ordersIds, createdAt, totalPrice, deliveryAddress, shoppingMethod, orderId, trackingNumber, latitude, longitude,colors,sizes,quntities) VALUES
        ("${Constant.currentUser!.email}", "$ids", "$orderDate",$totalPrice,"$deliveryAddress","$shoppingMethod",$orderId,"$trakingNumber","$latitude","$longitude","$colors","$sizes","$amounts")''');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> setSearchHistory(String searchWord) async {
    Database db = await openDatabase(Constant.searchHistoryDataBasePath);
    try {
      List<Map<String, dynamic>> result = await db
          .rawQuery("SELECT * FROM searchHistory WHERE word == '$searchWord' ");
      if (result.isEmpty) {
        db.insert('searchHistory', {'word': searchWord, 'count': 1});
      } else {
        int oldCount = result[0]['count'];
        db.rawUpdate(
            "UPDATE searchHistory  SET count=${oldCount + 1} WHERE word == '$searchWord'");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> setFavorateProduct(int id, bool value) async {
    Database db = await openDatabase(Constant.productDataBasePath);
    try {
      if (value) {
        await db.rawUpdate(
            "UPDATE products  SET isFavorate = 'true' WHERE id == $id ");
      } else {
        await db.rawUpdate(
            "UPDATE products  SET isFavorate = 'false' WHERE id == $id ");
      }
    } catch (e) {
      log('created');
    }
  }

  Future<void> insertProductsIntoLocalDataBase(
      List<Document> products, bool isNew) async {
    try {
      Database db = await openDatabase(Constant.productDataBasePath);
      for (var element in products) {
        Map<String, dynamic> data = {
          'isNew': isNew,
          'name': element.data['name'],
          'price': element.data['price'],
          'makerCompany': element.data['makerCompany'],
          'sizes': element.data['sizes'],
          'colors': element.data['colors'],
          'discription': element.data['discription'],
          'imgUrl': element.data['imgUrl'],
          'discount': element.data['discount'],
          'date': element.data['date'],
          'rating': element.data['rating'],
          'category': element.data['category'],
          'isFavorate': 0
        };
        try {
          await db.insert('products', data);
        } catch (e) {
          log(e.toString());
        }
      }
      log('done inserting data in local dataBase');
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }

  Future<void> addNewLocation(AddressModel address) async {
    Database db = await openDatabase(Constant.locationsDataBasePath);
    db.rawInsert(
      "INSERT INTO locations (firstName, lastName, phoneNumber, emailAddress,addressName, longitude_code, latitude_code,city,country,address) VALUES ('${address.fullName}', '${address.lastName}','${address.phoneNumber}','${address.emailAddress}','${address.addressName}','${address.longitude}','${address.latitude}','${address.city}','${address.country}','${address.address}')",
    );
  }

  Future<void> addToCart(AddToCartProductModel addToCartTableModel) async {
    Database db = await openDatabase(Constant.addToCartTable);
    try {
      List<Map<String, dynamic>> data = await db.rawQuery(
          'SELECT * FROM AddToCartTable WHERE  productName=="${addToCartTableModel.productName}" AND order_id==${addToCartTableModel.orderId} AND price == ${addToCartTableModel.price} AND companyMaker == "${addToCartTableModel.companyMaker}" AND color == "${addToCartTableModel.color}" AND  size == "${addToCartTableModel.size}"');
      if (data.isNotEmpty) {
        int q = data[0]['quantity'];
        q += addToCartTableModel.quantity;
        db.rawUpdate(
            'UPDATE AddToCartTable SET quantity=$q WHERE order_id==${addToCartTableModel.orderId}');
      } else {
        db.rawInsert(
          "INSERT INTO AddToCartTable (imgUrl, quantity, productName, price,companyMaker, color, size, order_id) VALUES ('${addToCartTableModel.imgUrl}', ${addToCartTableModel.quantity},'${addToCartTableModel.productName}',${addToCartTableModel.price},'${addToCartTableModel.companyMaker}','${addToCartTableModel.color}','${addToCartTableModel.size}',${addToCartTableModel.orderId})",
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> insertDataInOrderTableFromCloud(List<Document> orders) async {
    for (var element in orders) {
      Map<String, dynamic> order = element.data;
      List<String> ordersIds = order['orders_ids']
          .toString()
          .substring(1, order['orders_ids'].toString().length - 1)
          .split(',');
      List<int> finalOrdersIds = [];
      String colors = '';
      String sizes = '';
      String amounts = '';
      for (var element in order['colors']) {
        colors += element + '|';
      }
      colors.replaceRange(colors.length, colors.length, '');

      for (var element in order['sizes']) {
        sizes += element + '|';
      }
      sizes.replaceRange(sizes.length, sizes.length, '');
      for (var element in order['amounts']) {
        amounts += '$element|';
      }
      amounts.replaceRange(amounts.length, amounts.length, '');
      for (var element in ordersIds) {
        finalOrdersIds.add(int.parse(element));
      }
      await addOrder(
          finalOrdersIds,
          order['total_price'] * 1.0,
          order['created_at'],
          order['delivery_address'],
          order['shopping_method'],
          order['id'],
          order['\$id'],
          order['latitude'],
          order['longitude'],
          colors,
          sizes,
          amounts);
      log('done');
    }
  }
}
