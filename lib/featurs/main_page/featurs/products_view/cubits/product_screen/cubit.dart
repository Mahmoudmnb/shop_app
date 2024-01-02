import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/featurs/main_page/featurs/products_view/models/add_to_cart_product_model.dart';

import '../../../../../../injection.dart';
import '../../../../data_source/data_source.dart';
import '../../../home/models/product_model.dart';

part 'states.dart';

class ProductCubit extends Cubit<ProductStates> {
  ProductCubit() : super(ProductInitialState());
  bool isFavorite = false;
  int indexOfColor = 0;
  int indexOfSize = 0;
  int amountOfProduct = 1;
  Future<void> changeFavorite(int id) async {
    isFavorite = !isFavorite;
    await setFavorateProductInDataBase(id, isFavorite).then((value) {});
    emit(ChangeProductFavoriteState());
  }

  void addAmountOfProduct() {
    amountOfProduct++;
    emit(ChangeProductAmountState());
  }

  void removeAmountOfProduct() {
    if (amountOfProduct > 1) amountOfProduct--;
    emit(ChangeProductAmountState());
  }

  void changeIndexOfSize(int index) {
    indexOfSize = index;
    emit(ChangeProductSizeState());
  }

  void changeIndexOfColor(int index) {
    indexOfColor = index;
    emit(ChangeProductColorState());
  }

  //! mnb
  List<Map<String, dynamic>> reviws = [];
  List<Map<String, dynamic>> similarProducts = [];
  double widthOfPrice = 145;
  bool hidden = false;
  bool b = true;
  void changeWidthOfPrice() {
    emit(ChangeWidthOfPrice());
  }

  Future<void> setFavorateProductInDataBase(int id, bool value) async {
    await sl.get<DataSource>().setFavorateProduct(id, value);
  }

  Future<void> getReviws(int id) async {
    reviws = await sl.get<DataSource>().getReviews(id);
    emit(GetReviews());
  }

  Future<void> getSimilarProducts(ProductModel product) async {
    similarProducts = await sl.get<DataSource>().getSimilarProducts(product);
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    return sl.get<DataSource>().getProductById(id);
  }

  Future<void> addToCart(ProductModel product) async {
    String color = product.colors.split('|')[indexOfColor];
    String size = product.sizes.split('|')[indexOfSize];
    String imgUrl = product.imgUrl.split('|')[0];
    log(amountOfProduct.toString());
    sl
        .get<DataSource>()
        .addToCart(AddToCartProductModel(
            orderId: product.id,
            imgUrl: imgUrl,
            quantity: amountOfProduct,
            color: color,
            companyMaker: product.makerCompany,
            productName: product.name,
            price: product.disCount > 0
                ? (1 - product.disCount / 100) * product.price
                : product.price,
            size: size))
        .then((value) {
      amountOfProduct = 1;
      emit(ChangeProductAmountState());
    });
  }
}
