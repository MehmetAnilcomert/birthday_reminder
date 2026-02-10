import 'package:auto_route/auto_route.dart';
import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';

import 'package:birthday_reminder/feature/birthday/view_model/birthday_form_view_model.dart';
import 'package:birthday_reminder/feature/birthday/view_model/state/birthday_form_state.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:birthday_reminder/product/state/base/base_state.dart';
import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:birthday_reminder/product/utility/error_translator.dart';
import 'package:birthday_reminder/product/utility/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

@RoutePage()
class BirthdayFormView extends StatefulWidget {
  final BirthdayModel? birthday;

  const BirthdayFormView({super.key, this.birthday});

  @override
  State<BirthdayFormView> createState() => _BirthdayFormViewState();
}

class _BirthdayFormViewState extends BaseState<BirthdayFormView>
    with ErrorTranslator {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _greetingController = TextEditingController();

  DateTime? _selectedDate;
  RelationshipType _selectedRelationship = RelationshipType.friend;

  bool get isEditing => widget.birthday != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.birthday!.name;
      _surnameController.text = widget.birthday!.surname;
      _greetingController.text = widget.birthday!.greetingMessage;
      _selectedDate = widget.birthday!.birthdayDate;
      _selectedRelationship = widget.birthday!.relationship;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _greetingController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.general.colorScheme.primary,
              onPrimary: context.general.colorScheme.onPrimary,
              surface: context.general.colorScheme.surface,
              onSurface: context.general.colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.please_select_birthday_date.tr()),
            backgroundColor: context.general.colorScheme.tertiary,
          ),
        );
        return;
      }

      final user = ProductStateItems.authViewModel.state.user;
      if (user == null) return;

      final birthday = BirthdayModel(
        id: widget.birthday?.id ?? '',
        userId: user.id,
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        birthdayDate: _selectedDate!,
        relationship: _selectedRelationship,
        greetingMessage: _greetingController.text.trim(),
        createdAt: widget.birthday?.createdAt ?? DateTime.now(),
        updatedAt: isEditing ? DateTime.now() : null,
      );

      final viewModel = context.read<BirthdayFormViewModel>();
      if (isEditing) {
        viewModel.updateBirthday(birthday);
      } else {
        viewModel.addBirthday(birthday);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BirthdayFormViewModel(),
      child: BlocListener<BirthdayFormViewModel, BirthdayFormState>(
        listener: (context, state) {
          if (state.status == BirthdayFormStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isEditing
                      ? LocaleKeys.birthday_updated.tr()
                      : LocaleKeys.birthday_added.tr(),
                ),
                backgroundColor: context.general.colorScheme.tertiary,
              ),
            );
            context.maybePop(true);
          } else if (state.status == BirthdayFormStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? LocaleKeys.error.tr()),
                backgroundColor: context.general.colorScheme.error,
              ),
            );
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  isEditing
                      ? LocaleKeys.edit_birthday.tr()
                      : LocaleKeys.add_birthday.tr(),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.name.tr(),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) => translateError(
                            Validators.requiredValidator(value),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 16),

                        // Surname Field
                        TextFormField(
                          controller: _surnameController,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.surname.tr(),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (value) => translateError(
                            Validators.requiredValidator(value),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 16),

                        // Birthday Date Picker
                        InkWell(
                          onTap: _selectDate,
                          borderRadius: BorderRadius.circular(12),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: LocaleKeys.birthday_date.tr(),
                              prefixIcon: const Icon(Icons.cake),
                            ),
                            child: Text(
                              _selectedDate != null
                                  ? DateFormat(
                                      'dd MMMM yyyy',
                                      context.locale.toString(),
                                    ).format(_selectedDate!)
                                  : LocaleKeys.select_date.tr(),
                              style: TextStyle(
                                color: _selectedDate != null
                                    ? context.general.colorScheme.onSurface
                                    : context
                                          .general
                                          .colorScheme
                                          .onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Relationship Dropdown
                        DropdownButtonFormField<RelationshipType>(
                          initialValue: _selectedRelationship,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.relationship.tr(),
                            prefixIcon: const Icon(Icons.people),
                          ),
                          items: RelationshipType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(_getRelationshipText(type)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedRelationship = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Greeting Message Field
                        TextFormField(
                          controller: _greetingController,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.greeting_message.tr(),
                            prefixIcon: const Icon(Icons.message),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) => translateError(
                            Validators.requiredValidator(value),
                          ),
                          maxLines: 4,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        const SizedBox(height: 32),

                        // Save Button
                        BlocBuilder<BirthdayFormViewModel, BirthdayFormState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed:
                                  state.status == BirthdayFormStatus.loading
                                  ? null
                                  : () => _handleSave(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: state.status == BirthdayFormStatus.loading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      LocaleKeys.save.tr(),
                                      style:
                                          context.general.textTheme.bodyLarge,
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Cancel Button
                        TextButton(
                          onPressed: () => context.maybePop(),
                          child: Text(LocaleKeys.cancel.tr()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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
}
