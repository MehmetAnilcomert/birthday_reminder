import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../product/repositories/birthday_repository.dart';
import '../../../product/models/birthday_model.dart';
import 'birthday_event.dart';
import 'birthday_state.dart';

class BirthdayBloc extends Bloc<BirthdayEvent, BirthdayState> {
  final BirthdayRepository _birthdayRepository;

  BirthdayBloc({required BirthdayRepository birthdayRepository})
    : _birthdayRepository = birthdayRepository,
      super(const BirthdayState()) {
    on<BirthdayLoadRequested>(_onBirthdayLoadRequested);
    on<BirthdayAddRequested>(_onBirthdayAddRequested);
    on<BirthdayUpdateRequested>(_onBirthdayUpdateRequested);
    on<BirthdayDeleteRequested>(_onBirthdayDeleteRequested);
    on<BirthdaySearchQueryChanged>(_onBirthdaySearchQueryChanged);
  }

  Future<void> _onBirthdayLoadRequested(
    BirthdayLoadRequested event,
    Emitter<BirthdayState> emit,
  ) async {
    emit(state.copyWith(status: BirthdayStatus.loading));

    final result = await _birthdayRepository.getBirthdays(event.userId);

    result.fold(
      (error) => emit(
        state.copyWith(status: BirthdayStatus.error, errorMessage: error),
      ),
      (birthdays) {
        final sortedBirthdays = _sortBirthdaysByUpcoming(birthdays);
        emit(
          state.copyWith(
            status: BirthdayStatus.success,
            birthdays: sortedBirthdays,
            filteredBirthdays: sortedBirthdays,
          ),
        );
      },
    );
  }

  Future<void> _onBirthdayAddRequested(
    BirthdayAddRequested event,
    Emitter<BirthdayState> emit,
  ) async {
    final result = await _birthdayRepository.addBirthday(event.birthday);

    result.fold(
      (error) => emit(
        state.copyWith(status: BirthdayStatus.error, errorMessage: error),
      ),
      (birthday) {
        final updatedBirthdays = [...state.birthdays, birthday];
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

  Future<void> _onBirthdayUpdateRequested(
    BirthdayUpdateRequested event,
    Emitter<BirthdayState> emit,
  ) async {
    final result = await _birthdayRepository.updateBirthday(event.birthday);

    result.fold(
      (error) => emit(
        state.copyWith(status: BirthdayStatus.error, errorMessage: error),
      ),
      (birthday) {
        final updatedBirthdays = state.birthdays
            .map((b) => b.id == birthday.id ? birthday : b)
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

  Future<void> _onBirthdayDeleteRequested(
    BirthdayDeleteRequested event,
    Emitter<BirthdayState> emit,
  ) async {
    final result = await _birthdayRepository.deleteBirthday(event.birthdayId);

    result.fold(
      (error) => emit(
        state.copyWith(status: BirthdayStatus.error, errorMessage: error),
      ),
      (_) {
        final updatedBirthdays = state.birthdays
            .where((b) => b.id != event.birthdayId)
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

  void _onBirthdaySearchQueryChanged(
    BirthdaySearchQueryChanged event,
    Emitter<BirthdayState> emit,
  ) {
    final filtered = _filterBirthdays(state.birthdays, event.query);
    emit(state.copyWith(searchQuery: event.query, filteredBirthdays: filtered));
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
    final sorted = List<BirthdayModel>.from(birthdays);
    sorted.sort(
      (a, b) => a.daysUntilBirthday().compareTo(b.daysUntilBirthday()),
    );
    return sorted;
  }
}
