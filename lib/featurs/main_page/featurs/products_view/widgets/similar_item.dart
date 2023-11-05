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
            right: 50.w,
            top: 10.w,
            child: CustomIconButton(
              size: 20,
              icon: Icon(
                isFavorate ? Icons.favorite : Icons.favorite_outline_rounded,
                color: const Color(0xFFFF6E6E),
              ),
              onPressed: () {
                widget.productCubit.setFavorateProductInDataBase(
                    widget.product.id, !widget.product.isFavorite);
                setState(() {
                  isFavorate = !isFavorate;
                });
              },
            )),
      ],
    );
  }
}
