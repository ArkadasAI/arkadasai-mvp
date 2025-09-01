import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class PaywallPage extends StatelessWidget {
  final VoidCallback onDismiss;
  final VoidCallback onUpgradePlus;
  final VoidCallback onUpgradePro;
  const PaywallPage({
    super.key,
    required this.onDismiss,
    required this.onUpgradePlus,
    required this.onUpgradePro,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Paywall')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text(loc.translate('free_plan')),
                subtitle: const Text('İlk oturumda 5 mesaj'),
                trailing: ElevatedButton(
                  onPressed: onDismiss,
                  child: Text(loc.translate('continue_free')),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(loc.translate('plus_plan')),
                subtitle: const Text('Daha hızlı yanıtlar, uzun sohbet'),
                trailing: ElevatedButton(
                  onPressed: onUpgradePlus,
                  child: Text(loc.translate('upgrade')),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(loc.translate('pro_plan')),
                subtitle: const Text('Öncelikli latency, enterprise'),
                trailing: ElevatedButton(
                  onPressed: onUpgradePro,
                  child: Text(loc.translate('upgrade')),
                ),
              ),
            ),
            TextButton(
              onPressed: onDismiss,
              child: Text(loc.translate('later')),
            ),
          ],
        ),
      ),
    );
  }
}
