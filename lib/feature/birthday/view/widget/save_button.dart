part of '../birthday_form_view.dart';

final class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.handleSave});

  final void Function(BuildContext) handleSave;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BirthdayFormViewModel, BirthdayFormState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.status == BirthdayFormStatus.loading
              ? null
              : () => handleSave(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.general.colorScheme.primary,
            foregroundColor: context.general.colorScheme.onPrimary,
            padding: const ProductPadding.symmetricVerticalMedium(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            shadowColor: context.general.colorScheme.primary.withValues(
              alpha: 0.4,
            ),
          ),
          child: state.status == BirthdayFormStatus.loading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.general.colorScheme.onPrimary,
                    ),
                  ),
                )
              : Text(
                  LocaleKeys.save.tr(),
                  style: context.general.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.general.colorScheme.onPrimary,
                  ),
                ),
        );
      },
    );
  }
}
