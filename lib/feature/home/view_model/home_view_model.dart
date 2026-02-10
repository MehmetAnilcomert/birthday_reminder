import 'package:birthday_reminder/feature/home/view_model/state/home_state.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:birthday_reminder/product/repositories/birthday_repository.dart';
import 'package:birthday_reminder/product/state/base/base_cubit.dart';

/// A ViewModel for managing home screen state (birthdays).
final class HomeViewModel extends BaseCubit<HomeState> {
  /// Creates an instance of [HomeViewModel].
  HomeViewModel() : super(const HomeState()) {
    _birthdayRepository = BirthdayRepository();
  }

  late final BirthdayRepository _birthdayRepository;

  Future<void> loadBirthdays(String userId, String userEmail) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final result = await _birthdayRepository.getBirthdays(userId, userEmail);

    result.fold(
      (error) =>
          emit(state.copyWith(status: HomeStatus.error, errorMessage: error)),
      (birthdays) {
        final sortedBirthdays = _sortBirthdaysByUpcoming(birthdays);
        emit(
          state.copyWith(
            status: HomeStatus.success,
            birthdays: sortedBirthdays,
            filteredBirthdays: _filterBirthdays(
              sortedBirthdays,
              state.searchQuery,
            ),
          ),
        );
      },
    );
  }

  Future<void> addBirthday(BirthdayModel birthday, String userEmail) async {
    // Optimistic update or wait? Current impl waits.
    final result = await _birthdayRepository.addBirthday(birthday, userEmail);

    result.fold(
      (error) =>
          emit(state.copyWith(status: HomeStatus.error, errorMessage: error)),
      (newBirthday) {
        final updatedBirthdays = [...state.birthdays, newBirthday];
        final sortedBirthdays = _sortBirthdaysByUpcoming(updatedBirthdays);
        emit(
          state.copyWith(
            birthdays: sortedBirthdays,
            filteredBirthdays: _filterBirthdays(
              sortedBirthdays,
              state.searchQuery,
            ),
          ),
        );
      },
    );
  }

  Future<void> updateBirthday(BirthdayModel birthday, String userEmail) async {
    final result = await _birthdayRepository.updateBirthday(
      birthday,
      userEmail,
    );

    result.fold(
      (error) =>
          emit(state.copyWith(status: HomeStatus.error, errorMessage: error)),
      (updatedBirthday) {
        final updatedBirthdays = state.birthdays
            .map((b) => b.id == updatedBirthday.id ? updatedBirthday : b)
            .toList();
        final sortedBirthdays = _sortBirthdaysByUpcoming(updatedBirthdays);
        emit(
          state.copyWith(
            birthdays: sortedBirthdays,
            filteredBirthdays: _filterBirthdays(
              sortedBirthdays,
              state.searchQuery,
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteBirthday(String birthdayId) async {
    final result = await _birthdayRepository.deleteBirthday(birthdayId);

    result.fold(
      (error) =>
          emit(state.copyWith(status: HomeStatus.error, errorMessage: error)),
      (_) {
        final updatedBirthdays = state.birthdays
            .where((b) => b.id != birthdayId)
            .toList();
        emit(
          state.copyWith(
            birthdays: updatedBirthdays,
            filteredBirthdays: _filterBirthdays(
              updatedBirthdays,
              state.searchQuery,
            ),
          ),
        );
      },
    );
  }

  void updateSearchQuery(String query) {
    final filtered = _filterBirthdays(state.birthdays, query);
    emit(state.copyWith(searchQuery: query, filteredBirthdays: filtered));
  }

  List<BirthdayModel> _filterBirthdays(
    List<BirthdayModel> birthdays,
    String query,
  ) {
    if (query.isEmpty) return birthdays;

    return birthdays.where((birthday) {
      final fullName = birthday.fullName.toLowerCase();
      final searchQuery = query.toLowerCase();
      return fullName.contains(searchQuery);
    }).toList();
  }

  List<BirthdayModel> _sortBirthdaysByUpcoming(List<BirthdayModel> birthdays) {
    final sorted = List<BirthdayModel>.from(birthdays)
      ..sort(
        (a, b) => a.daysUntilBirthday().compareTo(b.daysUntilBirthday()),
      );
    return sorted;
  }
}
