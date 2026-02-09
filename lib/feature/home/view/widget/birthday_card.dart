import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
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

    return Card(
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.general.colorScheme.primary.withValues(alpha: 0.8),
                      context.general.colorScheme.secondary.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    birthday.name[0].toUpperCase() +
                        birthday.surname[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.general.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      birthday.fullName,
                      style: context.general.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.general.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getRelationshipText(birthday.relationship),
                      style: context.general.textTheme.bodyMedium?.copyWith(
                        color: context.general.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat(
                        'dd MMMM',
                        context.locale.toString(),
                      ).format(birthday.birthdayDate),
                      style: context.general.textTheme.bodyMedium?.copyWith(
                        color: context.general.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Days Left Badge
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getDaysLeftColor(daysLeft),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getDaysLeftText(daysLeft),
                      style: context.general.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.general.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: onEdit,
                        color: context.general.colorScheme.secondary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: onDelete,
                        color: context.general.colorScheme.error,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
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
    switch (type) {
      case RelationshipType.family:
        return LocaleKeys.relationship_family.tr();
      case RelationshipType.friend:
        return LocaleKeys.relationship_friend.tr();
      case RelationshipType.colleague:
        return LocaleKeys.relationship_colleague.tr();
      case RelationshipType.other:
        return LocaleKeys.relationship_other.tr();
    }
  }

  Color _getDaysLeftColor(int days) {
    // Using tertiary for birthday today, primary for upcoming
    if (days == 0) return const Color(0xFFFF1744); // Birthday today - red
    if (days <= 7) return const Color(0xFFFF6E40); // Upcoming - orange
    return const Color(0xFF9E9E9E); // Past - grey
  }

  String _getDaysLeftText(int days) {
    if (days == 0) return LocaleKeys.today.tr();
    if (days == 1) return LocaleKeys.tomorrow.tr();
    return '$days ${LocaleKeys.days_left.tr()}';
  }
}
