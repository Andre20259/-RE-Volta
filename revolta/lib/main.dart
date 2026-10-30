import 'package:flutter/material.dart';

import 'package:revolta/data/catalog.dart';
import 'package:revolta/data/scan_service.dart';
import 'package:revolta/screens/wallet_screen.dart';
import 'package:revolta/state/wallet.dart';
import 'package:revolta/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final wallet = Wallet();
  await wallet.load();
  final scanService = ScanService(catalog: Catalog(), wallet: wallet);
  runApp(RetornaApp(wallet: wallet, scanService: scanService));
}

class RetornaApp extends StatelessWidget {
  const RetornaApp({
    super.key,
    required this.wallet,
    required this.scanService,
  });

  final Wallet wallet;
  final ScanService scanService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retorna',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: WalletScreen(wallet: wallet, scanService: scanService),
    );
  }
}
