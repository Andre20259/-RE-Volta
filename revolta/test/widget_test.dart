import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:revolta/data/catalog.dart';
import 'package:revolta/data/placeholder_data.dart';
import 'package:revolta/data/scan_service.dart';
import 'package:revolta/main.dart';
import 'package:revolta/models/scan_result.dart';
import 'package:revolta/screens/result_screen.dart';
import 'package:revolta/state/wallet.dart';
import 'package:revolta/theme.dart';

/// Renders at a small phone size so layout overflows fail the test.
void usePhoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(320 * 3, 640 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Future<void> pumpApp(WidgetTester tester) async {
  final wallet = Wallet();
  await tester.pumpWidget(
    RetornaApp(
      wallet: wallet,
      scanService: ScanService(catalog: Catalog(), wallet: wallet),
    ),
  );
}

Future<void> pumpResult(WidgetTester tester, ScanResult result) {
  return tester.pumpWidget(
    MaterialApp(
      theme: buildTheme(),
      home: ResultScreen(result: result, wallet: Wallet()),
    ),
  );
}

void main() {
  testWidgets('wallet screen shows the balance and recent scans', (
    tester,
  ) async {
    usePhoneSize(tester);
    await pumpApp(tester);

    expect(find.text('My Volta wallet'), findsOneWidget);
    expect(find.text('€2.30'), findsOneWidget);
    expect(find.text('Água mineral 1.5 L'), findsOneWidget);
    expect(find.text('Scan a container'), findsOneWidget);
  });

  testWidgets('typing a known code opens the Volta result', (tester) async {
    usePhoneSize(tester);
    await pumpApp(tester);

    await tester.tap(find.text('Scan a container'));
    await tester.pumpAndSettle();
    expect(find.text('Scan a bottle or can'), findsOneWidget);

    await tester.tap(find.text('Type the code instead'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '5601234000016');
    await tester.pump();
    await tester.tap(find.text('Check code'));
    await tester.pumpAndSettle();

    expect(find.text('Volta container'), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);

    await tester.tap(find.text('Scan next'));
    await tester.pumpAndSettle();
    expect(find.text('Scan a bottle or can'), findsOneWidget);
  });

  testWidgets('not-Volta result renders', (tester) async {
    usePhoneSize(tester);
    await pumpResult(tester, NotVoltaResult(placeholderProducts.last));

    expect(find.text('Not a Volta container'), findsOneWidget);
    expect(find.text('Vinho tinto 75 cl'), findsOneWidget);
    expect(find.text('Undo'), findsNothing);
  });

  testWidgets('unknown product result renders', (tester) async {
    usePhoneSize(tester);
    await pumpResult(tester, const UnknownProductResult('1234567890123'));

    expect(find.text('Product not found'), findsOneWidget);
    expect(find.text('EAN 1234567890123'), findsOneWidget);
  });
}
