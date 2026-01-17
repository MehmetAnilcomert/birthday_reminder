import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../product/utility/theme/app_colors.dart';

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
                    color: AppColors.primaryLight.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cake_outlined,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'no_birthdays'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'no_birthdays_description'.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Decorative elements
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDecoIcon(Icons.celebration, AppColors.accent),
                const SizedBox(width: 16),
                _buildDecoIcon(Icons.card_giftcard, AppColors.secondary),
                const SizedBox(width: 16),
                _buildDecoIcon(Icons.emoji_emotions, AppColors.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecoIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
