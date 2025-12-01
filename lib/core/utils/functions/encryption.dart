import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class MySecureEncryption {
  // 🔐 مفتاح ثابت قوي 32 حرف
  static const _staticKey = '9fG3kR7pQzVb2XnL8sY4wHcT1mU0aEj5';

  IV _generateIv() => IV.fromLength(16);

  /// تشفير النص
  Future<String> encrypt(String plainText) async {
    try {
      final key = Key.fromUtf8(_staticKey);
      final iv = _generateIv();
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
      final encrypted = encrypter.encrypt(plainText, iv: iv);

      // 🧠 حول الناتج إلى base64UrlSafe علشان يبقى صالح للـ API
      final ivEncoded = base64UrlEncode(iv.bytes);
      final encryptedEncoded = base64UrlEncode(encrypted.bytes);

      return '$ivEncoded:$encryptedEncoded';
    } catch (e) {
      print('❌ Encryption failed: $e');
      return plainText;
    }
  }

  /// فك التشفير
  Future<String> decrypt(String encryptedText) async {
    try {
      final key = Key.fromUtf8(_staticKey);
      final parts = encryptedText.split(':');
      final iv = IV(base64Url.decode(parts[0]));
      final encrypted = Encrypted(base64Url.decode(parts[1]));
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));

      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      print('❌ Decryption failed: $e');
      return encryptedText;
    }
  }
}
