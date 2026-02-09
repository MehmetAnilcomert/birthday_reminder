import 'package:equatable/equatable.dart';

enum BirthdayFormStatus { initial, loading, success, error }

final class BirthdayFormState extends Equatable {
  const BirthdayFormState({
    this.status = BirthdayFormStatus.initial,
    this.errorMessage,
  });

  final BirthdayFormStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];

  BirthdayFormState copyWith({
    BirthdayFormStatus? status,
    String? errorMessage,
  }) {
    return BirthdayFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
