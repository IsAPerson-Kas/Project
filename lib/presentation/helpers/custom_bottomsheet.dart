import 'package:flutter/material.dart';

class CustomBottomsheet {
  CustomBottomsheet._();

  // có cả persiten bottomsheet nữa bottom sheet này không chặn thao tác màn hình bên dưới
  // modal bottm sheet thì chặn thao tác màn hình bên dưới, có thể gg để hiểu thêm

  Future<T?> showCustomModalBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    Color backgroundColor = Colors.white,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor,
      isScrollControlled: isScrollControlled,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          child: child,
        );
      },
    );
  }
}
