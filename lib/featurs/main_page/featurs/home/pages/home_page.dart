import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../cubit/main_page_cubit.dart';
import '../../search/cubit/sreach_cubit.dart';
import '../blocs/discount/discount_products_bloc.dart';
import '../models/product_model.dart';
import '../widgets/collections_spacer.dart';
import '../widgets/discount_image.dart';
import '../widgets/recommended_image.dart';
import '../widgets/trendy_image.dart';
import 'home_pages.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, Object?>> disCountProducts;
  final List<Map<String, dynamic>> trindyProducts;
  const HomePage(
      {super.key,
      required this.disCountProducts,
      required this.trindyProducts});

  @override
  Widget build(BuildContext context) {
    context.read<MainPageCubit>().changePageIndex(0);
    context
        .read<DiscountProductsBloc>()
        .add(GetDiscountProducts(discountProducts: disCountProducts));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: [
          SizedBox(height: 10.h),
          SizedBox(
            height: 160.h,
            width: 353.w,
            child: Image.asset(
              'assets/images/Capture.PNG',
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 15.h),
          CollectionsSpacer(
              onTap: () {
                context
                    .read<SearchCubit>()
                    .searchInDiscounts(null, 'Discount', null)
                    .then((disCountProducts) {
                  context.read<SearchCubit>().reset('', false);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SeeAllProductsPage(
                        searchWord: '',
                        categoryName: 'Discount',
                        categoryProducts: disCountProducts),
                  ));
                });
              },
              collectoinTitle: 'Discount'),
          SizedBox(height: 15.h),
          //! Discount products
          SizedBox(
              width: double.infinity,
              height: 182.h,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      disCountProducts.length < 6 ? disCountProducts.length : 6,
                  itemBuilder: (context, index) {
                    ProductModel product =
                        ProductModel.fromMap(disCountProducts[index]);
                    return DisCountImage(
                        makerCompany: product.makerCompany,
                        imageUrl: product.imgUrl,
                        price: product.price.toString(),
                        productName: product.name,
                        discount: product.disCount.toString());
                  })),
          SizedBox(height: 15.h),
          CollectionsSpacer(onTap: () {}, collectoinTitle: 'Recommended'),
          //! Recommended products
          SizedBox(height: 15.h),
          SizedBox(
            height: 78.h,
            child: ListView.builder(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => const RecommendedImage(
                companyMaker: 'elegance',
                imageUrl: 'assets/images/1.png',
                productPrice: '10 \$',
                productNamge: 'Coffee polo shirt',
              ),
            ),
          ),
          SizedBox(height: 15.h),

          //! Trendy products
          CollectionsSpacer(
              onTap: () async {
                context.read<SearchCubit>().reset('', false);
                // ToDo: i have to update trendy product before user can get here
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SeeAllProductsPage(
                      searchWord: '',
                      categoryName: 'Trendy',
                      categoryProducts: trindyProducts),
                ));
              },
              collectoinTitle: 'Trendy'),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.only(left: 3.w, top: 1.h),
            width: 123.w,
            height: 180.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: trindyProducts.length,
              itemBuilder: (_, index) => TrendyImage(
                makerCompany: trindyProducts[index]['makerCompany'],
                imageUrl: trindyProducts[index]['imgUrl'].split('|')[0],
                price: trindyProducts[index]['price'].toString(),
                productName: trindyProducts[index]['name'],
              ),
            ),
          ),
          SizedBox(height: 15.h),
          // CollectionsSpacer(onTap: () {}, collectoinTitle: 'Top Collection'),
          //! Top collection
          // SizedBox(height: 15.h),
          // const TopCollectionImage(),
        ],
      ),
    );
  }
}
