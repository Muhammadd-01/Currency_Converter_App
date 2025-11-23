import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../../models/currency.dart';
import '../../widgets/glass_card.dart';

class CurrencyListScreen extends StatefulWidget {
  const CurrencyListScreen({super.key});

  @override
  State<CurrencyListScreen> createState() => _CurrencyListScreenState();
}

class _CurrencyListScreenState extends State<CurrencyListScreen> {
  final _searchController = TextEditingController();
  List<Currency> _filteredCurrencies = CurrencyData.currencies;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCurrencies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = CurrencyData.currencies;
      } else {
        _filteredCurrencies = CurrencyData.currencies.where((currency) {
          return currency.code.toLowerCase().contains(query.toLowerCase()) ||
              currency.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('Select Currency'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search currency...',
                prefixIcon: const Icon(PhosphorIcons.magnifying_glass),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterCurrencies,
            ),
          ),

          // Currency List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCurrencies.length,
              itemBuilder: (context, index) {
                final currency = _filteredCurrencies[index];
                return GlassCard(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.all(16),
                  onTap: () {
                    Navigator.of(context).pop(currency);
                  },
                  child: Row(
                    children: [
                      Text(
                        currency.flag,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currency.code,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              currency.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        currency.symbol,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8E2DE2),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
