import 'package:flutter/material.dart';

import 'package:revolta/data/volta_rules.dart';
import 'package:revolta/models/scan_result.dart';
import 'package:revolta/state/wallet.dart';
import 'package:revolta/theme.dart';
import 'package:revolta/utils/format.dart';

/// S3 / S4: what the scanned barcode turned out to be.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.result, required this.wallet});

  final ScanResult result;
  final Wallet wallet;

  void _undo(BuildContext context) {
    wallet.undoLast();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  List<Widget> _content() => switch (result) {
    VoltaResult(:final scan) => [
      _StatusBanner(
        icon: Icons.check,
        color: AppColors.green,
        background: AppColors.mint,
        title: 'Volta container',
        amount: '+${formatEuros(scan.depositCents)}',
        caption:
            'added to your wallet · now ${formatEuros(wallet.balanceCents)}',
      ),
      _ProductCard(
        name: scan.product.name,
        ean: scan.product.ean,
        tags: [
          _Tag(scan.product.material.label),
          _Tag(formatLiters(scan.product.volumeLiters)),
          const _Tag('Volta', icon: Icons.check),
        ],
      ),
      const _NoteCard(
        lead: 'Tip:',
        text: 'return it whole, with the cap on and the barcode readable.',
      ),
    ],
    NotVoltaResult(:final product) => [
      const _StatusBanner(
        icon: Icons.close,
        color: AppColors.red,
        background: AppColors.redSoft,
        title: 'Not a Volta container',
        caption: 'Nothing added to your wallet',
      ),
      _ProductCard(
        name: product.name,
        ean: product.ean,
        tags: [
          _Tag(
            product.material.label,
            warning: !isVoltaMaterial(product.material),
          ),
          _Tag(
            formatLiters(product.volumeLiters),
            warning: !isVoltaSize(product.volumeLiters),
          ),
        ],
      ),
      _NoteCard(lead: 'Why:', text: notVoltaReason(product)),
    ],
    UnknownProductResult(:final ean) => [
      const _StatusBanner(
        icon: Icons.question_mark,
        color: AppColors.red,
        background: AppColors.redSoft,
        title: 'Product not found',
        caption: 'Nothing added to your wallet',
      ),
      _ProductCard(name: 'Unknown product', ean: ean),
      const _NoteCard(
        lead: 'Why:',
        text:
            "This barcode isn't in the Volta catalogue. Check the number "
            'and try again.',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: _content(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Back to the scanner, which is still open underneath.
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Scan next'),
              ),
              if (result is VoltaResult) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _undo(context),
                  child: const Text('Undo'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.caption,
    this.amount,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String caption;
  final String? amount;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 44),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (amount case final amount?)
            Text(
              amount,
              style: textTheme.displayMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.name,
    required this.ean,
    this.tags = const [],
  });

  final String name;
  final String ean;
  final List<_Tag> tags;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'EAN $ean',
              style: textTheme.bodyLarge?.copyWith(color: AppColors.textMuted),
            ),
            if (tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: tags),
            ],
          ],
        ),
      ),
    );
  }
}

/// A small pill like "Plastic" or "1.5 L". Red when it's why Volta said no.
class _Tag extends StatelessWidget {
  const _Tag(this.label, {this.icon, this.warning = false});

  final String label;
  final IconData? icon;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final color = warning ? AppColors.red : AppColors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: warning ? AppColors.redSoft : AppColors.mint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
          if (icon != null) Icon(icon, color: color, size: 16),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.lead, required this.text});

  final String lead;
  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$lead ',
                style: TextStyle(
                  color: ColorScheme.of(context).onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: text),
            ],
          ),
          style: textTheme.bodyLarge?.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}
