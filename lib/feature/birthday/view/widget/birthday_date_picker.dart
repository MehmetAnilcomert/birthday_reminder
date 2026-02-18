part of '../birthday_form_view.dart';

final class _BirthdayDatePicker extends StatelessWidget {
  const _BirthdayDatePicker({
    required this.dateController,
    required this.selectDate,
    required this.selectedDate,
  });

  final TextEditingController dateController;
  final VoidCallback selectDate;
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
      readOnly: true,
      onTap: selectDate,
      decoration: InputDecoration(
        labelText: LocaleKeys.birthday_date.tr(),
        prefixIcon: Icon(
          Icons.cake,
          color: context.general.colorScheme.primary,
        ),
        suffixIcon: Icon(
          Icons.calendar_today,
          color: context.general.colorScheme.secondary,
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
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.please_select_birthday_date.tr();
        }
        return null;
      },
    );
  }
}
