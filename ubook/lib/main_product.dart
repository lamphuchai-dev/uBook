import 'flavors.dart';

import 'main_common.dart' as runner;

Future<void> main() async {
  F.appFlavor = Flavor.product;
  await runner.mainCommon();
}
