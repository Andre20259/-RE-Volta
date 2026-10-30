import 'package:revolta/models/product.dart';

/// Deposit paid back for each Volta container, in cents.
const voltaDepositCents = 10;

/// Largest container Volta accepts, in litres.
const voltaMaxLiters = 3.0;

/// Whether Volta accepts containers made of [material].
bool isVoltaMaterial(ContainerMaterial material) {
  // TODO: only plastic bottles and metal cans are covered.
  return true;
}

/// Whether a container of [liters] is small enough for Volta.
bool isVoltaSize(double liters) {
  // TODO: compare against voltaMaxLiters.
  return true;
}

/// Whether [product] is a Volta container.
bool isVolta(Product product) =>
    isVoltaMaterial(product.material) && isVoltaSize(product.volumeLiters);

/// Explains why [product] isn't covered, for the "not Volta" screen.
String notVoltaReason(Product product) {
  // TODO: say what failed (material or size) and which bin to use instead.
  return 'Volta only covers plastic bottles and metal cans up to 3 L.';
}
