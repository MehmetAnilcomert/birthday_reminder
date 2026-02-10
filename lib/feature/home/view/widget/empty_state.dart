import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class EmptyBirthdayState extends StatelessWidget {
  const EmptyBirthdayState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: context.general.colorScheme.primaryContainer
                        .withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: context.general.colorScheme.secondaryContainer
                        .withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cake_outlined,
                    size: 80,
                    color: context.general.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              LocaleKeys.no_birthdays.tr(),
              style: context.general.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.general.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              LocaleKeys.no_birthdays_description.tr(),
              style: context.general.textTheme.bodyMedium?.copyWith(
                color: context.general.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Decorative elements
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDecoIcon(
                  context,
                  Icons.celebration,
                  context.general.colorScheme.tertiary,
                ),
                const SizedBox(width: 16),
                _buildDecoIcon(
                  context,
                  Icons.card_giftcard,
                  context.general.colorScheme.secondary,
                ),
                const SizedBox(width: 16),
                _buildDecoIcon(
                  context,
                  Icons.emoji_emotions,
                  context.general.colorScheme.primaryContainer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecoIcon(BuildContext context, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
