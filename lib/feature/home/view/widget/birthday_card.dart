import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:birthday_reminder/product/utility/constants/product_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class BirthdayCard extends StatelessWidget {
  const BirthdayCard({
    required this.birthday,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final BirthdayModel birthday;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final daysLeft = birthday.daysUntilBirthday();
    final isBirthdayToday = daysLeft == 0;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: ProductPadding.medium,
        vertical: ProductPadding.small,
      ),
      elevation: 4,
      shadowColor: context.general.colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const ProductPadding.allMedium(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isBirthdayToday
                ? Border.all(
                    color: context.general.colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Row(
            children: [
              // Avatar with Gradient
              Container(
                width: 60,
                height: 60,
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
                      color: context.general.colorScheme.primary.withOpacity(
                        0.3,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${birthday.name[0]}${birthday.surname[0]}'.toUpperCase(),
                    style: context.general.textTheme.titleLarge?.copyWith(
                      color: context.general.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: ProductPadding.medium),

              // Info Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      birthday.fullName,
                      style: context.general.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.general.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.cake,
                          size: 14,
                          color: context.general.colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat(
                            'd MMM',
                            context.locale.toString(),
                          ).format(birthday.birthdayDate),
                          style: context.general.textTheme.bodyMedium?.copyWith(
                            color: context.general.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ProductPadding.small,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            context.general.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getRelationshipText(birthday.relationship),
                        style: context.general.textTheme.labelSmall?.copyWith(
                          color: context.general.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Days Left & Actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getDaysLeftColor(context, daysLeft),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getDaysLeftText(daysLeft),
                      style: context.general.textTheme.labelMedium?.copyWith(
                        color: context.general.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: ProductPadding.small),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ActionButton(
                        icon: Icons.edit_outlined,
                        color: context.general.colorScheme.secondary,
                        onTap: onEdit,
                      ),
                      const SizedBox(width: ProductPadding.small),
                      _ActionButton(
                        icon: Icons.delete_outline,
                        color: context.general.colorScheme.error,
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRelationshipText(RelationshipType type) {
    if (type == RelationshipType.family)
      return LocaleKeys.relationship_family.tr();
    if (type == RelationshipType.friend)
      return LocaleKeys.relationship_friend.tr();
    if (type == RelationshipType.colleague)
      return LocaleKeys.relationship_colleague.tr();
    return LocaleKeys.relationship_other.tr();
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
