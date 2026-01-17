import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'product/init/app_init.dart';
import 'product/utility/theme/app_theme.dart';
import 'product/repositories/auth_repository.dart';
import 'product/repositories/birthday_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/auth/view/auth_view.dart';
import 'features/home/bloc/birthday_bloc.dart';
import 'features/navigation/main_navigation_view.dart';

Future<void> main() async {
  await AppInit.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr', 'TR'),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => BirthdayRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>())
                  ..add(const AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => BirthdayBloc(
              birthdayRepository: context.read<BirthdayRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Birthday Reminder',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.status == AuthStatus.loading ||
                  state.status == AuthStatus.initial) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (state.status == AuthStatus.authenticated) {
                return const MainNavigationView();
              }

              return const LoginView();
            },
          ),
        ),
      ),
    );
  }
}
