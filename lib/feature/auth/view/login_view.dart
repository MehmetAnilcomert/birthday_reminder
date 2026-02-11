import 'package:auto_route/auto_route.dart';
import 'package:birthday_reminder/feature/auth/view/mixin/login_view_mixin.dart';
import 'package:birthday_reminder/feature/auth/view/widget/auth_background.dart';
import 'package:birthday_reminder/feature/auth/view/widget/auth_text_field.dart';
import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/feature/auth/view_model/auth_view_model.dart';
import 'package:birthday_reminder/feature/auth/view_model/state/auth_state.dart';
import 'package:birthday_reminder/product/navigation/app_router.gr.dart';
import 'package:birthday_reminder/product/state/base/base_state.dart';
import 'package:birthday_reminder/product/utility/constants/enums/auth_status.dart';
import 'package:birthday_reminder/product/utility/constants/product_padding.dart';
import 'package:birthday_reminder/product/utility/mixin/error_translator.dart';
import 'package:birthday_reminder/product/utility/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

@RoutePage()
/// Login view.
class LoginView extends StatefulWidget {
  /// Login view.
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends BaseState<LoginView>
    with ErrorTranslator, LoginViewMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthViewModel, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? LocaleKeys.error.tr()),
              backgroundColor: context.general.colorScheme.error,
            ),
          );
        } else if (state.status == AuthStatus.authenticated) {
          context.router.replace(const HomeRoute());
        }
      },
      builder: (context, state) {
        return AuthBackground(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const ProductPadding.allMedium(),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.cake,
                        size: 80,
                        color: context.general.colorScheme.primary,
                      ),
                      const SizedBox(height: ProductPadding.medium),
                      Text(
                        LocaleKeys.app_name.tr(),
                        style: context.general.textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.general.colorScheme.primary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: ProductPadding.small),
                      Text(
                        LocaleKeys.welcome.tr(),
                        style: context.general.textTheme.bodyLarge?.copyWith(
                          color: context.general.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: ProductPadding.large),
                      AuthTextField(
                        controller: emailController,
                        labelText: LocaleKeys.email.tr(),
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            translateError(Validators.emailValidator(value)),
                      ),
                      const SizedBox(height: ProductPadding.medium),
                      AuthTextField(
                        controller: passwordController,
                        labelText: LocaleKeys.password.tr(),
                        prefixIcon: Icons.lock,
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: toggleObscurePassword,
                        ),
                        validator: (value) =>
                            translateError(Validators.passwordValidator(value)),
                      ),
                      const SizedBox(height: ProductPadding.normal),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.general.colorScheme.primary,
                          foregroundColor:
                              context.general.colorScheme.onPrimary,
                          padding:
                              const ProductPadding.symmetricVerticalMedium(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        onPressed: state.status == AuthStatus.loading
                            ? null
                            : handleLogin,
                        child: state.status == AuthStatus.loading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    context.general.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : Text(
                                LocaleKeys.login.tr(),
                                style: context.general.textTheme.titleMedium
                                    ?.copyWith(
                                      color:
                                          context.general.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                      ),
                      const SizedBox(height: ProductPadding.medium),
                      TextButton(
                        onPressed: () {
                          context.router.push(const RegisterRoute());
                        },
                        child: Text(
                          LocaleKeys.register.tr(),
                          style: TextStyle(
                            color: context.general.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
