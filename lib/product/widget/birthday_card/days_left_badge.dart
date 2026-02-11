part of '../../../feature/home/view/widget/birthday_card.dart';

final class _DaysLeftBadge extends StatelessWidget {
  const _DaysLeftBadge({required this.daysLeft});

  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _getDaysLeftColor(context, daysLeft),
        borderRadius: BorderRadius.circular(
          ProductPadding.medium,
        ),
      ),
      child: Text(
        _getDaysLeftText(daysLeft),
        style: context.general.textTheme.labelMedium?.copyWith(
          color: context.general.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getDaysLeftColor(BuildContext context, int days) {
    if (days == 0) return context.general.colorScheme.primary;
    if (days <= 7) return context.general.colorScheme.tertiary;
    return context.general.colorScheme.outline;
  }

  String _getDaysLeftText(int days) {
    if (days == 0) return LocaleKeys.today.tr();
    if (days == 1) return LocaleKeys.tomorrow.tr();
    return '$days ${LocaleKeys.days_left.tr()}';
  }
}
