import 'package:flutter/material.dart';
class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = 18,
  });
  final void Function() onPressed;
  final Icon icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36 / 2),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0.7),
              blurRadius: 0.5,
              color: Colors.grey,
            ),
          ],
        ),
        child: IconButton(
          iconSize: size,
          icon: icon,
          onPressed: onPressed,
          splashRadius: 10,
        ),
      ),
    );
  }
}
