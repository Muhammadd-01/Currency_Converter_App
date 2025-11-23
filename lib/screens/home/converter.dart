import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/currency.dart';
import '../../services/currency_api_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/glass_card.dart';
import 'currency_list.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _amountController = TextEditingController(text: '1');
  final _currencyService = CurrencyApiService();
  final _firestoreService = FirestoreService();

  Currency _baseCurrency = CurrencyData.currencies[0]; // USD
  Currency _targetCurrency = CurrencyData.currencies[1]; // EUR

  double? _exchangeRate;
  double? _convertedAmount;
  bool _isLoading = false;

  int _selectedPeriod = 7; // 7, 30, or 90 days
  Map<String, double>? _historicalRates;

  @override
  void initState() {
    super.initState();
    _fetchExchangeRate();
    _fetchHistoricalRates();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _fetchExchangeRate() async {
    setState(() => _isLoading = true);

    try {
      final rate = await _currencyService.getExchangeRate(
        baseCurrency: _baseCurrency.code,
        targetCurrency: _targetCurrency.code,
      );

      setState(() {
        _exchangeRate = rate;
        _convertedAmount =
            (double.tryParse(_amountController.text) ?? 0) * rate;
        _isLoading = false;
      });

      // Save to history
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && _convertedAmount != null) {
        await _firestoreService.addConversionHistory(
          userId: user.uid,
          baseCurrency: _baseCurrency.code,
          targetCurrency: _targetCurrency.code,
          rate: rate,
          amount: double.tryParse(_amountController.text) ?? 0,
          convertedAmount: _convertedAmount!,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _fetchHistoricalRates() async {
    try {
      final rates = await _currencyService.getHistoricalRatesForPeriod(
        baseCurrency: _baseCurrency.code,
        targetCurrency: _targetCurrency.code,
        days: _selectedPeriod,
      );

      setState(() {
        _historicalRates = rates;
      });
    } catch (e) {
      // Silently fail for historical rates
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _baseCurrency;
      _baseCurrency = _targetCurrency;
      _targetCurrency = temp;
    });
    _fetchExchangeRate();
    _fetchHistoricalRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Currency Converter'),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIcons.list),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CurrencyListScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Amount Input Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0.00',
                      ),
                      onChanged: (value) {
                        if (_exchangeRate != null) {
                          setState(() {
                            _convertedAmount =
                                (double.tryParse(value) ?? 0) * _exchangeRate!;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Currency Selection
              GlassCard(
                child: Column(
                  children: [
                    // From Currency
                    InkWell(
                      onTap: () async {
                        final selected =
                            await Navigator.of(context).push<Currency>(
                          MaterialPageRoute(
                            builder: (_) => const CurrencyListScreen(),
                          ),
                        );
                        if (selected != null) {
                          setState(() => _baseCurrency = selected);
                          _fetchExchangeRate();
                          _fetchHistoricalRates();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              _baseCurrency.flag,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _baseCurrency.code,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _baseCurrency.name,
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
                    ),

                    // Swap Button
                    Center(
                      child: IconButton(
                        onPressed: _swapCurrencies,
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            PhosphorIcons.arrows_down_up,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // To Currency
                    InkWell(
                      onTap: () async {
                        final selected =
                            await Navigator.of(context).push<Currency>(
                          MaterialPageRoute(
                            builder: (_) => const CurrencyListScreen(),
                          ),
                        );
                        if (selected != null) {
                          setState(() => _targetCurrency = selected);
                          _fetchExchangeRate();
                          _fetchHistoricalRates();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              _targetCurrency.flag,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _targetCurrency.code,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _targetCurrency.name,
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Converted Amount
              if (_convertedAmount != null)
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Converted Amount',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_targetCurrency.symbol} ${_convertedAmount!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8E2DE2),
                        ),
                      ),
                      if (_exchangeRate != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '1 ${_baseCurrency.code} = ${_exchangeRate!.toStringAsFixed(4)} ${_targetCurrency.code}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Historical Chart
              if (_historicalRates != null && _historicalRates!.isNotEmpty)
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Exchange Rate History',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              _buildPeriodButton(7),
                              _buildPeriodButton(30),
                              _buildPeriodButton(90),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _getChartSpots(),
                                isCurved: true,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4A00E0),
                                    Color(0xFF8E2DE2)
                                  ],
                                ),
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF4A00E0).withOpacity(0.3),
                                      const Color(0xFF8E2DE2).withOpacity(0.1),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(int days) {
    final isSelected = _selectedPeriod == days;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: InkWell(
        onTap: () {
          setState(() => _selectedPeriod = days);
          _fetchHistoricalRates();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                  )
                : null,
            color: isSelected ? null : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${days}D',
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getChartSpots() {
    if (_historicalRates == null || _historicalRates!.isEmpty) return [];

    final sortedEntries = _historicalRates!.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return List.generate(
      sortedEntries.length,
      (index) => FlSpot(
        index.toDouble(),
        sortedEntries[index].value,
      ),
    );
  }
}
