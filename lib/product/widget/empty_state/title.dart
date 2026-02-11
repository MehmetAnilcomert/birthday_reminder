part of '../../../feature/home/view/widget/empty_state.dart';

final class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.no_birthdays.tr(),
      style: context.general.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.general.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }
}
