part of '../birthday_form_view.dart';

final class _BirthdayPhoneNumberField extends StatelessWidget {
  const _BirthdayPhoneNumberField({
    required this.controller,
    required this.iconKey,
    required this.translateError,
  });

  final TextEditingController controller;
  final Key iconKey;
  final String? Function(String) translateError;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: LocaleKeys.phone_number.tr(),
        hintText: '(5..)......',
        prefixIcon: Icon(
          Icons.phone,
          color: context.general.colorScheme.primary,
        ),
        suffixIcon: IconButton(
          key: iconKey,
          icon: Icon(
            Icons.info_outline,
            color: context.general.colorScheme.primary,
          ),
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: Text(LocaleKeys.phone_number.tr()),
                content: Text(LocaleKeys.phone_info.tr()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(LocaleKeys.ok.tr()),
                  ),
                ],
              ),
            );
          },
          tooltip: LocaleKeys.phone_info.tr(),
        ),
        filled: true,
        fillColor: context.general.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.general.colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}
