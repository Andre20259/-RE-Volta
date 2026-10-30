/// What a drink container is made of.
enum ContainerMaterial {
  plastic('Plastic', 'plastic'),
  metal('Metal', 'can'),
  glass('Glass', 'glass'),
  other('Other', 'other');

  const ContainerMaterial(this.label, this.listLabel);

  /// Name shown on tags, e.g. "Plastic".
  final String label;

  /// Short word shown in the wallet list, e.g. "can".
  final String listLabel;
}

/// A drink product, identified by its barcode.
class Product {
  const Product({
    required this.ean,
    required this.name,
    required this.material,
    required this.volumeLiters,
  });

  /// EAN-13 barcode number.
  final String ean;

  /// Display name, including the size, e.g. "Água mineral 1.5 L".
  final String name;

  final ContainerMaterial material;
  final double volumeLiters;
}
