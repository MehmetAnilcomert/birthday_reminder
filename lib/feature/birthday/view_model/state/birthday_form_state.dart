import 'package:equatable/equatable.dart';

enum BirthdayFormStatus { initial, loading, success, error }

final class BirthdayFormState extends Equatable {
  const BirthdayFormState({
    this.status = BirthdayFormStatus.initial,
    this.errorMessage,
    this.aiLoading = false,
    this.generatedMessage,
  });

  final BirthdayFormStatus status;
  final String? errorMessage;
  final bool aiLoading;
  final String? generatedMessage;

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    aiLoading,
    generatedMessage,
  ];

  BirthdayFormState copyWith({
    BirthdayFormStatus? status,
    String? errorMessage,
    bool? aiLoading,
    String? generatedMessage,
  }) {
    return BirthdayFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      aiLoading: aiLoading ?? this.aiLoading,
      generatedMessage: generatedMessage ?? this.generatedMessage,
    );
  }
}
