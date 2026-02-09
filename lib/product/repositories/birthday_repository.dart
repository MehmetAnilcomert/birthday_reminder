import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:birthday_reminder/product/cache/product_preferences.dart';
import 'dart:convert';

class BirthdayRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<String, List<BirthdayModel>>> getBirthdays(
    String userId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('birthdays')
          .where('userId', isEqualTo: userId)
          .orderBy('birthdayDate')
          .get();

      final birthdays = snapshot.docs
          .map((doc) => BirthdayModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Cache the birthdays
      await _cacheBirthdays(birthdays);

      return Right(birthdays);
    } catch (e) {
      // Try to load from cache if network fails
      final cachedBirthdays = _getCachedBirthdays();
      if (cachedBirthdays != null) {
        return Right(cachedBirthdays);
      }
      return Left('Doğum günleri yüklenemedi: $e');
    }
  }

  Future<Either<String, BirthdayModel>> addBirthday(
    BirthdayModel birthday,
  ) async {
    try {
      final docRef = await _firestore.collection('birthdays').add({
        ...birthday.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      final doc = await docRef.get();
      final newBirthday = BirthdayModel.fromJson({
        ...doc.data()!,
        'id': doc.id,
      });

      // Update cache
      await _addBirthdayToCache(newBirthday);

      return Right(newBirthday);
    } catch (e) {
      return Left('Doğum günü eklenemedi: $e');
    }
  }

  Future<Either<String, BirthdayModel>> updateBirthday(
    BirthdayModel birthday,
  ) async {
    try {
      await _firestore.collection('birthdays').doc(birthday.id).update({
        ...birthday.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final updatedBirthday = birthday.copyWith(updatedAt: DateTime.now());

      // Update cache
      await _updateBirthdayInCache(updatedBirthday);

      return Right(updatedBirthday);
    } catch (e) {
      return Left('Doğum günü güncellenemedi: $e');
    }
  }

  Future<Either<String, void>> deleteBirthday(String birthdayId) async {
    try {
      await _firestore.collection('birthdays').doc(birthdayId).delete();

      // Update cache
      await _deleteBirthdayFromCache(birthdayId);

      return const Right(null);
    } catch (e) {
      return Left('Doğum günü silinemedi: $e');
    }
  }

  Stream<List<BirthdayModel>> birthdaysStream(String userId) {
    return _firestore
        .collection('birthdays')
        .where('userId', isEqualTo: userId)
        .orderBy('birthdayDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => BirthdayModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList(),
        );
  }

  // Cache methods
  Future<void> _cacheBirthdays(List<BirthdayModel> birthdays) async {
    final birthdaysJson = birthdays.map((b) => b.toJson()).toList();
    await ProductStateItems.productPreferences.setString(
      ProductPreferencesKeys.birthdays,
      jsonEncode(birthdaysJson),
    );
  }

  List<BirthdayModel>? _getCachedBirthdays() {
    final cached = ProductStateItems.productPreferences.getString(
      ProductPreferencesKeys.birthdays,
    );
    if (cached != null) {
      final List<dynamic> birthdaysJson = jsonDecode(cached);
      return birthdaysJson.map((json) => BirthdayModel.fromJson(json)).toList();
    }
    return null;
  }

  Future<void> _addBirthdayToCache(BirthdayModel birthday) async {
    final cached = _getCachedBirthdays() ?? [];
    cached.add(birthday);
    await _cacheBirthdays(cached);
  }

  Future<void> _updateBirthdayInCache(BirthdayModel birthday) async {
    final cached = _getCachedBirthdays() ?? [];
    final index = cached.indexWhere((b) => b.id == birthday.id);
    if (index != -1) {
      cached[index] = birthday;
      await _cacheBirthdays(cached);
    }
  }

  Future<void> _deleteBirthdayFromCache(String birthdayId) async {
    final cached = _getCachedBirthdays() ?? [];
    cached.removeWhere((b) => b.id == birthdayId);
    await _cacheBirthdays(cached);
  }
}
