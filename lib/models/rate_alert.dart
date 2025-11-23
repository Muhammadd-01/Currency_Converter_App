import 'package:cloud_firestore/cloud_firestore.dart';

enum AlertCondition {
  above,
  below,
}

class RateAlert {
  final String id;
  final String baseCurrency;
  final String targetCurrency;
  final double threshold;
  final AlertCondition condition;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastTriggered;

  RateAlert({
    required this.id,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.threshold,
    required this.condition,
    this.isActive = true,
    required this.createdAt,
    this.lastTriggered,
  });

  factory RateAlert.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RateAlert(
      id: doc.id,
      baseCurrency: data['baseCurrency'] as String,
      targetCurrency: data['targetCurrency'] as String,
      threshold: (data['threshold'] as num).toDouble(),
      condition: AlertCondition.values.firstWhere(
        (e) => e.toString() == 'AlertCondition.${data['condition']}',
      ),
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastTriggered: data['lastTriggered'] != null
          ? (data['lastTriggered'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'threshold': threshold,
      'condition': condition.toString().split('.').last,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastTriggered':
          lastTriggered != null ? Timestamp.fromDate(lastTriggered!) : null,
    };
  }

  RateAlert copyWith({
    String? id,
    String? baseCurrency,
    String? targetCurrency,
    double? threshold,
    AlertCondition? condition,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastTriggered,
  }) {
    return RateAlert(
      id: id ?? this.id,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      threshold: threshold ?? this.threshold,
      condition: condition ?? this.condition,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastTriggered: lastTriggered ?? this.lastTriggered,
    );
  }

  String get conditionText {
    return condition == AlertCondition.above ? 'Above' : 'Below';
  }

  String get description {
    return 'Alert when $baseCurrency/$targetCurrency is $conditionText $threshold';
  }

  bool shouldTrigger(double currentRate) {
    if (!isActive) return false;

    if (condition == AlertCondition.above) {
      return currentRate >= threshold;
    } else {
      return currentRate <= threshold;
    }
  }
}
