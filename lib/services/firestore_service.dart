import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/history.dart';
import '../models/rate_alert.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== Conversion History ====================

  // Add conversion to history
  Future<void> addConversionHistory({
    required String userId,
    required String baseCurrency,
    required String targetCurrency,
    required double rate,
    required double amount,
    required double convertedAmount,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .add({
        'baseCurrency': baseCurrency,
        'targetCurrency': targetCurrency,
        'rate': rate,
        'amount': amount,
        'convertedAmount': convertedAmount,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add conversion history: $e');
    }
  }

  // Get conversion history stream
  Stream<List<ConversionHistory>> getConversionHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ConversionHistory.fromFirestore(doc);
      }).toList();
    });
  }

  // Delete conversion history item
  Future<void> deleteConversionHistory({
    required String userId,
    required String historyId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .doc(historyId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete conversion history: $e');
    }
  }

  // Clear all conversion history
  Future<void> clearAllHistory(String userId) async {
    try {
      final batch = _firestore.batch();
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear history: $e');
    }
  }

  // ==================== Rate Alerts ====================

  // Add rate alert
  Future<void> addRateAlert({
    required String userId,
    required String baseCurrency,
    required String targetCurrency,
    required double threshold,
    required AlertCondition condition,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('alerts')
          .add({
        'baseCurrency': baseCurrency,
        'targetCurrency': targetCurrency,
        'threshold': threshold,
        'condition': condition.toString().split('.').last,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'lastTriggered': null,
      });
    } catch (e) {
      throw Exception('Failed to add rate alert: $e');
    }
  }

  // Get rate alerts stream
  Stream<List<RateAlert>> getRateAlerts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('alerts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RateAlert.fromFirestore(doc);
      }).toList();
    });
  }

  // Update rate alert
  Future<void> updateRateAlert({
    required String userId,
    required String alertId,
    bool? isActive,
    DateTime? lastTriggered,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (isActive != null) updates['isActive'] = isActive;
      if (lastTriggered != null) {
        updates['lastTriggered'] = Timestamp.fromDate(lastTriggered);
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('alerts')
          .doc(alertId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update rate alert: $e');
    }
  }

  // Delete rate alert
  Future<void> deleteRateAlert({
    required String userId,
    required String alertId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('alerts')
          .doc(alertId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete rate alert: $e');
    }
  }

  // ==================== User Preferences ====================

  // Save user preferences
  Future<void> savePreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('settings')
          .set(preferences, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save preferences: $e');
    }
  }

  // Get user preferences
  Future<Map<String, dynamic>?> getPreferences(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('settings')
          .get();

      return doc.data();
    } catch (e) {
      throw Exception('Failed to get preferences: $e');
    }
  }

  // Get user preferences stream
  Stream<Map<String, dynamic>?> getPreferencesStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('settings')
        .snapshots()
        .map((doc) => doc.data());
  }

  // ==================== Feedback ====================

  // Submit feedback
  Future<void> submitFeedback({
    required String userId,
    required String email,
    required String message,
    int? rating,
  }) async {
    try {
      await _firestore.collection('feedback').add({
        'userId': userId,
        'email': email,
        'message': message,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to submit feedback: $e');
    }
  }

  // Submit issue report
  Future<void> submitIssue({
    required String userId,
    required String email,
    required String subject,
    required String description,
  }) async {
    try {
      await _firestore.collection('issues').add({
        'userId': userId,
        'email': email,
        'subject': subject,
        'description': description,
        'status': 'open',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to submit issue: $e');
    }
  }

  // ==================== User Profile ====================

  // Create or update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? email,
    String? photoURL,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      if (displayName != null) data['displayName'] = displayName;
      if (email != null) data['email'] = email;
      if (photoURL != null) data['photoURL'] = photoURL;

      await _firestore
          .collection('users')
          .doc(userId)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }
}
