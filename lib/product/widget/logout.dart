import 'package:auto_route/auto_route.dart';
import 'package:birthday_reminder/product/navigation/app_router.gr.dart';
import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:birthday_reminder/product/utility/constants/product_padding.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

/// Logout button with logout icon and rounded corners
final class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.logout_rounded,
        color: context.general.colorScheme.onPrimary,
      ),
      onPressed: () async {
        await ProductStateItems.authViewModel.signOut();
        if (context.mounted) {
          await context.router.replaceAll([const LoginRoute()]);
        }
      },
      style: IconButton.styleFrom(
        backgroundColor: context.general.colorScheme.onPrimary.withValues(
          alpha: 0.1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProductPadding.small),
        ),
      ),
    );
  }
}
