import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

mixin DialogStateMixin<T extends StatefulWidget> on State<T> {
  bool isShowDialog = false;

  void showLoadingDialog() {
    if (isShowDialog) {
      hideLoadingDialog();
    }
    isShowDialog = true;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) => WillPopScope(
            onWillPop: () async => false, child: const LoadingWidget())));
  }

  void showDialogMsg(message) async {
    // if (isShowDialog) {
    //   hideLoadingDialog();
    // }
    // isShowDialog = true;
    // showDialog(
    //     context: context,
    //     builder: ((context) => DialogCustomPainter.notification(
    //           content: message,
    //         ))).then((value) {
    //   isShowDialog = false;
    // });
  }

  void hideLoadingDialog() {
    if (isShowDialog) {
      isShowDialog = false;
      Navigator.pop(context);
    }
  }

  Future<dynamic> showBottomSheetBase({required Widget child}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => BaseBottomSheetUi(
        child: child,
      ),
    );
  }
}
