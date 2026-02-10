import 'package:auto_route/auto_route.dart';
import 'package:birthday_reminder/product/navigation/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
/// App router configuration class for the application.
/// Defines the routes and their corresponding views.
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: AuthWrapperRoute.page,
      initial: true,
      children: [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: BirthdayFormRoute.page),
      ],
    ),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
  ];
}
