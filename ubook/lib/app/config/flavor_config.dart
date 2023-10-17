// ignore_for_file: constant_identifier_names

enum Flavor { DEV, PROD }

class FlavorValues {
  final String? bundleID;
  final String? appID;
  final String? baseUrl;
  final String? sentryUrl;
  final String? dynamicLinkUrl;

  FlavorValues(
      {this.bundleID,
      this.appID,
      this.baseUrl,
      this.sentryUrl,
      this.dynamicLinkUrl});
}

class FlavorConfig {
  final Flavor flavor;
  final String env;
  final String name;
  final FlavorValues? values;
  static FlavorConfig? _instance;

  factory FlavorConfig(
      {required Flavor flavor,
      required String name,
      required String env,
      required FlavorValues values}) {
    _instance ??= FlavorConfig._internal(flavor, name, env, values);
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.name, this.env, this.values);

  static FlavorConfig? get instance => _instance;

  static bool isDevelopment() => _instance!.flavor == Flavor.DEV;

  static bool isProduction() => _instance!.flavor == Flavor.PROD;
}
