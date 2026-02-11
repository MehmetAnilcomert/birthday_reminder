part of '../../../feature/home/view/widget/birthday_card.dart';

final class _AvatarWithGradient extends StatelessWidget {
  const _AvatarWithGradient({required this.birthday});

  final BirthdayModel birthday;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            color: context.general.colorScheme.primary.withValues(
              alpha: 0.3,
            ),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${birthday.name![0]}${birthday.surname![0]}'.toUpperCase(),
          style: context.general.textTheme.titleLarge?.copyWith(
            color: context.general.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
