import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:birthday_reminder/product/models/user_model.dart';
import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:birthday_reminder/product/cache/product_preferences.dart';
import 'dart:convert';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Either<String, UserModel>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return const Left('Kullanıcı oluşturulamadı');
      }

      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.id).set(user.toJson());

      await ProductStateItems.productPreferences.setString(
        ProductPreferencesKeys.user,
        jsonEncode(user.toJson()),
      );

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_getErrorMessage(e.code));
    } catch (e) {
      return Left('Bir hata oluştu: $e');
    }
  }

  Future<Either<String, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return const Left('Giriş yapılamadı');
      }

      final doc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!doc.exists) {
        return const Left('Kullanıcı bulunamadı');
      }

      final user = UserModel.fromJson(doc.data()!);
      await ProductStateItems.productPreferences.setString(
        ProductPreferencesKeys.user,
        jsonEncode(user.toJson()),
      );

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_getErrorMessage(e.code));
    } catch (e) {
      return Left('Bir hata oluştu: $e');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await ProductStateItems.productPreferences.clear();
  }

  UserModel? getCachedUser() {
    final userJson = ProductStateItems.productPreferences.getString(
      ProductPreferencesKeys.user,
    );
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  bool isUserLoggedIn() {
    return currentUser != null || getCachedUser() != null;
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Kullanıcı bulunamadı';
      case 'wrong-password':
        return 'Hatalı şifre';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanımda';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi';
      case 'weak-password':
        return 'Şifre çok zayıf';
      default:
        return 'Bir hata oluştu';
    }
  }

  Future<void> updateFcmToken(String userId, String token) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Log error but don't fail the app
      print('Error updating FCM token: $e');
    }
  }
}
