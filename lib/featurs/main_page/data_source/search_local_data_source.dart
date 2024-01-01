import 'dart:developer';

import 'package:sqflite/sqflite.dart';

import '../../../core/constant.dart';

class SearchDataSource {
  final List<String> hexaColors = [
    '0xFF181E27',
    '0xFF44565C',
    '0xFF6D4F44',
    '0xFF6D6D6D',
    '0xFF7E7E7E',
    '0xFFCE8722',
    '0xFFDC4447',
    '0xFFDFA8A9',
    '0xFFE4E4E4'
  ];

  List<Map<String, dynamic>> filterWithoutSearchWordProducts(
      String selectedCategory,
      List<Map<String, dynamic>> allProducts,
      List<bool> discountFilter,
      List<bool> ratingFilter,
      List<bool> colorFilter) {
    return allProducts.where((element) {
      if ((colorFilter[0] &&
              element['colors'].toString().contains(hexaColors[0])) ||
          (colorFilter[1] &&
              element['colors'].toString().contains(hexaColors[1])) ||
          (colorFilter[2] &&
              element['colors'].toString().contains(hexaColors[2])) ||
          (colorFilter[3] &&
              element['colors'].toString().contains(hexaColors[3])) ||
          (colorFilter[4] &&
              element['colors'].toString().contains(hexaColors[4])) ||
          (colorFilter[5] &&
              element['colors'].toString().contains(hexaColors[5])) ||
          (colorFilter[6] &&
              element['colors'].toString().contains(hexaColors[6])) ||
          (colorFilter[7] &&
              element['colors'].toString().contains(hexaColors[7])) ||
          (colorFilter[8] &&
              element['colors'].toString().contains(hexaColors[8]))) {
        if ((discountFilter[0] && element['discount'] == 10) ||
            (discountFilter[1] && element['discount'] == 15) ||
            (discountFilter[2] && element['discount'] == 20) ||
            (discountFilter[3] && element['discount'] == 30) ||
            (discountFilter[4] && element['discount'] == 50) ||
            (discountFilter[5] && element['discount'] == 70)) {
          if ((ratingFilter[0] && element['rating'] == 1) ||
              (ratingFilter[1] && element['rating'] == 2) ||
              (ratingFilter[2] && element['rating'] == 3) ||
              (ratingFilter[3] && element['rating'] == 4) ||
              (ratingFilter[4] && element['rating'] == 5)) {
            return true;
          } else {
            bool key = false;
            for (var element in ratingFilter) {
              if (element) {
                key = true;
              }
            }
            if (key) {
              return false;
            } else {
              return true;
            }
          }
        } else {
          bool key = false;
          for (var element in discountFilter) {
            if (element) {
              key = true;
            }
          }
          if (key) {
            return false;
          } else {
            if ((ratingFilter[0] && element['rating'] == 1) ||
                (ratingFilter[1] && element['rating'] == 2) ||
                (ratingFilter[2] && element['rating'] == 3) ||
                (ratingFilter[3] && element['rating'] == 4) ||
                (ratingFilter[4] && element['rating'] == 5)) {
              return true;
            } else {
              bool key = false;
              for (var element in ratingFilter) {
                if (element) {
                  key = true;
                }
              }
              if (key) {
                return false;
              } else {
                return true;
              }
            }
          }
        }
      } else {
        bool key = false;
        for (var element in colorFilter) {
          if (element) {
            key = true;
          }
        }
        if (key) {
          return false;
        } else {
          if ((discountFilter[0] && element['discount'] == 10) ||
              (discountFilter[1] && element['discount'] == 15) ||
              (discountFilter[2] && element['discount'] == 20) ||
              (discountFilter[3] && element['discount'] == 30) ||
              (discountFilter[4] && element['discount'] == 50) ||
              (discountFilter[5] && element['discount'] == 70)) {
            if ((ratingFilter[0] && element['rating'] == 1) ||
                (ratingFilter[1] && element['rating'] == 2) ||
                (ratingFilter[2] && element['rating'] == 3) ||
                (ratingFilter[3] && element['rating'] == 4) ||
                (ratingFilter[4] && element['rating'] == 5)) {
              return true;
            } else {
              bool key = false;
              for (var element in ratingFilter) {
                if (element) {
                  key = true;
                }
              }
              if (key) {
                return false;
              } else {
                return true;
              }
            }
          } else {
            bool key = false;
            for (var element in discountFilter) {
              if (element) {
                key = true;
              }
            }
            if (key) {
              return false;
            } else {
              if ((ratingFilter[0] && element['rating'] == 1) ||
                  (ratingFilter[1] && element['rating'] == 2) ||
                  (ratingFilter[2] && element['rating'] == 3) ||
                  (ratingFilter[3] && element['rating'] == 4) ||
                  (ratingFilter[4] && element['rating'] == 5)) {
                return true;
              } else {
                bool key = false;
                for (var element in ratingFilter) {
                  if (element) {
                    key = true;
                  }
                }
                if (key) {
                  return false;
                } else {
                  return true;
                }
              }
            }
          }
        }
      }
    }).toList();
  }

