part of '../birthday_form_view.dart';

class _BirthdayTextField extends StatelessWidget {
  const _BirthdayTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.minLines,
    this.validator,
    this.suffixIcon,
    this.translateError,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int? maxLines;
  final int? minLines;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final String? Function(String?)? translateError;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: context.general.colorScheme.primary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: context.general.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProductPadding.medium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProductPadding.medium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProductPadding.medium),
          borderSide: BorderSide(
            color: context.general.colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProductPadding.medium),
          borderSide: BorderSide(color: context.general.colorScheme.error),
        ),
      ),
      maxLines: maxLines,
      minLines: minLines,
      textCapitalization: TextCapitalization.sentences,
      validator: validator != null && translateError != null
          ? (value) => translateError!(validator!(value))
          : null,
    );
  }
}
