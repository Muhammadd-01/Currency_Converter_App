import 'package:cloud_firestore/cloud_firestore.dart';

class ConversionHistory {
  final String id;
  final String baseCurrency;
  final String targetCurrency;
  final double rate;
  final double amount;
  final double convertedAmount;
  final DateTime timestamp;

  ConversionHistory({
    required this.id,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.amount,
    required this.convertedAmount,
    required this.timestamp,
  });

  factory ConversionHistory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConversionHistory(
      id: doc.id,
      baseCurrency: data['baseCurrency'] as String,
      targetCurrency: data['targetCurrency'] as String,
      rate: (data['rate'] as num).toDouble(),
      amount: (data['amount'] as num).toDouble(),
      convertedAmount: (data['convertedAmount'] as num).toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'rate': rate,
      'amount': amount,
      'convertedAmount': convertedAmount,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory ConversionHistory.fromJson(Map<String, dynamic> json) {
    return ConversionHistory(
      id: json['id'] as String,
      baseCurrency: json['baseCurrency'] as String,
      targetCurrency: json['targetCurrency'] as String,
      rate: (json['rate'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      convertedAmount: (json['convertedAmount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'rate': rate,
      'amount': amount,
      'convertedAmount': convertedAmount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
