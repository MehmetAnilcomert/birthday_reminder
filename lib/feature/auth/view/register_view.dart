import 'package:auto_route/auto_route.dart';
import 'package:birthday_reminder/feature/auth/view/mixin/register_view_mixin.dart';
import 'package:birthday_reminder/feature/auth/view/widget/auth_background.dart';
import 'package:birthday_reminder/feature/auth/view/widget/auth_text_field.dart';
import 'package:birthday_reminder/product/navigation/app_router.gr.dart';
import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/feature/auth/view_model/auth_view_model.dart';
import 'package:birthday_reminder/feature/auth/view_model/state/auth_state.dart';
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
/// Register view.
class RegisterView extends StatefulWidget {
  /// Register view.
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends BaseState<RegisterView>
    with ErrorTranslator, RegisterViewMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthViewModel, AuthState>(
      listener: (context, state) async {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? LocaleKeys.error.tr()),
              backgroundColor: context.general.colorScheme.error,
            ),
          );
        } else if (state.status == AuthStatus.authenticated) {
          await context.router.replace(const HomeRoute());
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
                        LocaleKeys.register.tr(),
                        style: context.general.textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.general.colorScheme.primary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: ProductPadding.large),
                      AuthTextField(
                        controller: nameController,
                        labelText: LocaleKeys.name.tr(),
                        prefixIcon: Icons.person,
                        validator: (value) =>
                            translateError(Validators.requiredValidator(value)),
                      ),
                      const SizedBox(height: ProductPadding.medium),
                      AuthTextField(
                        controller: surnameController,
                        labelText: LocaleKeys.surname.tr(),
                        prefixIcon: Icons.person_outline,
                        validator: (value) =>
                            translateError(Validators.requiredValidator(value)),
                      ),
                      const SizedBox(height: ProductPadding.medium),
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
                        controller: birthdayController,
                        labelText: LocaleKeys.birthday.tr(),
                        prefixIcon: Icons.cake,
                        readOnly: true,
                        onTap: () => selectBirthday(context),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => selectBirthday(context),
                        ),
                        validator: (value) =>
                            translateError(Validators.birthdayValidator(value)),
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
                      const SizedBox(height: ProductPadding.medium),
                      AuthTextField(
                        controller: confirmPasswordController,
                        labelText: LocaleKeys.confirm_password.tr(),
                        prefixIcon: Icons.lock,
                        obscureText: obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: toggleObscureConfirmPassword,
                        ),
                        validator: (value) => translateError(
                          Validators.confirmPasswordValidator(
                            value,
                            passwordController.text,
                          ),
                        ),
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
                            : handleRegister,
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
                                LocaleKeys.register.tr(),
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
                          context.router.back();
                        },
                        child: Text(
                          LocaleKeys.login.tr(),
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
