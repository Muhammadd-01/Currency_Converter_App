import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyApiService {
  // Using exchangerate.host - free API, no key required
  static const String _baseUrl = 'https://api.exchangerate.host';

  // Alternative: OpenExchangeRates (requires API key)
  // static const String _baseUrl = 'https://openexchangerates.org/api';
  // static const String _apiKey = 'YOUR_API_KEY_HERE';

  // Get latest exchange rates
  Future<Map<String, double>> getExchangeRates({
    required String baseCurrency,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/latest?base=$baseCurrency'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        return rates.map((key, value) => MapEntry(
              key,
              (value as num).toDouble(),
            ));
      } else {
        throw Exception(
            'Failed to load exchange rates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rates: $e');
    }
  }

  // Get specific exchange rate
  Future<double> getExchangeRate({
    required String baseCurrency,
    required String targetCurrency,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/latest?base=$baseCurrency&symbols=$targetCurrency'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        return (rates[targetCurrency] as num).toDouble();
      } else {
        throw Exception('Failed to load exchange rate: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rate: $e');
    }
  }

  // Convert amount
  Future<double> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/convert?from=$from&to=$to&amount=$amount'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['result'] as num).toDouble();
      } else {
        throw Exception('Failed to convert currency: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error converting currency: $e');
    }
  }

  // Get historical rates for charts
  Future<Map<String, double>> getHistoricalRates({
    required String baseCurrency,
    required String targetCurrency,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final start = _formatDate(startDate);
      final end = _formatDate(endDate);

      final response = await http.get(
        Uri.parse(
          '$_baseUrl/timeseries?start_date=$start&end_date=$end&base=$baseCurrency&symbols=$targetCurrency',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        final Map<String, double> historicalRates = {};
        rates.forEach((date, rateData) {
          final rateMap = rateData as Map<String, dynamic>;
          historicalRates[date] = (rateMap[targetCurrency] as num).toDouble();
        });

        return historicalRates;
      } else {
        throw Exception(
            'Failed to load historical rates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching historical rates: $e');
    }
  }

  // Get historical rates for specific period (7, 30, or 90 days)
  Future<Map<String, double>> getHistoricalRatesForPeriod({
    required String baseCurrency,
    required String targetCurrency,
    required int days,
  }) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));

    return getHistoricalRates(
      baseCurrency: baseCurrency,
      targetCurrency: targetCurrency,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // Get all available currencies
  Future<List<String>> getAvailableCurrencies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/symbols'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final symbols = data['symbols'] as Map<String, dynamic>;
        return symbols.keys.toList();
      } else {
        throw Exception('Failed to load currencies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching currencies: $e');
    }
  }

  // Format date for API
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Calculate percentage change
  double calculatePercentageChange(double oldRate, double newRate) {
    return ((newRate - oldRate) / oldRate) * 100;
  }

  // Format currency amount
  String formatCurrencyAmount(double amount, String currencyCode) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)}K';
    } else {
      return amount.toStringAsFixed(2);
    }
  }
}
