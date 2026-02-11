part of '../birthday_form_view.dart';

class _BirthdayAvatar extends StatelessWidget {
  const _BirthdayAvatar({required this.isEditing});
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.general.colorScheme.primaryContainer,
                    context.general.colorScheme.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.general.colorScheme.primary.withValues(
                      alpha: 0.3,
                    ),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                isEditing ? Icons.edit : Icons.person_add,
                size: 50,
                color: context.general.colorScheme.onPrimary,
              ),
            ),
          );
        },
      ),
    );
  }
}

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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
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
