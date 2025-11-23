import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/history.dart';
import '../../services/firestore_service.dart';
import '../../widgets/glass_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('Please login to view history'),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Conversion History'),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIcons.trash),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear History'),
                  content: const Text(
                      'Are you sure you want to clear all conversion history?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _firestoreService.clearAllHistory(user.uid);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('History cleared')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ConversionHistory>>(
        stream: _firestoreService.getConversionHistory(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final history = snapshot.data ?? [];

          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIcons.clock_counter_clockwise,
                    size: 64,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No conversion history yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Dismissible(
                  key: Key(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(PhosphorIcons.trash, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _firestoreService.deleteConversionHistory(
                      userId: user.uid,
                      historyId: item.id,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Conversion deleted')),
                    );
                  },
                  child: GlassCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            PhosphorIcons.arrows_left_right,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.amount.toStringAsFixed(2)} ${item.baseCurrency} → ${item.convertedAmount.toStringAsFixed(2)} ${item.targetCurrency}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rate: ${item.rate.toStringAsFixed(4)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.formattedDate,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
