import 'package:birthday_reminder/product/service/manager/product_network_manager.dart';
import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:birthday_reminder/product/state/view_model/product_view_model.dart';
import 'package:flutter/widgets.dart';

/// A base state class that provides common functionality for stateful widgets.
abstract class BaseState<T extends StatefulWidget> extends State<T> {
  /// Provides access to the [ProductNetworkManager] instance.
  ProductNetworkManager get networkManager => ProductStateItems.networkManager;

  /// Provides access to the [ProductViewModel] instance.
  ProductViewModel get productViewModel => ProductStateItems.productViewModel;
}
