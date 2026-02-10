import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:birthday_reminder/product/services/encryption_service.dart';
import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:birthday_reminder/product/cache/product_preferences.dart';
import 'dart:convert';

class BirthdayRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EncryptionService _encryptionService = EncryptionService();

  Future<Either<String, List<BirthdayModel>>> getBirthdays(
    String userId,
    String userEmail,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('birthdays')
          .where('userId', isEqualTo: userId)
          .get();

      final birthdays = <BirthdayModel>[];
      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          final birthday = await BirthdayModel.fromEncrypted(
            {...data, 'id': doc.id},
            _encryptionService,
            userId,
            userEmail,
          );
          birthdays.add(birthday);
        } catch (e) {
          // Skip documents that can't be decrypted
          continue;
        }
      }

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
    String userEmail,
  ) async {
    try {
      // Encrypt the data before saving
      final encryptedData = await birthday.toEncryptedJson(
        _encryptionService,
        birthday.userId,
        userEmail,
      );

      final docRef = await _firestore.collection('birthdays').add({
        ...encryptedData,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final newBirthday = birthday.copyWith(id: docRef.id);

      // Update cache
      await _addBirthdayToCache(newBirthday);

      return Right(newBirthday);
    } catch (e) {
      return Left('Doğum günü eklenemedi: $e');
    }
  }

  Future<Either<String, BirthdayModel>> updateBirthday(
    BirthdayModel birthday,
    String userEmail,
  ) async {
    try {
      // Encrypt the data before updating
      final encryptedData = await birthday.toEncryptedJson(
        _encryptionService,
        birthday.userId,
        userEmail,
      );

      await _firestore.collection('birthdays').doc(birthday.id).update({
        ...encryptedData,
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

  Stream<List<BirthdayModel>> birthdaysStream(
    String userId,
    String userEmail,
  ) {
    return _firestore
        .collection('birthdays')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap(
          (snapshot) async {
            final birthdays = <BirthdayModel>[];
            for (final doc in snapshot.docs) {
              try {
                final data = doc.data();
                final birthday = await BirthdayModel.fromEncrypted(
                  {...data, 'id': doc.id},
                  _encryptionService,
                  userId,
                  userEmail,
                );
                birthdays.add(birthday);
              } catch (e) {
                // Skip documents that can't be decrypted
                continue;
              }
            }
            return birthdays;
          },
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
      final List<dynamic> birthdaysJson = jsonDecode(cached) as List<dynamic>;
      return birthdaysJson
          .map((json) => BirthdayModel.fromJson(json as Map<String, dynamic>))
          .toList();
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
