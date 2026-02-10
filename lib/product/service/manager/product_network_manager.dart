import 'dart:io';

import 'package:birthday_reminder/product/init/config/prod_environment.dart';
import 'package:flutter/material.dart';
import 'package:vexana/vexana.dart';

/// A class responsible for managing product network functionalities.
class ProductNetworkManager extends NetworkManager<EmptyModel> {
  /// Creates an instance of [ProductNetworkManager] with the provided [NetworkOptions].
  ProductNetworkManager.base()
    : super(options: BaseOptions(baseUrl: EnvironmentItems.baseUrl.value));

  /// Handle error
  void listenErrorStatus({required ValueChanged<int> onErrorStatus}) {
    interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          onErrorStatus(error.response?.statusCode ?? HttpStatus.notFound);
          return handler.next(error);
        },
      ),
    );
  }
}
