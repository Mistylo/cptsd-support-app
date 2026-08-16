import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityService {
  final FlutterSecureStorage _storage;

  // Keys used to store the PIN hash and salt.
  static const String _keyPinHash = 'security_pin_hash';
  static const String _keyPinSalt = 'security_pin_salt';

  SecurityService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  // Check whether the user has already set a PIN.
  Future<bool> hasPIN() async {
    final hash = await _storage.read(key: _keyPinHash);
    return hash != null && hash.isNotEmpty;
  }

  // Save a new PIN as a salted hash instead of storing the PIN itself.
  Future<bool> setPIN(String newPin) async {
    // Generate a new random salt for the PIN.
    final salt = _generateSalt();

    // Create a hash using the PIN and salt.
    final hash = _hashPin(newPin, salt);

    // Store the salt and hash in secure storage.
    await _storage.write(key: _keyPinSalt, value: salt);
    await _storage.write(key: _keyPinHash, value: hash);

    return true;
  }

  // Check whether the entered PIN matches the saved PIN.
  Future<bool> verifyPIN(String inputPin) async {
    final savedHash = await _storage.read(key: _keyPinHash);
    final savedSalt = await _storage.read(key: _keyPinSalt);

    // Return false if no PIN has been saved.
    if (savedHash == null || savedSalt == null) {
      return false;
    }

    // Hash the entered PIN using the same salt.
    final inputHash = _hashPin(inputPin, savedSalt);

    // Compare the two hashes.
    return _constantTimeEquals(inputHash, savedHash);
  }

  // Remove the saved PIN when PIN lock is disabled.
  Future<void> clearPIN() async {
    await _storage.delete(key: _keyPinHash);
    await _storage.delete(key: _keyPinSalt);
  }

  // Create a SHA-256 hash from the PIN and its salt.
  String _hashPin(String pin, String salt) {
    final bytes = utf8.encode('$salt:$pin');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Generate a random 16 byte salt.
  String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(
      16,
      (_) => random.nextInt(256),
    );
    return base64Url.encode(saltBytes);
  }

  // Compare two hashes without stopping early when a difference is found.
  bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;

    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }

    return result == 0;
  }
}