part of '../birthday_form_view.dart';

final class _BirthdayFormAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _BirthdayFormAppBar({required this.isEditing});

  final bool isEditing;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        isEditing
            ? LocaleKeys.edit_birthday.tr()
            : LocaleKeys.add_birthday.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: context.general.colorScheme.surface,
      foregroundColor: context.general.colorScheme.onSurface,
    );
  }
}
