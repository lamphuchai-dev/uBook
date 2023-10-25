// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef SizeChange = void Function(dynamic size);

class SizeChild<T> extends SingleChildRenderObjectWidget {
  const SizeChild({
    super.key,
    required this.onChangeSize,
    Widget? child,
  }) : super(child: child);

  final SizeChange onChangeSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onChangeSize);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderMenuItem renderObject) {
    renderObject.childSize = onChangeSize;
  }
}

class _RenderMenuItem extends RenderProxyBox {
  _RenderMenuItem(this.childSize, [RenderBox? child]) : super(child);

  SizeChange childSize;
  Size? currentSize;

  @override
  void performLayout() {
    super.performLayout();
    try {
      Size? newSize = child?.size;

      if (newSize != null && currentSize != newSize) {
        final tmp = child?.globalToLocal(Offset.zero);

        currentSize = newSize;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // childSize.call(tmp?.dy);
        });
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
