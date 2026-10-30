import 'package:revolta/data/catalog.dart';
import 'package:revolta/data/volta_rules.dart';
import 'package:revolta/models/scan.dart';
import 'package:revolta/models/scan_result.dart';
import 'package:revolta/state/wallet.dart';

/// Turns a barcode into a result and credits the wallet when it's Volta.
class ScanService {
  ScanService({required this.catalog, required this.wallet});

  final Catalog catalog;
  final Wallet wallet;

  /// Handles one barcode, read by the camera or typed by the user.
  Future<ScanResult> submit(String ean) async {
    // TODO: reject codes that aren't valid EAN-13 (13 digits + check digit).
    final product = await catalog.lookup(ean);
    if (product == null) return UnknownProductResult(ean);
    if (!isVolta(product)) return NotVoltaResult(product);

    final scan = Scan(
      product: product,
      scannedAt: DateTime.now(),
      depositCents: voltaDepositCents,
    );
    wallet.add(scan);
    return VoltaResult(scan);
  }
}
