enum Flavor {
  dev,
  product,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'UBook DEV';
      case Flavor.product:
        return 'UBook';
      default:
        return 'title';
    }
  }
}
