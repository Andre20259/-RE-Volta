import 'package:flutter/foundation.dart';

import 'package:revolta/data/placeholder_data.dart';
import 'package:revolta/models/scan.dart';

/// The user's scanned containers and the deposit they add up to.
class Wallet extends ChangeNotifier {
  // TODO: start empty and fill the list in load().
  final List<Scan> _scans = placeholderScans();

  /// Scanned containers, newest first.
  List<Scan> get scans => List.unmodifiable(_scans);

  /// Total deposit the user can get back, in cents.
  int get balanceCents {
    // TODO: add up depositCents of every scan.
    return 230;
  }

  /// How many containers are in the wallet.
  int get containerCount {
    // TODO: count the scans.
    return 23;
  }

  /// Reads the scans saved on the device. Called once at startup.
  Future<void> load() async {
    // TODO: read the saved scans (e.g. with shared_preferences).
  }

  /// Adds [scan] to the wallet.
  void add(Scan scan) {
    // TODO: insert the scan at the start of the list and save.
    notifyListeners();
  }

  /// Removes the most recent scan (the Undo button on the result screen).
  void undoLast() {
    // TODO: remove the newest scan and save.
    notifyListeners();
  }

  /// Empties the wallet (the Reset button).
  void reset() {
    // TODO: clear every scan and save.
    notifyListeners();
  }
}
