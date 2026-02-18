part of '../birthday_form_view.dart';

final class _BirthdayGreetingField extends StatelessWidget {
  const _BirthdayGreetingField({
    required this.controller,
    required this.iconKey,
    required this.translateError,
    required this.getRelationshipText,
    required this.nameController,
    required this.surnameController,
    required this.getSelectedRelationship, 
  });

  final TextEditingController controller;
  final Key iconKey;
  final String? Function(String?)? translateError;
  final String Function(RelationshipType) getRelationshipText;
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final RelationshipType Function() getSelectedRelationship; // Değişti!

  @override
  Widget build(BuildContext context) {
    return _BirthdayTextField(
      controller: controller,
      label: LocaleKeys.greeting_message.tr(),
      icon: Icons.message,
      minLines: 3,
      maxLines: null,
      validator: Validators.requiredValidator,
      translateError: translateError,
      suffixIcon: BlocBuilder<BirthdayFormViewModel, BirthdayFormState>(
        buildWhen: (previous, current) => previous.aiLoading != current.aiLoading,
        builder: (context, state) {
          if (state.aiLoading) {
            return const SizedBox(
              height: 24,
              width: 24,
              child: Padding(
                padding: ProductPadding.allSmall(),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          return IconButton(
            key: iconKey,
            onPressed: () {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${LocaleKeys.name.tr()} ${LocaleKeys.required_field.tr()}'),
                    backgroundColor: context.general.colorScheme.error,
                  ),
                );
                return;
              }
              context.read<BirthdayFormViewModel>().suggestGreeting(
                    name: nameController.text.trim(),
                    surname: surnameController.text.trim(),
                    relationship: getRelationshipText(getSelectedRelationship()),
                  );
            },
            icon: Icon(
              Icons.auto_awesome,
              color: context.general.colorScheme.primary,
            ),
            tooltip: LocaleKeys.ai_suggestion.tr(),
          );
        },
      ),
    );
  }
}