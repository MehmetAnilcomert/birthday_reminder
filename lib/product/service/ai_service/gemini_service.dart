import 'package:birthday_reminder/product/service/ai_service/abstract_ai_service.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:logger/logger.dart';

/// Service for interacting with Gemini AI to generate birthday greetings.
final class GeminiService implements IAiService {
  GeminiService() {
    _model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash-lite',
    );
  }

  late final GenerativeModel _model;
  final _logger = Logger();

  /// Generates a birthday greeting message based on person's information.
  ///
  /// [name] The person's name.
  /// [surname] The person's surname.
  /// [relationship] The relationship with the person.
  @override
  Future<String?> generateGreeting({
    required String name,
    required String surname,
    required String relationship,
  }) async {
    try {
      final prompt =
          'Kişinin adı: $name, soyadı: $surname, yakınlık bilgisi: $relationship. '
          'Bu bilgiler üzerinden samimi bir doğum günü tebrik mesajı yaz. 500 karakteri geçmesin. '
          'İçerisinde emoji kullanabilirsin. Güzel bir söz bulunsun. '
          'Cevapta sadece doğum günü mesajı olsun, başka hiçbir açıklama veya metin ekleme.';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!.trim();
      }
      return null;
    } catch (e) {
      _logger.e('GeminiService Error: $e');
      return null;
    }
  }
}
