import 'package:birthday_reminder/product/state/container/product_state_container.dart';
import 'package:birthday_reminder/product/service/notification/notification_service.dart';
import 'package:birthday_reminder/feature/auth/view_model/state/auth_state.dart';
import 'package:birthday_reminder/product/repositories/auth_repository.dart';
import 'package:birthday_reminder/product/state/base/base_cubit.dart';
import 'package:birthday_reminder/product/utility/constants/enums/auth_status.dart';

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
      emit(state.copyWith(status: AuthStatus.authenticated, user: cachedUser));
      if (cachedUser != null) {
        await _updateToken(cachedUser.id);
      }
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  /// Signs in a user with email and password.
  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));

    String? token;
    try {
      token = await ProductContainer.read<INotificationService>().getToken();
    } catch (_) {}

    final result = await _authRepository.signIn(
      email: email,
      password: password,
      currentFcmToken: token,
    );

    result.fold(
      (error) =>
          emit(state.copyWith(status: AuthStatus.error, errorMessage: error)),
      (user) {
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
        _updateToken(user.id);
      },
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    DateTime? birthday,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.signUp(
      email: email,
      password: password,
      birthday: birthday,
    );

    result.fold(
      (error) =>
          emit(state.copyWith(status: AuthStatus.error, errorMessage: error)),
      (user) {
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
        _updateToken(user.id);
      },
    );
  }

  Future<void> signOut() async {
    if (state.user != null) {
      await _authRepository.signOut(state.user!.id);
    }
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

  Future<void> _updateToken(String userId) async {
    try {
      final token = await ProductContainer.read<INotificationService>()
          .getToken();
      if (token != null) {
        await _authRepository.updateFcmToken(userId, token);
      }
    } catch (e) {
      // Log error
    }
  }
}
