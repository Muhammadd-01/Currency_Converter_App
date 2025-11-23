import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../auth/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = FirebaseAuthService();
  final _firestoreService = FirestoreService();

  void _showFeedbackDialog() {
    final messageController = TextEditingController();
    int rating = 5;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Send Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How would you rate CurrenSee?'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating
                          ? PhosphorIcons.star_fill
                          : PhosphorIcons.star,
                      color: const Color(0xFFFFAB00),
                    ),
                    onPressed: () {
                      setDialogState(() => rating = index + 1);
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Your Feedback',
                  hintText: 'Tell us what you think...',
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
                  await _firestoreService.submitFeedback(
                    userId: user.uid,
                    email: user.email ?? '',
                    message: messageController.text,
                    rating: rating,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your feedback!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          GlassCard(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: user.photoURL == null
                      ? const Icon(PhosphorIcons.user, size: 50)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
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
          const SizedBox(height: 24),

          // Account Section
          const Text(
            'Account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          GlassCard(
            child: Column(
              children: [
                _buildInfoRow('Email', user.email ?? 'Not set'),
                const Divider(height: 24),
                _buildInfoRow('User ID', user.uid.substring(0, 8) + '...'),
                const Divider(height: 24),
                _buildInfoRow(
                  'Account Created',
                  user.metadata.creationTime != null
                      ? '${user.metadata.creationTime!.day}/${user.metadata.creationTime!.month}/${user.metadata.creationTime!.year}'
                      : 'Unknown',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Actions
          const Text(
            'Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          GlassCard(
            onTap: _showFeedbackDialog,
            child: const Row(
              children: [
                Icon(PhosphorIcons.chat_circle_text),
                SizedBox(width: 16),
                Expanded(
                  child: Text('Send Feedback', style: TextStyle(fontSize: 16)),
                ),
                Icon(PhosphorIcons.caret_right),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Sign Out Button
          GradientButton(
            text: 'Sign Out',
            icon: PhosphorIcons.sign_out,
            onPressed: _signOut,
            gradientColors: const [Colors.red, Colors.redAccent],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
