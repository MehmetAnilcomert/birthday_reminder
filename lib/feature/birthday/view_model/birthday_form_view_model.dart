import 'package:birthday_reminder/feature/birthday/view_model/state/birthday_form_state.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:birthday_reminder/product/repositories/birthday_repository.dart';
import 'package:birthday_reminder/product/service/ai_service/abstract_ai_service.dart';
import 'package:birthday_reminder/product/service/ai_service/gemini_service.dart';
import 'package:birthday_reminder/product/state/base/base_cubit.dart';

/// A ViewModel for managing birthday form state.
final class BirthdayFormViewModel extends BaseCubit<BirthdayFormState> {
  /// Creates an instance of [BirthdayFormViewModel].
  BirthdayFormViewModel() : super(const BirthdayFormState()) {
    _birthdayRepository = BirthdayRepository();
    _aiService = GeminiService();
  }

  late final BirthdayRepository _birthdayRepository;
  late final IAiService _aiService;

  /// Suggests a birthday greeting message using AI.
  Future<void> suggestGreeting({
    required String name,
    required String surname,
    required String relationship,
  }) async {
    emit(state.copyWith(aiLoading: true));

    final message = await _aiService.generateGreeting(
      name: name,
      surname: surname,
      relationship: relationship,
    );

    if (message != null) {
      emit(state.copyWith(aiLoading: false, generatedMessage: message));
    } else {
      emit(
        state.copyWith(
          aiLoading: false,
          errorMessage: 'Mesaj önerisi alınamadı.',
        ),
      );
    }
  }

  Future<void> addBirthday(BirthdayModel birthday, String userEmail) async {
    emit(state.copyWith(status: BirthdayFormStatus.loading));

    final result = await _birthdayRepository.addBirthday(birthday, userEmail);

    result.fold(
      (error) => emit(
        state.copyWith(status: BirthdayFormStatus.error, errorMessage: error),
      ),
      (_) => emit(state.copyWith(status: BirthdayFormStatus.success)),
    );
  }

  Future<void> updateBirthday(BirthdayModel birthday, String userEmail) async {
    emit(state.copyWith(status: BirthdayFormStatus.loading));

    final result = await _birthdayRepository.updateBirthday(
      birthday,
      userEmail,
    );

    result.fold(
      (error) => emit(
        state.copyWith(status: BirthdayFormStatus.error, errorMessage: error),
      ),
      (_) => emit(state.copyWith(status: BirthdayFormStatus.success)),
    );
  }
}
