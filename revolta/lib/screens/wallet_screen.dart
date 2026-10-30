import 'package:flutter/material.dart';

import 'package:revolta/data/scan_service.dart';
import 'package:revolta/data/volta_rules.dart';
import 'package:revolta/models/scan.dart';
import 'package:revolta/screens/scanner_screen.dart';
import 'package:revolta/state/wallet.dart';
import 'package:revolta/theme.dart';
import 'package:revolta/utils/format.dart';

/// S1: balance, last scanned containers and the scan button.
class WalletScreen extends StatelessWidget {
  const WalletScreen({
    super.key,
    required this.wallet,
    required this.scanService,
  });

  final Wallet wallet;
  final ScanService scanService;

  void _openScanner(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ScannerScreen(scanService: scanService, wallet: wallet),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset wallet?'),
        content: const Text(
          'This removes every scanned container and sets your balance '
          'back to €0.00.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) wallet.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: ListenableBuilder(
            listenable: wallet,
            builder: (context, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(
                  onReset: wallet.scans.isEmpty
                      ? null
                      : () => _confirmReset(context),
                ),
                const SizedBox(height: 20),
                _BalanceCard(
                  balanceCents: wallet.balanceCents,
                  containerCount: wallet.containerCount,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: _RecentScans(scans: wallet.scans),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _openScanner(context),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan a container'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onReset});

  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Retorna',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                'My Volta wallet',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        TextButton(onPressed: onReset, child: const Text('Reset')),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.balanceCents,
    required this.containerCount,
  });

  final int balanceCents;
  final int containerCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final noun = containerCount == 1 ? 'container' : 'containers';
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Volta deposits you can get back',
            style: textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            formatEuros(balanceCents),
            style: textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$containerCount $noun · ${formatEuros(voltaDepositCents)} each',
            style: textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _RecentScans extends StatelessWidget {
  const _RecentScans({required this.scans});

  final List<Scan> scans;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
            child: Text(
              'LAST SCANNED',
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 1.2,
              ),
            ),
          ),
          if (scans.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
              child: Text(
                'Nothing scanned yet. Scan your first bottle or can to start.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 6),
                itemCount: scans.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: AppColors.border),
                itemBuilder: (_, i) => _ScanTile(scan: scans[i]),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScanTile extends StatelessWidget {
  const _ScanTile({required this.scan});

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final product = scan.product;
    final strong = textTheme.titleMedium?.copyWith(
      color: AppColors.green,
      fontWeight: FontWeight.w700,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(product.material.label[0], style: strong),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${formatScanTime(scan.scannedAt)} · '
                  '${product.material.listLabel}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text('+${formatEuros(scan.depositCents)}', style: strong),
        ],
      ),
    );
  }
}
