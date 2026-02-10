import 'package:auto_route/auto_route.dart';
import 'package:birthday_reminder/product/navigation/app_router.gr.dart';
import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/feature/auth/view_model/auth_view_model.dart';
import 'package:birthday_reminder/feature/auth/view_model/state/auth_state.dart';
import 'package:birthday_reminder/product/state/base/base_state.dart';
import 'package:birthday_reminder/product/utility/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

@RoutePage()
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends BaseState<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthdayController = TextEditingController();
  DateTime? _selectedBirthday;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: LocaleKeys.birthday.tr(),
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
        _birthdayController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthViewModel>().signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        birthday: _selectedBirthday,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthViewModel, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? LocaleKeys.error.tr()),
                backgroundColor: context.general.colorScheme.error,
              ),
            );
          } else if (state.status == AuthStatus.authenticated) {
            // Navigate to Home
            context.router.replace(const HomeRoute());
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.cake,
                        size: 100,
                        color: context.general.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        LocaleKeys.register.tr(),
                        style: context.general.textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.general.colorScheme.primary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.email.tr(),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: Validators.emailValidator,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _birthdayController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.birthday.tr(),
                          prefixIcon: const Icon(Icons.cake),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectBirthday(context),
                          ),
                        ),
                        validator: Validators.birthdayValidator,
                        onTap: () => _selectBirthday(context),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.password.tr(),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: Validators.passwordValidator,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.confirm_password.tr(),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) =>
                            Validators.confirmPasswordValidator(
                              value,
                              _passwordController.text,
                            ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: state.status == AuthStatus.loading
                            ? null
                            : _handleRegister,
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
                            : Text(LocaleKeys.register.tr()),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          context.router.back();
                        },
                        child: Text(LocaleKeys.login.tr()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
