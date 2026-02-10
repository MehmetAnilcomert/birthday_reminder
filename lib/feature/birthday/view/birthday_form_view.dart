import 'package:auto_route/auto_route.dart';
import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/feature/birthday/view_model/birthday_form_view_model.dart';
import 'package:birthday_reminder/feature/birthday/view_model/state/birthday_form_state.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:birthday_reminder/product/state/base/base_state.dart';
import 'package:birthday_reminder/product/utility/constants/product_padding.dart';
import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:birthday_reminder/product/utility/mixin/error_translator.dart';
import 'package:birthday_reminder/product/utility/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

@RoutePage()
/// Birthday form view widget for the application.
class BirthdayFormView extends StatefulWidget {
  /// Creates an instance of [BirthdayFormView].
  const BirthdayFormView({super.key, this.birthday});

  /// Birthday model for the application.
  final BirthdayModel? birthday;

  @override
  State<BirthdayFormView> createState() => _BirthdayFormViewState();
}

class _BirthdayFormViewState extends BaseState<BirthdayFormView>
    with ErrorTranslator {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _greetingController = TextEditingController();
  final _dateController =
      TextEditingController(); // Controller to show selected date text

  DateTime? _selectedDate;
  RelationshipType _selectedRelationship = RelationshipType.friend;

  bool get isEditing => widget.birthday != null;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.birthday!.name;
      _surnameController.text = widget.birthday!.surname;
      _phoneController.text = widget.birthday!.phoneNumber ?? '';
      _greetingController.text = widget.birthday!.greetingMessage;
      _selectedDate = widget.birthday!.birthdayDate;
      // _updateDateController(); // Moved to didChangeDependencies
      _selectedRelationship = widget.birthday!.relationship;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized && isEditing) {
      _updateDateController();
      _isInitialized = true;
    }
  }

  void _updateDateController() {
    if (_selectedDate != null) {
      _dateController.text = DateFormat(
        'dd MMMM yyyy',
        context.locale.toString(),
      ).format(_selectedDate!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _greetingController.dispose();
    _dateController.dispose();
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
          data: Theme.of(
            context,
          ).copyWith(colorScheme: context.general.colorScheme),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _updateDateController();
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
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
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
                backgroundColor:
                    context.general.colorScheme.primary, // Success color
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: context.general.colorScheme.surface,
                foregroundColor: context.general.colorScheme.onSurface,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const ProductPadding.allNormal(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Avatar Placeholder Animation
                        Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        context
                                            .general
                                            .colorScheme
                                            .primaryContainer,
                                        context.general.colorScheme.primary,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: context
                                            .general
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isEditing ? Icons.edit : Icons.person_add,
                                    size: 50,
                                    color:
                                        context.general.colorScheme.onPrimary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: ProductPadding.large),

                        // Form Fields
                        _buildTextField(
                          controller: _nameController,
                          label: LocaleKeys.name.tr(),
                          icon: Icons.person,
                          validator: Validators.requiredValidator,
                        ),
                        const SizedBox(height: ProductPadding.medium),
                        _buildTextField(
                          controller: _surnameController,
                          label: LocaleKeys.surname.tr(),
                          icon: Icons.person_outline,
                          validator: Validators.requiredValidator,
                        ),
                        const SizedBox(height: ProductPadding.medium),

                        // Date Picker Field
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: _selectDate,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.birthday_date.tr(),
                            prefixIcon: Icon(
                              Icons.cake,
                              color: context.general.colorScheme.primary,
                            ),
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: context.general.colorScheme.secondary,
                            ),
                            filled: true,
                            fillColor: context
                                .general
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: context.general.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (_selectedDate == null) {
                              return LocaleKeys.please_select_birthday_date
                                  .tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: ProductPadding.medium),

                        // Relationship Dropdown
                        DropdownButtonFormField<RelationshipType>(
                          initialValue: _selectedRelationship,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.relationship.tr(),
                            prefixIcon: Icon(
                              Icons.people,
                              color: context.general.colorScheme.primary,
                            ),
                            filled: true,
                            fillColor: context
                                .general
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
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
                        const SizedBox(height: ProductPadding.medium),

                        // Phone Number Field
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.phone_number.tr(),
                            hintText: '(5..)......',
                            prefixIcon: Icon(
                              Icons.phone,
                              color: context.general.colorScheme.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: context.general.colorScheme.primary,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: Text(LocaleKeys.phone_number.tr()),
                                    content: Text(LocaleKeys.phone_info.tr()),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              tooltip: LocaleKeys.phone_info.tr(),
                            ),
                            filled: true,
                            fillColor: context
                                .general
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: context.general.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: ProductPadding.medium),
                        _buildTextField(
                          controller: _greetingController,
                          label: LocaleKeys.greeting_message.tr(),
                          icon: Icons.message,
                          maxLines: 3,
                          validator: Validators.requiredValidator,
                        ),
                        const SizedBox(height: 40),

                        // Buttons
                        BlocBuilder<BirthdayFormViewModel, BirthdayFormState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed:
                                  state.status == BirthdayFormStatus.loading
                                  ? null
                                  : () => _handleSave(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    context.general.colorScheme.primary,
                                foregroundColor:
                                    context.general.colorScheme.onPrimary,
                                padding:
                                    const ProductPadding.symmetricVerticalMedium(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                shadowColor: context.general.colorScheme.primary
                                    .withValues(alpha: 0.4),
                              ),
                              child: state.status == BirthdayFormStatus.loading
                                  ? SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              context
                                                  .general
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      LocaleKeys.save.tr(),
                                      style: context
                                          .general
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: context
                                                .general
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: ProductPadding.medium),
                        TextButton(
                          onPressed: () => context.maybePop(),
                          child: Text(
                            LocaleKeys.cancel.tr(),
                            style: TextStyle(
                              color: context.general.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: context.general.colorScheme.primary),
        filled: true,
        fillColor: context.general.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.general.colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.general.colorScheme.error),
        ),
      ),
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      validator: validator != null
          ? (value) => translateError(validator(value))
          : null,
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
