import 'package:birthday_reminder/product/service/manager/product_network_manager.dart';
import 'package:birthday_reminder/product/state/view_model/product_view_model.dart';
import 'package:birthday_reminder/feature/auth/view_model/auth_view_model.dart';
import 'package:birthday_reminder/product/cache/product_preferences.dart';
import 'package:get_it/get_it.dart';

/// A container class for managing product state instances.
/// This class utilizes the GetIt package for dependency injection,
final class ProductContainer {
  ProductContainer._();

  /// the service locator for dependency injection.
  static final GetIt _getit = GetIt.I;

  /// Sets up the necessary dependencies for the product state container.
  static void setUp() {
    _getit
      ..registerSingleton(ProductNetworkManager.base())
      ..registerSingleton(ProductPreferences())
      ..registerLazySingleton(ProductViewModel.new)
      ..registerLazySingleton(AuthViewModel.new);
  }

  /// Reads an instance of type [T] from the service locator then returns it.
  static T read<T extends Object>() => _getit<T>();
}
