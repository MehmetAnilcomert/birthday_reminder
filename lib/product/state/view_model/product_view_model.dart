import 'package:birthday_reminder/product/state/base/base_cubit.dart';
import 'package:birthday_reminder/product/state/view_model/product_state.dart';
import 'package:flutter/material.dart';

/// A ViewModel class for managing product-related state.
final class ProductViewModel extends BaseCubit<ProductState> {
  /// Creates an instance of [ProductViewModel] with the given initial state.
  ProductViewModel() : super(const ProductState());

  /// Changes the theme mode of the application.
  void changeThemeMode({required ThemeMode themeMode}) {
    emit(state.copyWith(themeMode: themeMode));
  }
}

