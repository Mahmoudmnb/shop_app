import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/featurs/main_page/featurs/wishlist/screens/border_products_view.dart';
import 'package:shop_app/featurs/main_page/featurs/wishlist/screens/wishlist_screen.dart';
import 'package:shop_app/injection.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../home/models/product_model.dart';
import '../../home/pages/home_pages.dart';
import '../../search/cubit/sreach_cubit.dart';
import '../../search/screen/category_view_page.dart';
import '../../search/screen/search_results_screen.dart';
import '../cubits/product_screen/cubit.dart';
import '../widgets/product_view_widgets.dart';

class ProductScreen extends StatefulWidget {
  final ProductModel product;
  final String searchWord;
  final SearchCubit searchCubit;
  final ProductCubit cubit;
  final String fromPage;
  final String? categoryName;
  final String? fromPageTitle;
  const ProductScreen({
    super.key,
    this.fromPageTitle,
    required this.searchWord,
    required this.fromPage,
    required this.product,
    required this.searchCubit,
    required this.cubit,
    this.categoryName,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  //! mnb
  bool isFavorate = false;
  bool isDiscount = true;
  late PageController pageController;
  late ProductModel product;
  List<Color> colors = [];
  List<String> sizes = [];
  List<String> imagesUrl = [];
  double avrOfStars = 0;
  late ProductCubit cubit;
  @override
  void initState() {
    // this line for change color of status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // the color of status bar
      statusBarColor: Colors.white,
      // the color of icons in Android
      statusBarIconBrightness: Brightness.dark,
      // the color of icons in IOS
      statusBarBrightness: Brightness.dark,
    ));
    pageController = PageController();
    product = widget.product;
    List<String> c = product.colors.split('|');
    sizes = product.sizes.split('|');
    for (var element in c) {
      colors.add(Color(int.parse(element)));
    }
    imagesUrl = product.imgUrl.split('|');
    isDiscount = product.disCount > 0;
    cubit = widget.cubit;
    cubit.isFavorite = product.isFavorite;
    cubit.amountOfProduct = 1;
    getAvrOfStars(cubit.reviws);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backToSomePage();
        return false;
      },
      child: SafeArea(
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, _) => Scaffold(
              body: SizedBox(
                width: 393.w,
                height: 852.h,
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    SizedBox(
                      height: 461.h,
                      width: 393.w,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: imagesUrl.length,
                        itemBuilder: (_, int index) => Image(
                          image: AssetImage(imagesUrl[index].trim()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 35,
                      child: CustomIconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded),
                        onPressed: () async {
                          backToSomePage();
                        },
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 35,
                      child: BlocBuilder<ProductCubit, ProductStates>(
                        builder: (context, state) {
                          isFavorate = cubit.isFavorite;
                          if (state is ChangeProductFavoriteState) {
                            isFavorate = cubit.isFavorite;
                          }
                          return CustomIconButton(
                            icon: Icon(
                              isFavorate
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline_rounded,
                              color:
                                  isFavorate ? const Color(0xFFFF6E6E) : null,
                            ),
                            onPressed: () async {
                              if (isFavorate) {
                                cubit
                                    .changeFavorite(product.id)
                                    .then((value) {});
                                sl
                                    .get<DataSource>()
                                    .deleteFromPorderBroducts(product.id);
                              } else {
                                List<Map<String, dynamic>> borders =
                                    await sl.get<DataSource>().getBorders();
                                if (context.mounted) {
                                  context.read<ProductCubit>().selectedBorder =
                                      'All items';
                                  context
                                      .read<ProductCubit>()
                                      .createModelBottomSheet(
                                          context, borders, product);
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 398.h,
                      child: SmoothPageIndicator(
                        count: imagesUrl.length,
                        effect: ExpandingDotsEffect(
                          dotWidth: 6,
                          dotHeight: 6,
                          activeDotColor: Colors.white,
                          dotColor: Colors.white.withOpacity(.61),
                        ),
                        controller: pageController,
                        onDotClicked: (index) {
                          log(index.toString());
                        },
                      ),
                    ),
                    //todo: this widget to get the status of DraggaablesScrollSheet and change the status of DraggaablesScrollSheet
                    NotificationListener<DraggableScrollableNotification>(
                        onNotification:
                            (DraggableScrollableNotification notification) {
                          if (notification.extent >= 0.999) {
                            cubit.widthOfPrice = 3.w;
                            cubit.hidden = true;
                            cubit.changeWidthOfPrice();
                          } else if (notification.extent <= 0.49) {
                            cubit.widthOfPrice = 141.w;
                            cubit.hidden = false;
                            cubit.changeWidthOfPrice();
                          }
                          if (notification.extent >= 0.999) {
                            cubit.b = false;
                          } else {
                            cubit.b = true;
                          }
                          return true;
                        },
                        child: ProductDetails(
                          hidden: cubit.hidden,
                          categoryName: widget.fromPage == 'SearchReasults'
                              ? ''
                              : widget.categoryName!,
                          fromPage: widget.fromPage,
                          colors: colors,
                          sizes: sizes,
                          cubit: cubit,
                          getAvrOfStars: getAvrOfStars,
                          product: product,
                          avrOfStars: avrOfStars,
                          similarProducts: cubit.similarProducts,
                          searchCubit: widget.searchCubit,
                          searchWord: widget.searchWord,
                        )),
                  ],
                ),
              ),
              bottomSheet: BlocBuilder<ProductCubit, ProductStates>(
                builder: (context, state) {
                  bool hidden = cubit.hidden;
                  double widthOfPrice = cubit.widthOfPrice;
                  if (state is ChangeWidthOfPrice) {
                    hidden = cubit.hidden;
                    widthOfPrice = cubit.widthOfPrice;
                  }
                  return AddToCartBottomSheet(
                    isDiscount: isDiscount,
                    product: product,
                    widthOfPrice: widthOfPrice,
                    hidden: hidden,
                  );
                },
              )),
        ),
      ),
    );
  }

  //!mnb
  void getAvrOfStars(List<Map<String, dynamic>> reviews) {
    int totalStars = 0;
    for (var element in reviews) {
      totalStars += element['stars'] as int;
    }
    if (totalStars != 0) {
      avrOfStars = totalStars / reviews.length * 1.0;
    } else {
      avrOfStars = 0;
    }
  }

  void backToSomePage() async {
    if (widget.fromPage == 'SearchReasults') {
      await widget.searchCubit.search(widget.searchWord.trim()).then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SearchResultScreen(
              searchWord: widget.searchWord,
              fromPage: 'ProductView',
              searchProducts: value),
        ));
      });
    } else if (widget.fromPage == 'CategoryProducts') {
      if (widget.searchWord != '') {
        await widget.searchCubit
            .searchInCategory(
                widget.searchWord, widget.categoryName!.toLowerCase())
            .then((value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => CategoryViewPage(
              categoryName: widget.categoryName!,
              categoryProducts: value,
              searchWord: widget.searchWord,
            ),
          ));
        });
      } else {
        await widget.searchCubit
            .searchInCategory(null, widget.categoryName!.toLowerCase())
            .then((value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => CategoryViewPage(
              searchWord: widget.searchWord,
              categoryName: widget.categoryName!.toLowerCase(),
              categoryProducts: value,
            ),
          ));
        });
      }
    } else if (widget.fromPage == 'seeAll') {
      List<Map<String, dynamic>> trendyProducts = [];
      if (widget.fromPageTitle == 'Trendy') {
        trendyProducts = await sl.get<DataSource>().getTrendyProducts();
      }
      if (widget.searchWord != '') {
        if (context.mounted) {
          context
              .read<SearchCubit>()
              .searchInSeeAllProducts(
                  widget.searchWord, widget.fromPageTitle!, trendyProducts)
              .then((categoryProducts) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => SeeAllProductsPage(
                  searchWord: widget.searchWord,
                  categoryName: widget.fromPageTitle!,
                  categoryProducts: categoryProducts),
            ));
          });
        }
      } else {
        if (context.mounted) {
          context
              .read<SearchCubit>()
              .searchInSeeAllProducts(
                  null, widget.fromPageTitle!, trendyProducts)
              .then((categoryProducts) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => SeeAllProductsPage(
                  searchWord: widget.searchWord,
                  categoryName: widget.fromPageTitle!,
                  categoryProducts: categoryProducts),
            ));
          });
        }
      }
    } else if (widget.fromPage == 'WishList') {
      List<Map<String, dynamic>> borders =
          await sl.get<DataSource>().getBorders();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => WishListScreen(borders: borders)));
      }
    } else if (widget.fromPage == 'BorderProducts') {
      List<Map<String, dynamic>> products = [];
      List<Map<String, dynamic>> border =
          await sl.get<DataSource>().getBorderByName(widget.categoryName!);
      List<Map<String, dynamic>> borderProducts =
          await sl.get<DataSource>().getProductsInBorder(border[0]['id']);
      for (var i = 0; i < borderProducts.length; i++) {
        products.add(await sl
            .get<DataSource>()
            .getProductById(borderProducts[i]['productId']));
      }
      if (context.mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => BorderProductView(
                borderName: widget.categoryName!, borderProducts: products)));
      }
    }
  }
}
