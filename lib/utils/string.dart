extension Transform on String {
  String get asTitle =>
      split(' ').map((e) => e[0].toUpperCase() + e.substring(1)).join(' ');
}
