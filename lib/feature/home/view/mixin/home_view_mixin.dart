import 'package:birthday_reminder/feature/home/view/home_view.dart';
import 'package:birthday_reminder/feature/home/view_model/home_view_model.dart';
import 'package:birthday_reminder/product/cache/product_preferences.dart';
import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/product/state/base/base_state.dart';
import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

mixin HomeViewMixin on BaseState<HomeView> {
  final searchController = TextEditingController();
  bool isBirthdayChecked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isBirthdayChecked) {
      isBirthdayChecked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        checkUserBirthday();
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void checkUserBirthday() {
    final user = ProductStateItems.authViewModel.state.user;
    if (user?.birthday == null) return;

    final now = DateTime.now();
    final isTodayBirthday =
        user!.birthday!.day == now.day && user.birthday!.month == now.month;

    if (isTodayBirthday) {
      final todayStr = DateFormat('yyyy-MM-dd').format(now);
      final lastShown = ProductStateItems.productPreferences.getString(
        ProductPreferencesKeys.lastBirthdayGreetingShownDate,
      );

      if (lastShown != todayStr) {
        ProductStateItems.productPreferences.setString(
          ProductPreferencesKeys.lastBirthdayGreetingShownDate,
          todayStr,
        );
        showBirthdayGreeting();
      }
    }
  }

  void showBirthdayGreeting() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            const Icon(Icons.cake, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.happy_birthday_title.tr(),
              textAlign: TextAlign.center,
              style: context.general.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          LocaleKeys.happy_birthday_message.tr(),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(LocaleKeys.ok.tr()),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showDeleteConfirmation(
    BuildContext context,
    String birthdayId,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LocaleKeys.delete_birthday.tr()),
        content: Text(LocaleKeys.delete_confirmation.tr()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(LocaleKeys.no.tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<HomeViewModel>().deleteBirthday(birthdayId);
              if (context.mounted) {
                Navigator.of(dialogContext).pop();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys.birthday_deleted.tr()),
                  backgroundColor: context.general.colorScheme.tertiary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.general.colorScheme.error,
              foregroundColor: context.general.colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(LocaleKeys.yes.tr()),
          ),
        ],
      ),
    );
  }
}
