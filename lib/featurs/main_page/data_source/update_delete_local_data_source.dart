import 'dart:developer';

import 'package:sqflite/sqflite.dart';

import '../../../core/constant.dart';
import '../featurs/check_out/models/address_model.dart';

class UpdateDeleteLocalDataSource {
  Future<void> deleteAddress(String addressName) async {
    Database db = await openDatabase(Constant.locationsDataBasePath);
    db.rawDelete('DELETE FROM locations WHERE addressName="$addressName"');
  }

  Future<void> updateAddress(
      AddressModel address, String oldAddressName) async {
    Database db = await openDatabase(Constant.locationsDataBasePath);
    var i = await db.rawUpdate(
        "UPDATE locations SET firstName='${address.fullName}',lastName='${address.fullName}',phoneNumber='${address.phoneNumber}',emailAddress='${address.emailAddress}',addressName='${address.addressName}',longitude_code='${address.longitude}',latitude_code='${address.latitude}',city='${address.city}',country='${address.country}',address='${address.address}' WHERE addressName== '$oldAddressName'");
    log(i.toString());
  }

  Future<void> deleteWordFormSearchHistory(String word) async {
    Database db = await openDatabase(Constant.searchHistoryDataBasePath);
    db.rawDelete("DELETE FROM searchHistory WHERE word == '$word'");
  }

  Future<void> removeItemFromAddToCartProducts(int id) async {
    Database db = await openDatabase(Constant.addToCartTable);
    db.rawDelete('DELETE FROM AddToCartTable WHERE id == $id');
  }

  Future<void> updateQuantity(int id, int quantity) async {
    Database db = await openDatabase(Constant.addToCartTable);
    db.rawUpdate('UPDATE AddToCartTable SET quantity=$quantity WHERE id==$id');
  }

  Future<void> clearAddToCartTable() async {
    Database db = await openDatabase(Constant.addToCartTable);
    db.rawDelete('delete from AddToCartTable');
    log('add to cart table cleared');
  }

  Future<void> clearProductsTable() async {
    Database db = await openDatabase(Constant.addToCartTable);
    db.rawDelete('delete from products');
    log('add to cart table cleared');
  }

  Future<void> clearBordersTable() async {
    Database db = await openDatabase(Constant.borderDataBasePath);
    db.rawDelete("delete from borders");
    log('border table cleared');
  }

  Future<void> clearBorderPoducts() async {
    Database db = await openDatabase(Constant.broderProductsDataBasePath);
    db.rawDelete('delete from borderProducts');
    log(' borderProducts table cleared');
  }

  Future<void> deleteProductFromBorder(int productId) async {
    Database db = await openDatabase(Constant.broderProductsDataBasePath);
    await db
        .rawDelete('DELETE FROM borderProducts WHERE productId = $productId');
  }
}
