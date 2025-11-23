import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/rate_alert.dart';
import '../../models/currency.dart';
import '../../services/firestore_service.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../home/currency_list.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final _firestoreService = FirestoreService();

  void _showCreateAlertDialog() {
    Currency baseCurrency = CurrencyData.currencies[0];
    Currency targetCurrency = CurrencyData.currencies[1];
    AlertCondition condition = AlertCondition.above;
    final thresholdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create Rate Alert'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Base Currency
                ListTile(
                  title: Text('From: ${baseCurrency.code}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    final selected = await Navigator.of(context).push<Currency>(
                      MaterialPageRoute(
                          builder: (_) => const CurrencyListScreen()),
                    );
                    if (selected != null) {
                      setDialogState(() => baseCurrency = selected);
                    }
                  },
                ),
                // Target Currency
                ListTile(
                  title: Text('To: ${targetCurrency.code}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    final selected = await Navigator.of(context).push<Currency>(
                      MaterialPageRoute(
                          builder: (_) => const CurrencyListScreen()),
                    );
                    if (selected != null) {
                      setDialogState(() => targetCurrency = selected);
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Condition
                DropdownButtonFormField<AlertCondition>(
                  value: condition,
                  decoration: const InputDecoration(labelText: 'Condition'),
                  items: const [
                    DropdownMenuItem(
                      value: AlertCondition.above,
                      child: Text('Above'),
                    ),
                    DropdownMenuItem(
                      value: AlertCondition.below,
                      child: Text('Below'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => condition = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Threshold
                TextField(
                  controller: thresholdController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Threshold Rate',
                    hintText: '0.00',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final threshold = double.tryParse(thresholdController.text);
                if (threshold == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid threshold')),
                  );
                  return;
                }

                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await _firestoreService.addRateAlert(
                    userId: user.uid,
                    baseCurrency: baseCurrency.code,
                    targetCurrency: targetCurrency.code,
                    threshold: threshold,
                    condition: condition,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Alert created successfully')),
                    );
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('Please login to manage alerts'),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Rate Alerts'),
      ),
      body: StreamBuilder<List<RateAlert>>(
        stream: _firestoreService.getRateAlerts(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final alerts = snapshot.data ?? [];

          if (alerts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIcons.bell,
                    size: 64,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No rate alerts yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    text: 'Create Alert',
                    icon: PhosphorIcons.plus,
                    onPressed: _showCreateAlertDialog,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: alert.isActive
                              ? [
                                  const Color(0xFF4A00E0),
                                  const Color(0xFF8E2DE2)
                                ]
                              : [Colors.grey.shade700, Colors.grey.shade800],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        alert.isActive
                            ? PhosphorIcons.bell_ringing
                            : PhosphorIcons.bell_slash,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${alert.baseCurrency}/${alert.targetCurrency}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${alert.conditionText} ${alert.threshold.toStringAsFixed(4)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: alert.isActive,
                      onChanged: (value) {
                        _firestoreService.updateRateAlert(
                          userId: user.uid,
                          alertId: alert.id,
                          isActive: value,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(PhosphorIcons.trash, color: Colors.red),
                      onPressed: () async {
                        await _firestoreService.deleteRateAlert(
                          userId: user.uid,
                          alertId: alert.id,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Alert deleted')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateAlertDialog,
        child: const Icon(PhosphorIcons.plus),
      ),
    );
  }
}
