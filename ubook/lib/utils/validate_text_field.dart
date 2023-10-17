import 'dart:async';

import 'package:flutter/widgets.dart';

class ValidateTextField extends ValueNotifier<String> {
  String? Function(String tmp) validate;
  late TextEditingController controller;
  late FocusNode focusNode;
  Timer? _debounce;

  ValidateTextField({required this.validate, String? text}) : super("") {
    controller = TextEditingController(text: text);
    focusNode = FocusNode();
    controller.addListener(() {
      if (_debounce != null && _debounce!.isActive) {
        value = "";
        _debounce?.cancel();
      }
      _debounce = Timer(const Duration(milliseconds: 400), () {
        final errorText = validate.call(controller.text);
        if (errorText != null) {
          value = errorText;
        } else if (value != "") {
          value = "";
        }
      });
    });
  }

  String get text => controller.text;

  bool validateDone() {
    final errorText = validate.call(controller.text);
    if (errorText != null) {
      focusNode.requestFocus();
      value = errorText;
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
