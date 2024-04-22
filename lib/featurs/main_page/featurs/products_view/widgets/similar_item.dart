import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../home/models/product_model.dart';
import '../cubits/product_screen/cubit.dart';
import 'product_view_widgets.dart';

class SimilarItem extends StatefulWidget {
  final ProductModel product;
  final ProductCubit productCubit;
  const SimilarItem(
      {super.key, required this.product, required this.productCubit});

  @override
  State<SimilarItem> createState() => _SimilarItemState();
}

class _SimilarItemState extends State<SimilarItem> {
  late bool isFavorate;
  @override
  void initState() {
    isFavorate = widget.product.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomCard(
          width: 141.w,
          height: 206.h,
          product: widget.product,
        ),
        Positioned(
            right: 35.w,
            top: 10.w,
            child: Container(
                height: 33.h,
                width: 33.h,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: isFavorate
                    ? const Icon(
                        Icons.favorite,
                        color: Color(0xffFF6E6E),
                      )
                    : const Icon(
                        Icons.favorite,
                        color: Color(0xffD8D8D8),
                      ))),
      ],
    );
  }
}
