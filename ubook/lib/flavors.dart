enum Flavor {
  dev,
  staging,
  product,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'uBook DEV';
      case Flavor.staging:
        return 'uBook Stag';
      case Flavor.product:
        return 'uBook';
      default:
        return 'title';
    }
  }

}
