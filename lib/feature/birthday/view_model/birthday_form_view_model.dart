import 'package:birthday_reminder/feature/birthday/view_model/state/birthday_form_state.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:birthday_reminder/product/repositories/birthday_repository.dart';
import 'package:birthday_reminder/product/state/base/base_cubit.dart';

/// A ViewModel for managing birthday form state.
final class BirthdayFormViewModel extends BaseCubit<BirthdayFormState> {
  /// Creates an instance of [BirthdayFormViewModel].
  BirthdayFormViewModel() : super(const BirthdayFormState()) {
    _birthdayRepository = BirthdayRepository();
  }

  late final BirthdayRepository _birthdayRepository;

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
