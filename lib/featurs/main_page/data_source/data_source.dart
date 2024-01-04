import 'package:appwrite/models.dart';

import '../featurs/check_out/models/address_model.dart';
import '../featurs/home/models/product_model.dart';
import '../featurs/products_view/models/add_to_cart_product_model.dart';
import 'data_source_paths.dart';

class DataSource {
  RemoteDataSource remoteDataSource;
  SearchDataSource searchDataSource;
  InsertDataLocalDataSource insertDataLocalDataSource;
  GetDataLocalDataSource getDataLocalDataSource;
  UpdateDeleteLocalDataSource updateDeleteLocalDataSource;
  DataSource({
    required this.updateDeleteLocalDataSource,
    required this.remoteDataSource,
    required this.searchDataSource,
    required this.getDataLocalDataSource,
    required this.insertDataLocalDataSource,
  });
  Future<List<Map<String, dynamic>>> getCountOfProductInBorder(
      int borderId) async {
    return getDataLocalDataSource.getCountOfProductsInBorder(borderId);
  }

  Future<void> deleteFromPorderBroducts(int productId) async {
    return updateDeleteLocalDataSource.deleteProductFromBorder(productId);
  }

  Future<List<Map<String, dynamic>>> getBorderProducts() async {
    return getDataLocalDataSource.getBorderProducts();
  }

  Future<List<Map<String, dynamic>>> getBorderByName(String borderName) async {
    return getDataLocalDataSource.getBorderByName(borderName);
  }

  Future<List<Map<String, dynamic>>> getBorders() async {
    return getDataLocalDataSource.getBorders();
  }

  Future<void> addBorder(String borderName) async {
    return insertDataLocalDataSource.addBorder(borderName);
  }

  Future<void> addProductToBorder(int productId, int borderId) async {
    return insertDataLocalDataSource.addProductToBorder(productId, borderId);
  }

  Future<List<Map<String, dynamic>>> searchInTrendy(
      String selectedCategory,
      String? searchWord,
      double minPrice,
      double maxPrice,
      List<Map<String, dynamic>> trendyProducts,
      List<bool> discountFilter,
      List<bool> ratingFilter,
      List<bool> colorFilter) {
    return searchDataSource.searchInTrendyProducts(
        selectedCategory,
        searchWord,
        minPrice,
        maxPrice,
        trendyProducts,
        discountFilter,
        ratingFilter,
        colorFilter);
  }

  Future<List<Map<String, dynamic>>> getTrendyProducts() async {
    return getDataLocalDataSource.getTrendyProducts();
  }

  Future<void> insertDataInOrderTableFromCloud(List<Document> orders) async {
    insertDataLocalDataSource.insertDataInOrderTableFromCloud(orders);
  }

  Future<void> getOrdersFromCloud() async {
    return remoteDataSource.getOrdersFromCloud();
  }

  Future<List<Map<String, dynamic>>> getLocationByName(
      String addressName) async {
    return getDataLocalDataSource.getLocationByName(addressName);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    return getDataLocalDataSource.getOrders();
  }

  Future<List<Map<String, dynamic>>> getProductsByIds(String ordersIds) async {
    return getDataLocalDataSource.getProductsByIds(ordersIds);
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
    insertDataLocalDataSource.addOrder(
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
    return updateDeleteLocalDataSource.cleareAddToCartTable();
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
    await insertDataLocalDataSource
        .insertDataIntoLocalDataBase(await remoteDataSource.getProducts());
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    return getDataLocalDataSource.getLocations();
  }

  Future<void> addNewLocation(AddressModel address) async {
    return insertDataLocalDataSource.addNewLocation(address);
  }

  Future<List<Map<String, dynamic>>> getAddToCartProducts() async {
    return getDataLocalDataSource.getAddToCartProduct();
  }

  Future<void> removeItemFromAddToCartProducts(int id) async {
    updateDeleteLocalDataSource.removeItemFromAddToCartProducts(id);
  }

  Future<void> addToCart(AddToCartProductModel addToCartTableModel) async {
    insertDataLocalDataSource.addToCart(addToCartTableModel);
  }

  Future<void> updateQuantity(int id, int quantity) async {
    updateDeleteLocalDataSource.updateQuantity(id, quantity);
  }

  Future<Map<String, dynamic>> getAddToCartProductById(int id) async {
    return getDataLocalDataSource.getAddToCartProductById(id);
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
    return searchDataSource.searchInCategory(
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
    return getDataLocalDataSource.getProductById(id);
  }

  Future<List<Map<String, dynamic>>> getDiscountsProducts() {
    return getDataLocalDataSource.getDiscountProduct();
  }

  Future<List<Map<String, dynamic>>> getSimilarProducts(
      ProductModel product) async {
    return getDataLocalDataSource.getSimilarProducts(product);
  }

  Future<List<Map<String, dynamic>>> getReviews(int id) async {
    return getDataLocalDataSource.getReviews(id);
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
    return searchDataSource.searchInDiscountProducts(
        minPrice: minPrice,
        maxPrice: maxPrice,
        searchWord: searchWord,
        discountFilter: discountFilter,
        ratingFilter: ratingFilter,
        colorFilter: colorFilter,
        selectedCategory: selectedCategory);
  }

  Future<List<Map<String, Object?>>> searchProducts({
    required String searchWord,
    required double minPrice,
    required double maxPrice,
    required List<bool> discountFilter,
    required String selectedCategory,
    required List<bool> ratingFilter,
    required List<bool> colorFilter,
  }) async {
    return searchDataSource.searchProducts(
      discountfilter: discountFilter,
      search: searchWord,
      minPrice: minPrice,
      maxPrice: maxPrice,
      selectedCategory: selectedCategory,
      ratingFilter: ratingFilter,
      colorFilter: colorFilter,
    );
  }

  Future<void> setSearchHistory(String searchWord) {
    return insertDataLocalDataSource.setSearchHistory(searchWord);
  }

  Future<List<Map<String, dynamic>>> getSearchHistory() async {
    return getDataLocalDataSource.getSearchHistory();
  }

  Future<void> deleteWordFormSearchHistory(String word) async {
    return updateDeleteLocalDataSource.deleteWordFormSearchHistory(word);
  }

  Future<void> setFavorateProduct(int id, bool value) async {
    insertDataLocalDataSource.setFavorateProduct(id, value);
  }
}
