import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../product/models/birthday_model.dart';
import '../../../product/utility/theme/app_colors.dart';
import '../../../product/utility/validators.dart';
import '../../home/bloc/birthday_bloc.dart';
import '../../home/bloc/birthday_event.dart';
import '../../auth/bloc/auth_bloc.dart';

class BirthdayFormView extends StatefulWidget {
  final BirthdayModel? birthday;

  const BirthdayFormView({super.key, this.birthday});

  @override
  State<BirthdayFormView> createState() => _BirthdayFormViewState();
}

class _BirthdayFormViewState extends State<BirthdayFormView> {
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
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
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

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lütfen doğum tarihini seçin'),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }

      final authState = context.read<AuthBloc>().state;
      if (authState.user == null) return;

      final birthday = BirthdayModel(
        id: widget.birthday?.id ?? '',
        userId: authState.user!.id,
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        birthdayDate: _selectedDate!,
        relationship: _selectedRelationship,
        greetingMessage: _greetingController.text.trim(),
        createdAt: widget.birthday?.createdAt ?? DateTime.now(),
        updatedAt: isEditing ? DateTime.now() : null,
      );

      if (isEditing) {
        context.read<BirthdayBloc>().add(BirthdayUpdateRequested(birthday));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('birthday_updated'.tr()),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        context.read<BirthdayBloc>().add(BirthdayAddRequested(birthday));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('birthday_added'.tr()),
            backgroundColor: AppColors.success,
          ),
        );
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'edit_birthday'.tr() : 'add_birthday'.tr()),
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
                    labelText: 'name'.tr(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: Validators.requiredValidator,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),

                // Surname Field
                TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    labelText: 'surname'.tr(),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: Validators.requiredValidator,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),

                // Birthday Date Picker
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'birthday_date'.tr(),
                      prefixIcon: const Icon(Icons.cake),
                    ),
                    child: Text(
                      _selectedDate != null
                          ? DateFormat(
                              'dd MMMM yyyy',
                              context.locale.toString(),
                            ).format(_selectedDate!)
                          : 'Tarih Seçin',
                      style: TextStyle(
                        color: _selectedDate != null
                            ? AppColors.textPrimary
                            : AppColors.textHint,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Relationship Dropdown
                DropdownButtonFormField<RelationshipType>(
                  value: _selectedRelationship,
                  decoration: InputDecoration(
                    labelText: 'relationship'.tr(),
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
                    labelText: 'greeting_message'.tr(),
                    prefixIcon: const Icon(Icons.message),
                    alignLabelWithHint: true,
                  ),
                  validator: Validators.requiredValidator,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 32),

                // Save Button
                ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'save'.tr(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),

                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('cancel'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRelationshipText(RelationshipType type) {
    switch (type) {
      case RelationshipType.family:
        return 'relationship_family'.tr();
      case RelationshipType.friend:
        return 'relationship_friend'.tr();
      case RelationshipType.colleague:
        return 'relationship_colleague'.tr();
      case RelationshipType.other:
        return 'relationship_other'.tr();
    }
  }
}
