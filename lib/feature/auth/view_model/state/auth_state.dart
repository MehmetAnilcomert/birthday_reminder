import 'package:birthday_reminder/product/models/user_model.dart';
import 'package:birthday_reminder/product/utility/constants/enums/auth_status.dart';
import 'package:equatable/equatable.dart';

/// Authentication state.
final class AuthState extends Equatable {
  /// Creates an instance of [AuthState].
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, user, errorMessage];

  /// Creates a copy of the current state with the given values.
  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}
