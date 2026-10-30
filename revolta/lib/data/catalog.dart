import 'package:revolta/data/placeholder_data.dart';
import 'package:revolta/models/product.dart';

/// Finds the product behind a barcode.
class Catalog {
  /// Returns the product with this [ean], or null if it isn't known.
  Future<Product?> lookup(String ean) async {
    // TODO: load the products from assets/products.json (or an API) and search
    // those instead of the placeholder list.
    return placeholderProducts.where((p) => p.ean == ean).firstOrNull;
  }
}
