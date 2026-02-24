part of '../../../../feature/home/view/widget/birthday_card.dart';

final class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.birthday});

  final BirthdayModel birthday;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: ProductPadding.micro),
        Row(
          children: [
            // Birthday Icon
            Icon(
              Icons.cake,
              size: 14,
              color: context.general.colorScheme.secondary,
            ),
            const SizedBox(width: ProductPadding.micro),
            // Date of Birth is here
            Text(
              DateFormat('d MMM', context.locale.toString()).format(
                birthday.birthdayDate!,
              ),
              style: context.general.textTheme.bodyMedium?.copyWith(
                color: context.general.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: ProductPadding.small),
            // Relationship info indicator Container
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ProductPadding.small,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: context.general.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(ProductPadding.small),
              ),
              child: Text(
                _getRelationshipText(birthday.relationship!),
                style: context.general.textTheme.labelSmall?.copyWith(
                  color: context.general.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getRelationshipText(RelationshipType type) {
    if (type == RelationshipType.family) {
      return LocaleKeys.relationship_family.tr();
    }
    if (type == RelationshipType.friend) {
      return LocaleKeys.relationship_friend.tr();
    }
    if (type == RelationshipType.colleague) {
      return LocaleKeys.relationship_colleague.tr();
    }
    return LocaleKeys.relationship_other.tr();
  }
}
