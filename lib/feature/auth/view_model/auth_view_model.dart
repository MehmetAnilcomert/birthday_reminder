import 'package:birthday_reminder/feature/auth/view_model/state/auth_state.dart';
import 'package:birthday_reminder/product/repositories/auth_repository.dart';
import 'package:birthday_reminder/product/state/base/base_cubit.dart';

/// A ViewModel for managing authentication state.
final class AuthViewModel extends BaseCubit<AuthState> {
  /// Creates an instance of [AuthViewModel].
  AuthViewModel() : super(const AuthState()) {
    _authRepository = AuthRepository();
    _checkAuthStatus();
  }

  late final AuthRepository _authRepository;

  Future<void> _checkAuthStatus() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final cachedUser = _authRepository.getCachedUser();
    if (cachedUser != null || _authRepository.currentUser != null) {
      // If user is cached but current user is null?
      // AuthRepository check logic was: currentUser != null || getCachedUser() != null
      // But we should probably prefer currentUser or verify token.
      // For now, mirroring old logic roughly.
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user:
              cachedUser, // Might be null if only currentUser is set? Repo logic assumes cachedUser is source of truth for UserModel object.
        ),
      );
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.signIn(
      email: email,
      password: password,
    );

    result.fold(
      (error) =>
          emit(state.copyWith(status: AuthStatus.error, errorMessage: error)),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.signUp(
      email: email,
      password: password,
    );

    result.fold(
      (error) =>
          emit(state.copyWith(status: AuthStatus.error, errorMessage: error)),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }
}
