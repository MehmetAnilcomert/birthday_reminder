/// Interface for AI service operations.
abstract class IAiService {
  /// Generates a birthday greeting message.
  Future<String?> generateGreeting({
    required String name,
    required String surname,
    required String relationship,
  });
}
