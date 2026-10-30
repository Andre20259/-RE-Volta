/// Sample data that fills the screens while the backend is stubbed.
/// Delete this file once the catalogue and the wallet load real data.
library;

import 'package:revolta/data/volta_rules.dart';
import 'package:revolta/models/product.dart';
import 'package:revolta/models/scan.dart';

/// Type one of these codes on the scanner screen to see a result.
const placeholderProducts = <Product>[
  Product(
    ean: '5601234000016',
    name: 'Água mineral 1.5 L',
    material: ContainerMaterial.plastic,
    volumeLiters: 1.5,
  ),
  Product(
    ean: '5601234000023',
    name: 'Cola lata 33 cl',
    material: ContainerMaterial.metal,
    volumeLiters: 0.33,
  ),
  Product(
    ean: '5601234000030',
    name: 'Cerveja lata 33 cl',
    material: ContainerMaterial.metal,
    volumeLiters: 0.33,
  ),
  Product(
    ean: '5601234000047',
    name: 'Sumo laranja 1.5 L',
    material: ContainerMaterial.plastic,
    volumeLiters: 1.5,
  ),
  Product(
    ean: '5601234000054',
    name: 'Vinho tinto 75 cl',
    material: ContainerMaterial.glass,
    volumeLiters: 0.75,
  ),
];

/// The "last scanned" list from the mock-up, dated relative to today.
List<Scan> placeholderScans() {
  final now = DateTime.now();
  DateTime daysAgo(int days, int hour, int minute) =>
      DateTime(now.year, now.month, now.day - days, hour, minute);

  return [
    Scan(
      product: placeholderProducts[0],
      scannedAt: daysAgo(0, 14, 2),
      depositCents: voltaDepositCents,
    ),
    Scan(
      product: placeholderProducts[1],
      scannedAt: daysAgo(0, 13, 58),
      depositCents: voltaDepositCents,
    ),
    Scan(
      product: placeholderProducts[2],
      scannedAt: daysAgo(1, 19, 30),
      depositCents: voltaDepositCents,
    ),
    Scan(
      product: placeholderProducts[3],
      scannedAt: daysAgo(11, 10, 15),
      depositCents: voltaDepositCents,
    ),
  ];
}
