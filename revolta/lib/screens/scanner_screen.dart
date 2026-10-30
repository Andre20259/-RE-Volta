import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:revolta/data/scan_service.dart';
import 'package:revolta/screens/result_screen.dart';
import 'package:revolta/state/wallet.dart';
import 'package:revolta/theme.dart';

/// S2: camera viewfinder, with typing the code as a fallback.
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({
    super.key,
    required this.scanService,
    required this.wallet,
  });

  final ScanService scanService;
  final Wallet wallet;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _busy = false;

  /// Called with each barcode, from the camera or the "type the code" sheet.
  Future<void> _submit(String code) async {
    if (_busy) return;
    setState(() => _busy = true);
    final result = await widget.scanService.submit(code);
    if (!mounted) return;
    setState(() => _busy = false);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(result: result, wallet: widget.wallet),
      ),
    );
    // TODO: resume the camera here when coming back from the result screen.
  }

  Future<void> _typeCode() async {
    final code = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => const _ManualCodeSheet(),
    );
    if (code == null || !mounted) return;
    await _submit(code);
  }

  void _toggleTorch() {
    // TODO: switch the flash on and off once the camera is connected.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scannerDark,
      appBar: AppBar(
        backgroundColor: AppColors.scannerDark,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Close',
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scan a bottle or can',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: AppColors.torch),
            tooltip: 'Flash',
            onPressed: _toggleTorch,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.scannerDark, AppColors.scannerDarker],
                ),
              ),
              child: Stack(
                children: [
                  // TODO: show the camera preview here (e.g. MobileScanner
                  // from package:mobile_scanner) and call _submit with the
                  // first barcode it detects.
                  const Center(child: _ScanFrame()),
                  const Positioned(
                    left: 24,
                    right: 24,
                    bottom: 40,
                    child: Text(
                      'Point the camera at the barcode',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  if (_busy)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.scannerAccent,
                      ),
                    ),
                ],
              ),
            ),
          ),
          ColoredBox(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: OutlinedButton(
                  onPressed: _busy ? null : _typeCode,
                  child: const Text('Type the code instead'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The rounded frame the user lines the barcode up with.
class _ScanFrame extends StatelessWidget {
  const _ScanFrame();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: AspectRatio(
          aspectRatio: 1.7,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(color: AppColors.scannerAccent, width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Stand-in for the camera image; remove with the real preview.
                const FractionallySizedBox(
                  widthFactor: 0.7,
                  heightFactor: 0.55,
                  child: CustomPaint(painter: _BarcodePainter()),
                ),
                Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: AppColors.scannerAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  const _BarcodePainter();

  /// Alternating bar and gap widths, one digit each.
  static final _widths = '21111221113112112111311221111231112112112111'
      .split('')
      .map(int.parse)
      .toList();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final unit = size.width / _widths.fold(0, (sum, w) => sum + w);
    var x = 0.0;
    for (final (i, w) in _widths.indexed) {
      if (i.isEven) {
        canvas.drawRect(Rect.fromLTWH(x, 0, w * unit, size.height), paint);
      }
      x += w * unit;
    }
  }

  @override
  bool shouldRepaint(_BarcodePainter oldDelegate) => false;
}

/// Bottom sheet for typing the number printed under the barcode.
class _ManualCodeSheet extends StatefulWidget {
  const _ManualCodeSheet();

  @override
  State<_ManualCodeSheet> createState() => _ManualCodeSheetState();
}

class _ManualCodeSheetState extends State<_ManualCodeSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _done() {
    final code = _controller.text.trim();
    if (code.isNotEmpty) Navigator.pop(context, code);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Type the barcode number',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            "It's the number printed under the bars.",
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 13,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _done(),
            decoration: const InputDecoration(
              hintText: '13-digit number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => FilledButton(
              onPressed: _controller.text.isEmpty ? null : _done,
              child: const Text('Check code'),
            ),
          ),
        ],
      ),
    );
  }
}
