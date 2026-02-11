import 'package:birthday_reminder/feature/auth/view/register_view.dart';
import 'package:birthday_reminder/feature/auth/view_model/auth_view_model.dart';
import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/product/state/base/base_state.dart';
import 'package:birthday_reminder/product/utility/mixin/error_translator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

mixin RegisterViewMixin on BaseState<RegisterView>, ErrorTranslator {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final birthdayController = TextEditingController();
  DateTime? selectedBirthday;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  void toggleObscurePassword() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  void toggleObscureConfirmPassword() {
    setState(() {
      obscureConfirmPassword = !obscureConfirmPassword;
    });
  }

  Future<void> selectBirthday(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: LocaleKeys.birthday.tr(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: context.general.colorScheme,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedBirthday) {
      setState(() {
        selectedBirthday = picked;
        birthdayController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> handleRegister() async {
    if (formKey.currentState!.validate()) {
      await context.read<AuthViewModel>().signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
        surname: surnameController.text.trim(),
        birthday: selectedBirthday,
      );
    }
  }
}
