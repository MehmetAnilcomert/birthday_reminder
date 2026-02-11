part of '../birthday_form_view.dart';

final class _BirthdayRelationshipDropdown extends StatelessWidget {
  const _BirthdayRelationshipDropdown({
    required this.selectedRelationship,
    required this.onChanged,
    required this.getRelationshipText,
  });

  final RelationshipType? selectedRelationship;
  final ValueChanged<RelationshipType?> onChanged;
  final String Function(RelationshipType) getRelationshipText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<RelationshipType>(
      initialValue: selectedRelationship,
      decoration: InputDecoration(
        labelText: LocaleKeys.relationship.tr(),
        prefixIcon: Icon(
          Icons.people,
          color: context.general.colorScheme.primary,
        ),
        filled: true,
        fillColor: context.general.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: RelationshipType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(getRelationshipText(type)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
