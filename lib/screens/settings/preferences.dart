import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/currency.dart';
import '../../services/firestore_service.dart';

import '../../widgets/glass_card.dart';

import '../home/currency_list.dart';
import 'profile.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _firestoreService = FirestoreService();

  Currency? _defaultCurrency;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final prefs = await _firestoreService.getPreferences(user.uid);
      if (prefs != null && mounted) {
        setState(() {
          final currencyCode = prefs['defaultCurrency'] as String?;
          if (currencyCode != null) {
            _defaultCurrency = CurrencyData.getCurrencyByCode(currencyCode);
          }
          _notificationsEnabled =
              prefs['notificationsEnabled'] as bool? ?? true;
        });
      }
    }
  }

  Future<void> _savePreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestoreService.savePreferences(
        userId: user.uid,
        preferences: {
          'defaultCurrency': _defaultCurrency?.code,
          'notificationsEnabled': _notificationsEnabled,
        },
      );
    }
  }

  Future<void> _sendEmail(String subject) async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@currensee.com',
      query: 'subject=$subject',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showFAQ() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Frequently Asked Questions'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFAQItem(
                'How do I set up rate alerts?',
                'Go to the Alerts tab and tap the + button to create a new alert. Set your desired currency pair and threshold.',
              ),
              _buildFAQItem(
                'Where does the exchange rate data come from?',
                'We use exchangerate.host API for real-time and accurate exchange rates.',
              ),
              _buildFAQItem(
                'How do I change my default currency?',
                'In Settings, tap on "Default Currency" and select your preferred currency from the list.',
              ),
              _buildFAQItem(
                'Is my conversion history private?',
                'Yes, all your data is stored securely in Firebase and is only accessible to you.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportIssueDialog() {
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report an Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'Brief description of the issue',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Detailed description',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await _firestoreService.submitIssue(
                  userId: user.uid,
                  email: user.email ?? '',
                  subject: subjectController.text,
                  description: descriptionController.text,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Issue reported successfully')),
                  );
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Profile Card
          if (user != null)
            GlassCard(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: user.photoURL == null
                        ? const Icon(PhosphorIcons.user, size: 30)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName ?? 'User',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(PhosphorIcons.caret_right),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // Preferences Section
          const Text(
            'Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Default Currency
          GlassCard(
            onTap: () async {
              final selected = await Navigator.of(context).push<Currency>(
                MaterialPageRoute(builder: (_) => const CurrencyListScreen()),
              );
              if (selected != null) {
                setState(() => _defaultCurrency = selected);
                await _savePreferences();
              }
            },
            child: Row(
              children: [
                const Icon(PhosphorIcons.currency_circle_dollar),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Default Currency',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _defaultCurrency?.code ?? 'Not set',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(PhosphorIcons.caret_right),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Notifications
          GlassCard(
            child: Row(
              children: [
                const Icon(PhosphorIcons.bell),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Enable Notifications',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                    _savePreferences();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Support Section
          const Text(
            'Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          GlassCard(
            onTap: _showFAQ,
            child: const Row(
              children: [
                Icon(PhosphorIcons.question),
                SizedBox(width: 16),
                Expanded(
                  child: Text('FAQ', style: TextStyle(fontSize: 16)),
                ),
                Icon(PhosphorIcons.caret_right),
              ],
            ),
          ),
          const SizedBox(height: 8),

          GlassCard(
            onTap: () => _sendEmail('Support Request'),
            child: const Row(
              children: [
                Icon(PhosphorIcons.envelope),
                SizedBox(width: 16),
                Expanded(
                  child: Text('Email Support', style: TextStyle(fontSize: 16)),
                ),
                Icon(PhosphorIcons.caret_right),
              ],
            ),
          ),
          const SizedBox(height: 8),

          GlassCard(
            onTap: _showReportIssueDialog,
            child: const Row(
              children: [
                Icon(PhosphorIcons.warning),
                SizedBox(width: 16),
                Expanded(
                  child:
                      Text('Report an Issue', style: TextStyle(fontSize: 16)),
                ),
                Icon(PhosphorIcons.caret_right),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // App Info
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          GlassCard(
            child: Column(
              children: [
                Text(
                  'CurrenSee',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
