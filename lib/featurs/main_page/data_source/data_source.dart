import 'package:appwrite/models.dart';

import '../featurs/check_out/models/address_model.dart';
import '../featurs/home/models/product_model.dart';
import '../featurs/products_view/models/add_to_cart_product_model.dart';
import 'local_data_source.dart';
import 'remot_data_source.dart';

class DataSource {
  LocalDataSource localDataSource;
  RemoteDataSource remoteDataSource;
  DataSource({required this.localDataSource, required this.remoteDataSource});
  Future<void> insertDataInOrderTableFromCloud(List<Document> orders) async {
    localDataSource.insertDataInOrderTableFromCloud(orders);
  }

  Future<void> getOrdersFromCloud() async {
    return remoteDataSource.getOrdersFromCloud();
  }

  Future<List<Map<String, dynamic>>> getLocationByName(
      String addressName) async {
    return localDataSource.getLocationByName(addressName);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    return localDataSource.getOrders();
  }

  Future<List<Map<String, dynamic>>> getProductsByIds(String ordersIds) async {
    return localDataSource.getProductsByIds(ordersIds);
  }

  Future<void> addOrder(
      ordersIds,
      totalPrice,
      orderDate,
      deliveryAddress,
      shoppingMethod,
      orderId,
      trakingNumber,
      String longitude,
      String latitude,
      String colors,
      String sizes,
      String amounts) async {
    localDataSource.addOrder(
        ordersIds,
        totalPrice,
        orderDate,
        deliveryAddress,
        shoppingMethod,
        orderId,
        trakingNumber,
        latitude,
        longitude,
        colors,
        sizes,
        amounts);
  }

  Future<void> clearAddToCartTable() async {
    return localDataSource.cleareAddToCartTable();
  }

  Future<void> addOrdersToCloudDataBase(
      List<Map<String, dynamic>> orderProducts,
      double totalPrice,
      String deliveryAddress,
      String shoppingMethod,
      String latitude,
      String longitude) async {
    return remoteDataSource.addOrderToCloudDataBase(orderProducts, totalPrice,
        deliveryAddress, shoppingMethod, latitude, longitude);
  }

  Future<void> getProductsFormCloudDataBase() async {
    await localDataSource
        .insertDataIntoLocalDataBase(await remoteDataSource.getProducts());
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    return localDataSource.getLocations();
  }

  Future<void> addNewLocation(AddressModel address) async {
    return localDataSource.addNewLocation(address);
  }

  Future<List<Map<String, dynamic>>> getAddToCartProducts() async {
    return localDataSource.getAddToCartProduct();
  }

  Future<void> removeItemFromAddToCartProducts(int id) async {
    localDataSource.removeItemFromAddToCartProducts(id);
  }

  Future<void> addToCart(AddToCartProductModel addToCartTableModel) async {
    localDataSource.addToCart(addToCartTableModel);
  }

  Future<void> updateQuantity(int id, int quantity) async {
    localDataSource.updateQuantity(id, quantity);
  }

  Future<Map<String, dynamic>> getAddToCartProductById(int id) async {
    return localDataSource.getAddToCartProductById(id);
  }

  Future<List<Map<String, Object?>>> searchInCategory({
    required double minPrice,
    required double maxPrice,
    String? searchWord,
    required List<bool> discountFilter,
    required String selectedCategory,
    required List<bool> ratingFilter,
    required List<bool> colorFilter,
  }) async {
    return localDataSource.searchInCategory(
      discountfilter: discountFilter,
      minPrice: minPrice,
      maxPrice: maxPrice,
      searchWord: searchWord,
      selectedCategory: selectedCategory,
      ratingFilter: ratingFilter,
      colorFilter: colorFilter,
    );
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    return localDataSource.getProductById(id);
  }

  Future<List<Map<String, dynamic>>> getDiscountsProducts() {
    return localDataSource.getDiscountProduct();
  }

  Future<List<Map<String, dynamic>>> getSimilarProducts(
      ProductModel product) async {
    return localDataSource.getSimilarProducts(product);
  }

  Future<List<Map<String, dynamic>>> getReviews(int id) async {
    return localDataSource.getReviews(id);
  }

  Future<List<Map<String, Object?>>> searchInDiscountProducts({
    required double minPrice,
    required double maxPrice,
    String? searchWord,
    required String selectedCategory,
    required List<bool> discountFilter,
    required List<bool> ratingFilter,
    required List<bool> colorFilter,
  }) {
    return localDataSource.searchInDiscountProducts(
        minPrice: minPrice,
        maxPrice: maxPrice,
        searchWord: searchWord,
        discountFilter: discountFilter,
        ratingFilter: ratingFilter,
        colorFilter: colorFilter,
        selectedCategory: selectedCategory);
  }

  Future<List<Map<String, Object?>>> searchProducts({
    required String search,
    required double minPrice,
    required double maxPrice,
    required List<bool> discountFilter,
    required String selectedCategory,
    required List<bool> ratingFilter,
    required List<bool> colorFilter,
  }) async {
    return localDataSource.searchProducts(
      discountfilter: discountFilter,
      search: search,
      minPrice: minPrice,
      maxPrice: maxPrice,
      selectedCategory: selectedCategory,
      ratingFilter: ratingFilter,
      colorFilter: colorFilter,
    );
  }

  Future<void> setSearchHistory(String searchWord) {
    return localDataSource.setSearchHistory(searchWord);
  }

  Future<List<Map<String, dynamic>>> getSearchHistory() async {
    return localDataSource.getSearchHistory();
  }

  Future<void> deleteWordFormSearchHistory(String word) async {
    return localDataSource.deleteWordFormSearchHistory(word);
  }

  Future<void> setFavorateProduct(int id, bool value) async {
    localDataSource.setFavorateProduct(id, value);
  }
}
