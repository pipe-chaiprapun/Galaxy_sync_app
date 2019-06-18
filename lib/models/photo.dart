class Photo {
  Photo({
    this.assetName,
    this.assetPackage,
    this.title,
    this.isFavorite = false,
    this.caption
  });

  final String assetName;
  final String assetPackage;
  final String title;
  final String caption;

  bool isFavorite;
  String get tag => assetName; // Assuming that all asset names are unique.

  bool get isValid => assetName != null && title != null && caption != null && isFavorite != null;
}