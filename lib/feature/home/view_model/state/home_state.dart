import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, error }

final class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.birthdays = const [],
    this.filteredBirthdays = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  final HomeStatus status;
  final List<BirthdayModel> birthdays;
  final List<BirthdayModel> filteredBirthdays;
  final String? errorMessage;
  final String searchQuery;

  @override
  List<Object?> get props => [
    status,
    birthdays,
    filteredBirthdays,
    errorMessage,
    searchQuery,
  ];

  HomeState copyWith({
    HomeStatus? status,
    List<BirthdayModel>? birthdays,
    List<BirthdayModel>? filteredBirthdays,
    String? errorMessage,
    String? searchQuery,
  }) {
    return HomeState(
      status: status ?? this.status,
      birthdays: birthdays ?? this.birthdays,
      filteredBirthdays: filteredBirthdays ?? this.filteredBirthdays,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
