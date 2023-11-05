import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../../injection.dart';
import '../../../data_source/data_source.dart';
import '../cubit/sreach_cubit.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SreachInitial());
  static SearchCubit get(context) => BlocProvider.of(context);
  bool isSearch = false;
  startSreaching(bool newSreach) {
    isSearch = newSreach;
    emit(SearchingState());
  }

  openDrawer(context) {
    Scaffold.of(context).openEndDrawer();
    emit(OpenDrawerState());
  }

  List<bool> filterRating = [false, false, false, false, false];
  List<bool> filterDiscount = [false, false, false, false, false, false];
  List<bool> filterColors = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  double minPrice = 0;
  double maxPrice = 100;
  SfRangeValues valuesOfFilterPrice = const SfRangeValues(0, 100.0);
  selectFilterRating(int index) {
    filterRating[index] = !filterRating[index];
    emit(FilterRatringState());
  }

  selectFilterColor(int index) {
    filterColors[index] = !filterColors[index];
    emit(FilterRatringState());
  }

  selectFilterDiscount(int index) {
    filterDiscount[index] = !filterDiscount[index];
    emit(FilterDiscountState());
  }

  changeValueofFilterPrice(SfRangeValues value) {
    valuesOfFilterPrice = value;
    minPrice = value.start;
    maxPrice = value.end;
    emit(ChangeValueOfFiltersPrice());
  }

  //! mnb
  List discount = [10, 15, 20, 30, 50, 70];
  List colors = [
    const Color(0xFF181E27),
    const Color(0xFF44565C),
    const Color(0xFF6D4F44),
    const Color(0xFF6D6D6D),
    const Color(0xFF7E7E7E),
    const Color(0xFFCE8722),
    const Color(0xFFDC4447),
    const Color(0xFFDFA8A9),
    const Color(0xFFE4E4E4)
  ];
  String selectedCategory = 'All';
  List<Map<String, dynamic>> searchHistory = [];
  bool isCategoryViewSearch = false;
  void changeCategoryViewSearch(bool value) {
    isCategoryViewSearch = value;
    emit(IsCategoryViewSearch());
  }

  Future<List<Map<String, dynamic>>> search(String search) async {
    List<Map<String, dynamic>> searchResult =
        await sl.get<DataSource>().searchProducts(
              search: search,
              minPrice: minPrice,
              maxPrice: maxPrice,
              discountFilter: filterDiscount,
              selectedCategory: selectedCategory,
              ratingFilter: filterRating,
              colorFilter: filterColors,
            );
    emit(SearchResults(searchResult: searchResult));
    return searchResult;
  }

  Future<void> getSearchHistory() async {
    searchHistory = await sl.get<DataSource>().getSearchHistory();
    emit(SearchHistory(searchHistory: searchHistory));
  }

  Future<void> reset(String searchWord, bool isSearchAfter) async {
    minPrice = 0;
    maxPrice = 100;
    valuesOfFilterPrice = const SfRangeValues(0, 100);
    filterDiscount = [false, false, false, false, false, false];
    filterRating = [false, false, false, false, false, false];
    filterColors = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ];
    selectedCategory = 'All';
    emit(ResetFilter());
    if (isSearchAfter) {
      await search(searchWord);
    }
  }

  Future<void> setFavorateProduct(int id, bool value) async {
    await sl.get<DataSource>().setFavorateProduct(id, value);
  }

  void setSelectedCategory(String value) {
    selectedCategory = value;
    emit(SetSelectedCategory());
  }

  Future<List<Map<String, dynamic>>> searchInCategory(
      String? searchWord, String categoryName) async {
    var data = await sl.get<DataSource>().searchInCategory(
        minPrice: minPrice,
        maxPrice: maxPrice,
        searchWord: searchWord,
        discountFilter: filterDiscount,
        selectedCategory: selectedCategory,
        ratingFilter: filterRating,
        colorFilter: filterColors);
    emit(SaveState(categoryProducts: data));
    return data;
  }
}
