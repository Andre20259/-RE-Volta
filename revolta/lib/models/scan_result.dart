import 'package:revolta/models/product.dart';
import 'package:revolta/models/scan.dart';

/// What happened when a barcode was submitted.
sealed class ScanResult {
  const ScanResult();
}

/// The product is a Volta container and its deposit was added to the wallet.
class VoltaResult extends ScanResult {
  const VoltaResult(this.scan);

  final Scan scan;
}

/// The product is known but Volta doesn't cover it.
class NotVoltaResult extends ScanResult {
  const NotVoltaResult(this.product);

  final Product product;
}

/// No product matches the barcode.
class UnknownProductResult extends ScanResult {
  const UnknownProductResult(this.ean);

  final String ean;
}
