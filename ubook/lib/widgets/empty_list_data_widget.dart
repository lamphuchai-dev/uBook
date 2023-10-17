import 'package:flutter/material.dart';
import 'package:ubook/app/extensions/extensions.dart';

import '../app/constants/constants.dart';

class EmptyListDataWidget extends StatelessWidget {
  const EmptyListDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding:
            const EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
        child: SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.t,
            children: [
              Card(
                child: Container(
                    height: 120,
                    alignment: Alignment.center,
                    child: Text(
                      "COMMON.NO_DATA",
                      style: textTheme.bodyLarge,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
