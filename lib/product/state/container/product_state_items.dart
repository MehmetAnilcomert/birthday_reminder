import 'package:birthday_reminder/product/service/manager/product_network_manager.dart';
import 'package:birthday_reminder/product/state/container/product_state_container.dart';
import 'package:birthday_reminder/product/state/view_model/product_view_model.dart';
import 'package:birthday_reminder/feature/auth/view_model/auth_view_model.dart';
import 'package:birthday_reminder/product/cache/product_preferences.dart';

/// A class that provides access to various product state items.
/// This class acts as a centralized point to retrieve instances
/// of different state-related items used in the product module.
/// For example, it provides access to the [ProductNetworkManager].
final class ProductStateItems {
  /// Creates an instance of [ProductStateItems].
  const ProductStateItems._();

  /// Provides access to the [ProductNetworkManager] instance.
  static ProductNetworkManager get networkManager =>
      ProductContainer.read<ProductNetworkManager>();

  static ProductViewModel get productViewModel =>
      ProductContainer.read<ProductViewModel>();

  static AuthViewModel get authViewModel =>
      ProductContainer.read<AuthViewModel>();

  /// Provides access to the [ProductPreferences] instance.
  static ProductPreferences get productPreferences =>
      ProductContainer.read<ProductPreferences>();
}
