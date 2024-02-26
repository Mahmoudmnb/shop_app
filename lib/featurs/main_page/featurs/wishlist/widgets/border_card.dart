import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../injection.dart';
import '../../../data_source/data_source_paths.dart';
import '../../home/models/product_model.dart';
import '../screens/border_products_view.dart';

class BorderCard extends StatelessWidget {
  final String borderName;
  final List<Map<String, dynamic>> borderProducts;
  const BorderCard(
      {super.key, required this.borderName, required this.borderProducts});

  @override
  Widget build(BuildContext context) {
    return borderProducts.isEmpty
        ? const SizedBox.shrink()
        : GestureDetector(
            onTap: () async {
              List<Map<String, dynamic>> products = [];
              for (var i = 0; i < borderProducts.length; i++) {
                products.add(await sl
                    .get<DataSource>()
                    .getProductById(borderProducts[i]['productId']));
              }
              if (context.mounted) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => BorderProductView(
                        borderName: borderName, borderProducts: products)));
              }
            },
            child: SizedBox(
              width: 340.w,
              child: Column(
                children: [
                  Container(
                    height: 180.h,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: borderProducts.isEmpty
                        ? null
                        : Row(
                            children: [
                              SizedBox(
                                width: 165,
                                child: FutureBuilder(
                                    future: sl.get<DataSource>().getProductById(
                                        borderProducts[0]['productId']),
                                    builder: (context, snapsot) {
                                      if (snapsot.hasData) {
                                        ProductModel product =
                                            ProductModel.fromMap(snapsot.data!);
                                        return ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                          child: Image.asset(
                                            product.imgUrl.split('|')[0],
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }),
                              ),
                              Expanded(
                                flex: 2,
                                child: borderProducts.length > 1
                                    ? GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: .8.h,
                                          crossAxisSpacing: 0,
                                          mainAxisExtent: 87.w,
                                        ),
                                        itemCount: borderProducts.length,
                                        itemBuilder: (context, index) {
                                          if (index < 0) {
                                            return const SizedBox.shrink();
                                          } else {
                                            return FutureBuilder(
                                                future: sl
                                                    .get<DataSource>()
                                                    .getProductById(
                                                        borderProducts[index]
                                                            ['productId']),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    ProductModel product =
                                                        ProductModel.fromMap(
                                                            snapshot.data!);
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomRight: index ==
                                                                      5
                                                                  ? const Radius
                                                                      .circular(
                                                                      10)
                                                                  : const Radius
                                                                      .circular(
                                                                      0),
                                                              topRight: index ==
                                                                      2
                                                                  ? const Radius
                                                                      .circular(
                                                                      10)
                                                                  : const Radius
                                                                      .circular(
                                                                      0)),
                                                      child: Image.asset(
                                                        product.imgUrl
                                                            .split('|')[0],
                                                        fit: BoxFit.fill,
                                                      ),
                                                    );
                                                  } else {
                                                    return const SizedBox
                                                        .shrink();
                                                  }
                                                });
                                          }
                                        },
                                      )
                                    : const SizedBox.square(),
                              )
                            ],
                          ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 15.w, right: 25.w, top: 5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            borderName,
                            style: const TextStyle(
                              color: Color(0xFF383838),
                              fontSize: 16,
                              fontFamily: 'Tenor Sans',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            '${borderProducts.length} Items',
                            style: const TextStyle(
                              color: Color(0xFF9B9B9B),
                              fontSize: 10,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 1,
                            ),
                          )
                        ],
                      )),
                  const SizedBox(height: 15)
                ],
              ),
            ),
          );
  }
}
