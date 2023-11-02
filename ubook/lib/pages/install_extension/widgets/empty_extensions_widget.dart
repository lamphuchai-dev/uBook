import 'package:flutter/material.dart';
import 'package:ubook/app/extensions/index.dart';

class EmptyExtensionsWidget extends StatelessWidget {
  const EmptyExtensionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: context.height * 0.3,
          ),
          const Icon(
            Icons.extension_off_rounded,
            size: 100,
          ),
        ],
      ),
    );
  }
}
