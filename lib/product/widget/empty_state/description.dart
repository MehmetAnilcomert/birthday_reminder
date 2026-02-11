part of '../../../feature/home/view/widget/empty_state.dart';

final class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.no_birthdays_description.tr(),
      style: context.general.textTheme.bodyMedium?.copyWith(
        color: context.general.colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }
}
