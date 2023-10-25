import 'package:flutter/material.dart';
import 'package:h_book/app/extensions/context_extension.dart';

class BaseBottomSheetUi extends StatelessWidget {
  const BaseBottomSheetUi({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        double maxHeight = context.height * 0.7;
        Widget childItem = child;
        if (orientation != Orientation.portrait) {
          maxHeight = context.height * 0.8;
          childItem = SizedBox(
            height: maxHeight,
            child: SingleChildScrollView(
              child: childItem,
            ),
          );
        }
        return SafeArea(
          child: LimitedBox(
            maxHeight: maxHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 45,
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8))),
                          color: Colors.grey),
                      height: 6,
                    ),
                  ),
                ),
                childItem
              ],
            ),
          ),
        );
      },
    );
  }
}

class BaseBottomSheetHeightUi extends StatelessWidget {
  const BaseBottomSheetHeightUi({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LimitedBox(
        maxHeight: context.height * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 45,
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  decoration: const ShapeDecoration(
                      shape: StadiumBorder(), color: Colors.grey),
                  height: 6,
                ),
              ),
            ),
            Expanded(child: child)
          ],
        ),
      ),
    );
  }
}
