import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:birthday_reminder/product/utility/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
                      AppColors.primary.withValues(alpha: 0.8),
                      AppColors.secondary.withValues(alpha: 0.8),
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getRelationshipText(birthday.relationship),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat(
                        'dd MMMM',
                        context.locale.toString(),
                      ).format(birthday.birthdayDate),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
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
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: onEdit,
                        color: AppColors.secondary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: onDelete,
                        color: AppColors.error,
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
    if (days == 0) return AppColors.birthdayToday;
    if (days <= 7) return AppColors.birthdayUpcoming;
    return AppColors.secondary;
  }

  String _getDaysLeftText(int days) {
    if (days == 0) return LocaleKeys.today.tr();
    if (days == 1) return LocaleKeys.tomorrow.tr();
    return '$days ${LocaleKeys.days_left.tr()}';
  }
}
