import 'package:appwrite/models.dart';
import 'package:image_picker/image_picker.dart';

import '../featurs/check_out/models/address_model.dart';
import '../featurs/home/models/product_model.dart';
import '../featurs/products_view/models/add_to_cart_product_model.dart';
import '../featurs/products_view/models/review_model.dart';
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
  //! this section for inserting data
  Future<void> uploadProfileSettings(
      String borderProducts, String cartProducts, String borders) async {
    return remoteDataSource.uploadProfileSettings(
        borderProducts, cartProducts, borders);
  }

  Future<void> rateApp(String descrition, double rate) async {
    return await remoteDataSource.rateApp(descrition, rate);
  }

  Future<void> changePassword(String newPassword) async {
    remoteDataSource.changePassword(newPassword);
  }

  Future<void> uploadImage(XFile image) async {
    return remoteDataSource.uploadImage(image);
  }

  Future<void> getReviewsFromCloud() async {
    return remoteDataSource.getReviewsFromCloud();
  }

  Future<void> addReviewToCloud(ReviewModel reviewModel) {
    return remoteDataSource.addReviewToCloud(reviewModel);
  }

  Future<void> addReiviewToProduct(ReviewModel reiview) async {
    return insertDataLocalDataSource.addReviewToProduct(reiview);
  }

  Future<void> addBorder(String borderName) async {
    return insertDataLocalDataSource.addBorder(borderName);
  }

  Future<void> addProductToBorder(int productId, int borderId) async {
    return insertDataLocalDataSource.addProductToBorder(productId, borderId);
  }

  Future<void> insertDataInOrderTableFromCloud(List<Document> orders) async {
    insertDataLocalDataSource.insertDataInOrderTableFromCloud(orders);
  }

  Future<void> insertDataInReviewTableFromCloud(List<Document> document) async {
    insertDataLocalDataSource.addDataToReviewTableFromCloue(document);
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

  Future<void> addNewLocation(AddressModel address) async {
    return insertDataLocalDataSource.addNewLocation(address);
  }

  Future<void> addToCart(AddToCartProductModel addToCartTableModel) async {
    insertDataLocalDataSource.addToCart(addToCartTableModel);
  }

  Future<void> setSearchHistory(String searchWord) {
    return insertDataLocalDataSource.setSearchHistory(searchWord);
  }

  Future<void> setFavorateProduct(int id, bool value) async {
    insertDataLocalDataSource.setFavorateProduct(id, value);
  }

  //! this section for getting data
  Future<List<Map<String, dynamic>>> getRecommendedProducts() async {
    return getDataLocalDataSource.getRecommendedProducts();
  }

  Future<List<Document>> getRecommendedproductsFromCloud() async {
    return remoteDataSource.getRecommendedproductsFromCloud();
  }

  Future<void> setRecommendedProducts() {
    return insertDataLocalDataSource.setRecommendedProducts();
  }

  Future<List<Document>> getPricesFromCloud(List<String> productsIds) async {
    return remoteDataSource.getPricesFromCloud(productsIds);
  }

  Future<bool> isAllBordersIsEmpty() async {
    return getDataLocalDataSource.isAllBordersIsEmpty();
  }

  Future<void> insertPersonalData() async {
    return insertDataLocalDataSource.insertPersonalDataInDataBase();
  }

  Future<Map<String, dynamic>> getPersonalDataFromCloud() async {
    return remoteDataSource.getPersonalData();
  }

  Future<List<Map<String, dynamic>>> getAllFavoritProducts() async {
    return getDataLocalDataSource.getAllFavoritProducts();
  }

  Future<List<Map<String, dynamic>>> getProductsInBorder(int borderId) async {
    return getDataLocalDataSource.getProductsInBorder(borderId);
  }

  Future<List<Map<String, dynamic>>> getAllBorderProducts() async {
    return getDataLocalDataSource.getBorderProducts();
  }

  Future<List<Map<String, dynamic>>> getBorderByName(String borderName) async {
    return getDataLocalDataSource.getBorderByName(borderName);
  }

  Future<List<Map<String, dynamic>>> getTrendyProducts() async {
    return getDataLocalDataSource.getTrendyProducts();
  }

  Future<List<Map<String, dynamic>>> getBorders() async {
    return getDataLocalDataSource.getBorders();
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

  Future<void> getProductsFormCloudDataBase() async {
    await insertDataLocalDataSource
        .insertDataIntoLocalDataBase(await remoteDataSource.getProducts());
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    return getDataLocalDataSource.getLocations();
  }

  Future<List<Map<String, dynamic>>> getAddToCartProducts() async {
    return getDataLocalDataSource.getAddToCartProduct();
  }

  Future<Map<String, dynamic>> getAddToCartProductById(int id) async {
    return getDataLocalDataSource.getAddToCartProductById(id);
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

  Future<List<Map<String, dynamic>>> getSearchHistory() async {
    return getDataLocalDataSource.getSearchHistory();
  }

//! this section for deleting and updating data
  Future<void> updatePrices(
      List<String> productsNames, List<double> oldPrices) async {
    updateDeleteLocalDataSource.updatePrices(productsNames, oldPrices);
  }

  Future<void> deleteAddress(String addressName) async {
    return updateDeleteLocalDataSource.deleteAddress(addressName);
  }

  Future<void> deleteFromPorderBroducts(int productId) async {
    return updateDeleteLocalDataSource.deleteProductFromBorder(productId);
  }

  Future<void> clearAddToCartTable() async {
    return updateDeleteLocalDataSource.clearAddToCartTable();
  }

  Future<void> clearProductsTable() async {
    return updateDeleteLocalDataSource.clearProductsTable();
  }

  Future<void> clearBordersTable() async {
    return updateDeleteLocalDataSource.clearBordersTable();
  }

  Future<void> clearBorderProductsTable() async {
    return updateDeleteLocalDataSource.clearBorderPoducts();
  }

  Future<void> removeItemFromAddToCartProducts(int id) async {
    updateDeleteLocalDataSource.removeItemFromAddToCartProducts(id);
  }

  Future<void> updateQuantity(int id, int quantity) async {
    updateDeleteLocalDataSource.updateQuantity(id, quantity);
  }

  Future<void> deleteWordFormSearchHistory(String word) async {
    return updateDeleteLocalDataSource.deleteWordFormSearchHistory(word);
  }

  Future<void> updateAddress(
      AddressModel address, String oldAddressName) async {
    updateDeleteLocalDataSource.updateAddress(address, oldAddressName);
  }

//! this section for searching
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
      searchWord: searchWord,
      minPrice: minPrice,
      maxPrice: maxPrice,
      selectedCategory: selectedCategory,
      ratingFilter: ratingFilter,
      colorFilter: colorFilter,
    );
  }
}
