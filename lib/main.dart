import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/product/init/product_initialize.dart';
import 'package:birthday_reminder/product/init/product_localization.dart';
import 'package:birthday_reminder/product/init/state_initialize.dart';
import 'package:birthday_reminder/product/init/theme/dark_theme/custom_dark_theme.dart';
import 'package:birthday_reminder/product/init/theme/light_theme/custom_light_theme.dart';
import 'package:birthday_reminder/product/navigation/app_router.dart';
import 'package:birthday_reminder/product/state/view_model/product_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  await ProductInitialize().startApplication();
  runApp(
    ProductLocalization(child: StateInitialize(child: BirthdayReminder())),
  );
}

/// The main application widget that sets up architecture project.
class BirthdayReminder extends StatelessWidget {
  /// Creates an instance of [BirthdayReminder].
  BirthdayReminder({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      title: LocaleKeys.app_name.tr(),
      theme: CustomLightTheme().themeData,
      darkTheme: CustomDarkTheme().themeData,
      themeMode: context.watch<ProductViewModel>().state.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
