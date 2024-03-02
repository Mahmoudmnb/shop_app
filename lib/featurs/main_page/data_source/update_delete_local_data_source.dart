import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/featurs/main_page/featurs/home/models/product_model.dart';
import 'package:shop_app/injection.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/constant.dart';
import '../featurs/check_out/models/address_model.dart';

class UpdateDeleteLocalDataSource {
  Future<void> updateDataBase() async {
    var data = sl.get<SharedPreferences>().getString('lastUpdate');
    if (data != null) {
      var p = await sl.get<DataSource>().getUpdatedProducts(data);
      List<Document> newProducts = p['newProducts'] ?? [];
      List<Document> updatedProducts = p['updatedProducts'] ?? [];
      if (newProducts.isNotEmpty) {
        await sl.get<DataSource>().insertProductsIntoLocalDataBase(newProducts);
      }
      if (updatedProducts.isNotEmpty) {
        await updateProducts(updatedProducts);
      }
      log(p.toString());
      await sl.get<SharedPreferences>().setString(
          'lastUpdate', DateTime.now().millisecondsSinceEpoch.toString());
    }
  }

  Future<void> updateProducts(List<Document> products) async {
    Database db = await openDatabase(Constant.productDataBasePath);
    for (var element in products) {
      ProductModel product = ProductModel.fromMap(element.data);
      db.rawUpdate(
          """ UPDATE products SET name ='${product.name}', price=${product.price}, makerCompany= '${product.makerCompany}',
      sizes= '${product.sizes}', colors= '${product.colors}', discription='${product.discription}', imgUrl='${product.imgUrl}',
       discount=${product.disCount},date='${product.date}', category='${product.category}', rating=${element.data['rating']}
      WHERE name='${product.name}'""");
    }
    log('done updating products');
  }

  Future<void> updatePrices(
      List<String> productsNames, List<double> oldPrices) async {
    List<Document> data =
        await sl.get<DataSource>().getPricesFromCloud(productsNames);
    for (var i = 0; i < data.length; i++) {
      if (data[i].data['price'] != oldPrices[i]) {
        updatePrice(data[i].data['price'] * 1.0, data[i].data['name']);
      }
    }
  }

  Future<void> updatePrice(double price, String productName) async {
    Database db = await openDatabase(Constant.productDataBasePath);
    db.rawUpdate("UPDATE products set price=$price WHERE name='$productName'");
  }

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
