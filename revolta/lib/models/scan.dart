import 'package:revolta/models/product.dart';

/// One container the user scanned into the wallet.
class Scan {
  const Scan({
    required this.product,
    required this.scannedAt,
    required this.depositCents,
  });

  final Product product;
  final DateTime scannedAt;

  /// Deposit this container is worth, in cents.
  final int depositCents;

  // TODO: add toJson/fromJson so the wallet can save scans on the device.
}
