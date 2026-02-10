import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for encrypting and decrypting sensitive data using AES-256-GCM.
///
/// This service provides client-side encryption where each user's data is encrypted
/// with a unique key derived from their userId and email. The encryption key is
/// securely stored on the device using Flutter Secure Storage.
///
/// Security features:
/// - AES-256-GCM encryption (authenticated encryption)
/// - PBKDF2 key derivation with 100,000 iterations
/// - Random IV (Initialization Vector) for each encryption
/// - Secure key storage using platform-specific secure storage
class EncryptionService {
  static const String _keyPrefix = 'encryption_key_';
  static const int _pbkdf2Iterations = 100000;
  static const int _keyLength = 32; // 256 bits

  final FlutterSecureStorage _secureStorage;

  EncryptionService({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Initializes the encryption key for a user.
  ///
  /// This should be called after user login to ensure the encryption key
  /// is available for encrypting/decrypting data.
  ///
  /// The key is derived from the user's ID and email using PBKDF2.
  Future<void> initializeUserKey(String userId, String userEmail) async {
    final keyId = _getKeyId(userId);

    // Check if key already exists
    final existingKey = await _secureStorage.read(key: keyId);
    if (existingKey != null) {
      return; // Key already initialized
    }

    // Derive encryption key from userId and email
    final key = _deriveKey(userId, userEmail);

    // Store the key securely
    await _secureStorage.write(
      key: keyId,
      value: base64Encode(key),
    );
  }

  /// Clears the encryption key for a user.
  ///
  /// This should be called during logout to remove the encryption key
  /// from secure storage.
  Future<void> clearUserKey(String userId) async {
    final keyId = _getKeyId(userId);
    await _secureStorage.delete(key: keyId);
  }

  /// Encrypts a string using AES-256-GCM.
  ///
  /// Returns the encrypted data as a base64-encoded string in the format:
  /// `iv:ciphertext`
  ///
  /// Throws [StateError] if the encryption key is not initialized.
  Future<String> encryptString(
    String plaintext,
    String userId,
    String userEmail,
  ) async {
    if (plaintext.isEmpty) {
      return '';
    }

    final key = await _getOrCreateKey(userId, userEmail);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.gcm),
    );

    // Generate random IV for this encryption
    final iv = encrypt.IV.fromSecureRandom(16);

    // Encrypt the data
    final encrypted = encrypter.encrypt(plaintext, iv: iv);

    // Return format: iv:ciphertext (both base64 encoded)
    return '${iv.base64}:${encrypted.base64}';
  }

  /// Decrypts a string that was encrypted with [encryptString].
  ///
  /// The [ciphertext] should be in the format: `iv:ciphertext`
  ///
  /// Throws [StateError] if the encryption key is not initialized.
  /// Throws [FormatException] if the ciphertext format is invalid.
  Future<String> decryptString(
    String ciphertext,
    String userId,
    String userEmail,
  ) async {
    if (ciphertext.isEmpty) {
      return '';
    }

    final parts = ciphertext.split(':');
    if (parts.length != 2) {
      throw const FormatException('Invalid ciphertext format');
    }

    final key = await _getOrCreateKey(userId, userEmail);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.gcm),
    );

    // Extract IV and encrypted data
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encrypted = encrypt.Encrypted.fromBase64(parts[1]);

    // Decrypt the data
    return encrypter.decrypt(encrypted, iv: iv);
  }

  /// Derives an encryption key from userId and userEmail using PBKDF2.
  Uint8List _deriveKey(String userId, String userEmail) {
    // Combine userId and email as the password
    final password = '$userId:$userEmail';

    // Use userId as salt (in production, consider using a more complex salt)
    final salt = utf8.encode(userId);

    // Derive key using PBKDF2
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac(sha256, []),
      iterations: _pbkdf2Iterations,
      bits: _keyLength * 8, // 256 bits
    );

    final keyBytes = pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );

    return Uint8List.fromList(keyBytes);
  }

  /// Gets the encryption key for a user, or creates it if it doesn't exist.
  Future<Uint8List> _getOrCreateKey(String userId, String userEmail) async {
    final keyId = _getKeyId(userId);

    // Try to get existing key
    final storedKey = await _secureStorage.read(key: keyId);

    if (storedKey != null) {
      return base64Decode(storedKey);
    }

    // Key doesn't exist, create it
    await initializeUserKey(userId, userEmail);

    final newStoredKey = await _secureStorage.read(key: keyId);
    if (newStoredKey == null) {
      throw StateError('Failed to initialize encryption key');
    }

    return base64Decode(newStoredKey);
  }

  /// Gets the storage key ID for a user's encryption key.
  String _getKeyId(String userId) => '$_keyPrefix$userId';
}

/// PBKDF2 implementation for key derivation.
class Pbkdf2 {
  final Hmac macAlgorithm;
  final int iterations;
  final int bits;

  Pbkdf2({
    required this.macAlgorithm,
    required this.iterations,
    required this.bits,
  });

  List<int> deriveKeyFromPassword({
    required String password,
    required List<int> nonce,
  }) {
    final passwordBytes = utf8.encode(password);
    final dkLen = (bits / 8).ceil();
    final hLen = 32; // SHA-256 output length
    final l = (dkLen / hLen).ceil();

    final key = <int>[];

    for (var i = 1; i <= l; i++) {
      final block = _computeBlock(passwordBytes, nonce, i);
      key.addAll(block);
    }

    return key.sublist(0, dkLen);
  }

  List<int> _computeBlock(List<int> password, List<int> salt, int blockIndex) {
    final hmac = Hmac(sha256, password);

    // U1 = PRF(password, salt || INT(i))
    final blockIndexBytes = [
      (blockIndex >> 24) & 0xff,
      (blockIndex >> 16) & 0xff,
      (blockIndex >> 8) & 0xff,
      blockIndex & 0xff,
    ];

    var u = hmac.convert([...salt, ...blockIndexBytes]).bytes;
    final result = List<int>.from(u);

    // U2 through Uc
    for (var i = 1; i < iterations; i++) {
      u = hmac.convert(u).bytes;
      for (var j = 0; j < result.length; j++) {
        result[j] ^= u[j];
      }
    }

    return result;
  }
}