  Future<List<Map<String, dynamic>>> filterWithSearchWord(
      String searchWord,
      String selectedCategory,
      List<Map<String, dynamic>> allProducts,
      List<bool> discountFilter,
      List<bool> ratingFilter,
      List<bool> colorFilter) async {
    var data = filterWithoutSearchWordProducts(selectedCategory, allProducts,
        discountFilter, ratingFilter, colorFilter);
    return data.where((element) {
      log(element.toString());
      return ((element['name'])
              .toString()
              .toLowerCase()
              .contains(searchWord.toLowerCase()) ||
          (element['category'])
              .toString()
              .toLowerCase()
              .contains(searchWord.toLowerCase()) ||
          (element['discription'])
              .toString()
              .toLowerCase()
              .contains(searchWord.toLowerCase()) ||
          (element['makerCompany'])
              .toString()
              .toLowerCase()
              .contains(searchWord.toLowerCase()));
    }).toList();
  }

  Future<List<Map<String, Object?>>> searchInCategory({
    String? searchWord,
    required double minPrice,
    required double maxPrice,
    required String selectedCategory,
    required List<bool> discountfilter,
    required List<bool> ratingFilter,
    required List<bool> colorFilter,
  }) async {
    Database db = await openDatabase(Constant.productDataBasePath);
    List<Map<String, dynamic>> searchResult = [];
    List<Map<String, dynamic>> allProducts = [];
    try {
      if (selectedCategory == 'All') {
        allProducts = await db.rawQuery(
            'SELECT * FROM  products WHERE price >= $minPrice AND price<=$maxPrice');
      } else {
        allProducts = await db.rawQuery(
            "SELECT * FROM  products WHERE price >= $minPrice AND price<=$maxPrice AND category == '$selectedCategory'");
      }

      if (searchWord == null) {
        searchResult = filterWithoutSearchWordProducts(selectedCategory,
            allProducts, discountfilter, ratingFilter, colorFilter);
      } else {
        searchResult = await filterWithSearchWord(searchWord, selectedCategory,
            allProducts, discountfilter, ratingFilter, colorFilter);
      }
    } catch (e) {
      log(e.toString());
    }
    return searchResult;
  }

  Future<List<Map<String, Object?>>> searchInDiscountProducts({
    required double minPrice,
    required double maxPrice,
    String? searchWord,
    required String selectedCategory,
    required List<bool> discountFilter,
    required List<bool> ratingFilter,
    required List<bool> colorFilter,
  }) async {
    Database db = await openDatabase(Constant.productDataBasePath);
    List<Map<String, dynamic>> searchResult = [];
    List<Map<String, dynamic>> allProducts = [];
    try {
      if (selectedCategory == 'All') {
        allProducts = await db.rawQuery(
            'SELECT * FROM  products WHERE price >= $minPrice AND price<=$maxPrice AND discount > 0 ORDER BY price');
      } else {
        allProducts = await db.rawQuery(
            "SELECT * FROM  products WHERE price >= $minPrice AND price<=$maxPrice AND category == '$selectedCategory' AND discount > 0 ORDER BY price");
      }
      if (searchWord == null) {
        searchResult = filterWithoutSearchWordProducts(selectedCategory,
            allProducts, discountFilter, ratingFilter, colorFilter);
      } else {
        searchResult = await filterWithSearchWord(searchWord, selectedCategory,
            allProducts, discountFilter, ratingFilter, colorFilter);
      }
    } catch (e) {
      log(e.toString());
    }
    return searchResult;
  }

  Future<List<Map<String, Object?>>> searchProducts(
      {required String search,
      required double minPrice,
      required double maxPrice,
      required String selectedCategory,
      required List<bool> discountfilter,
      required List<bool> ratingFilter,
      required List<bool> colorFilter}) async {
    Database db = await openDatabase(Constant.productDataBasePath);
    List<Map<String, dynamic>> searchResult = [];
    List<Map<String, dynamic>> allProducts = [];
    try {
      if (selectedCategory == 'All') {
        allProducts = await db.rawQuery(
            'SELECT * FROM  products WHERE price >= $minPrice AND price<=$maxPrice');
      } else {
        allProducts = await db.rawQuery(
            "SELECT * FROM  products WHERE price >= $minPrice AND price<=$maxPrice AND category == '$selectedCategory'");
      }
      searchResult = await filterWithSearchWord(search, selectedCategory,
          allProducts, discountfilter, ratingFilter, colorFilter);
    } catch (e) {
      log(e.toString());
    }
    return searchResult;
  }

  Future<List<Map<String, dynamic>>> searchInTrendyProducts(
      String selectedCategory,
      String? searchWord,
      double minPrice,
      double maxPrice,
      List<Map<String, dynamic>> trendyProducts,
      List<bool> discountFilter,
      List<bool> ratingFilter,
      List<bool> colorFilter) async {
    if (searchWord == null) {
      return filterWithoutSearchWordProducts(selectedCategory, trendyProducts,
          discountFilter, ratingFilter, colorFilter);
    } else {
      return filterWithSearchWord(searchWord, selectedCategory, trendyProducts,
          discountFilter, ratingFilter, colorFilter);
    }
  }
}
