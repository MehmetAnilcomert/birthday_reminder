import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:birthday_reminder/product/utility/constants/product_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

part '../../../../product/widget/birthday_card/action_button.dart';
part '../../../../product/widget/birthday_card/info_section.dart';
part '../../../../product/widget/birthday_card/days_left_badge.dart';
part '../../../../product/widget/birthday_card/gradient_avatar.dart';

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
      elevation: ProductPadding.micro,
      shadowColor: context.general.colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ProductPadding.medium),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(ProductPadding.medium),
        child: Container(
          padding: const ProductPadding.allMedium(),
          decoration: _buildDecoration(context, isBirthdayToday),
          child: Row(
            children: [
              // Avatar with Gradient
              _AvatarWithGradient(birthday: birthday),

              const SizedBox(width: ProductPadding.medium),

              // Info Section
              Expanded(
                child: _InfoSection(birthday: birthday),
              ),

              // Days Left & Actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _DaysLeftBadge(
                    daysLeft: daysLeft,
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

  // BoxDecoration settings for birthday card
  BoxDecoration _buildDecoration(BuildContext context, bool isBirthdayToday) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(ProductPadding.medium),
      border: isBirthdayToday
          ? Border.all(
              color: context.general.colorScheme.primary,
              width: 2,
            )
          : null,
    );
  }
}
