import 'package:auto_route/auto_route.dart';
import 'package:birthday_reminder/feature/birthday/view/mixin/birthday_form_view_mixin.dart';
import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/feature/birthday/view_model/birthday_form_view_model.dart';
import 'package:birthday_reminder/feature/birthday/view_model/state/birthday_form_state.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:birthday_reminder/product/state/base/base_state.dart';
import 'package:birthday_reminder/product/utility/constants/product_padding.dart';
import 'package:birthday_reminder/product/utility/mixin/error_translator.dart';
import 'package:birthday_reminder/product/utility/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

part 'widget/birthday_avatar.dart';
part 'widget/birthday_date_picker.dart';
part 'widget/relationship_dropdown.dart';
part 'widget/phone_number.dart';
part 'widget/greeting_field.dart';
part 'widget/save_button.dart';
part 'widget/birthday_form_appbar.dart';
part 'widget/birthday_text_field.dart';

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
    with ErrorTranslator, BirthdayFormViewMixin {
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
                backgroundColor: context.general.colorScheme.primary,
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

          if (state.generatedMessage != null) {
            greetingController.text = state.generatedMessage!;
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: _BirthdayFormAppBar(isEditing: isEditing),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const ProductPadding.allNormal(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _BirthdayAvatar(isEditing: isEditing),
                        const SizedBox(height: ProductPadding.large),

                        // Name field in the form field
                        _BirthdayTextField(
                          controller: nameController,
                          label: LocaleKeys.name.tr(),
                          icon: Icons.person,
                          validator: Validators.requiredValidator,
                          translateError: translateError,
                        ),
                        const SizedBox(height: ProductPadding.medium),

                        // Surname field in the form field
                        _BirthdayTextField(
                          controller: surnameController,
                          label: LocaleKeys.surname.tr(),
                          icon: Icons.person_outline,
                          validator: Validators.requiredValidator,
                          translateError: translateError,
                        ),
                        const SizedBox(height: ProductPadding.medium),

                        // Date Picker Field
                        _BirthdayDatePicker(
                          dateController: dateController,
                          selectDate: selectDate,
                          selectedDate: selectedDate,
                        ),
                        const SizedBox(height: ProductPadding.medium),

                        // Relationship dropdown in the form field
                        StatefulBuilder(
                          builder: (context, setStateDropdown) {
                            return _BirthdayRelationshipDropdown(
                              selectedRelationship: selectedRelationship,
                              getRelationshipText: getRelationshipText,
                              onChanged: (value) {
                                if (value != null) {
                                  setStateDropdown(() {
                                    selectedRelationship = value;
                                  });
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: ProductPadding.medium),

                        // Phone Number Field in the form field
                        _BirthdayPhoneNumberField(
                          controller: phoneController,
                          iconKey: phoneIconKey,
                          translateError: translateError,
                        ),
                        const SizedBox(height: ProductPadding.medium),

                        // Greeting field in the form field
                        _BirthdayGreetingField(
                          controller: greetingController,
                          iconKey: aiButtonKey,
                          translateError: translateError,
                          getRelationshipText: getRelationshipText,
                          nameController: nameController,
                          surnameController: surnameController,
                          selectedRelationship: selectedRelationship,
                        ),
                        const SizedBox(height: 40),

                        // Save button in the form field
                        _SaveButton(handleSave: handleSave),
                        const SizedBox(height: ProductPadding.medium),

                        // Cancel button in the form field
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
}
