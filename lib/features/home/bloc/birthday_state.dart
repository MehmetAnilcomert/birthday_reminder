import 'package:equatable/equatable.dart';
import '../../../product/models/birthday_model.dart';

enum BirthdayStatus { initial, loading, success, error }

class BirthdayState extends Equatable {
  final BirthdayStatus status;
  final List<BirthdayModel> birthdays;
  final List<BirthdayModel> filteredBirthdays;
  final String? errorMessage;
  final String searchQuery;

  const BirthdayState({
    this.status = BirthdayStatus.initial,
    this.birthdays = const [],
    this.filteredBirthdays = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  BirthdayState copyWith({
    BirthdayStatus? status,
    List<BirthdayModel>? birthdays,
    List<BirthdayModel>? filteredBirthdays,
    String? errorMessage,
    String? searchQuery,
  }) {
    return BirthdayState(
      status: status ?? this.status,
      birthdays: birthdays ?? this.birthdays,
      filteredBirthdays: filteredBirthdays ?? this.filteredBirthdays,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    status,
    birthdays,
    filteredBirthdays,
    errorMessage,
    searchQuery,
  ];
}
