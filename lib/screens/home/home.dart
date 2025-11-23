import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../../widgets/gradient_background.dart';
import 'converter.dart';
import 'history.dart';
import 'alerts.dart';
import 'news.dart';
import '../settings/preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ConverterScreen(),
    const HistoryScreen(),
    const AlertsScreen(),
    const NewsScreen(),
    const PreferencesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8E2DE2).withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.currency_circle_dollar),
              label: 'Convert',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.clock_counter_clockwise),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.bell),
              label: 'Alerts',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.newspaper),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.gear),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
