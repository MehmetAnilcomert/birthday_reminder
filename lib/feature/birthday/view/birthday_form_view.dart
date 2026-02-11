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

part 'widget/birthday_form_view_widgets.dart';

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
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _BirthdayAvatar(isEditing: isEditing),
                        const SizedBox(height: ProductPadding.large),

                        _BirthdayTextField(
                          controller: nameController,
                          label: LocaleKeys.name.tr(),
                          icon: Icons.person,
                          validator: Validators.requiredValidator,
                          translateError: translateError,
                        ),
                        const SizedBox(height: ProductPadding.medium),
                        _BirthdayTextField(
                          controller: surnameController,
                          label: LocaleKeys.surname.tr(),
                          icon: Icons.person_outline,
                          validator: Validators.requiredValidator,
                          translateError: translateError,
                        ),
                        const SizedBox(height: ProductPadding.medium),

                        // Date Picker Field
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          onTap: selectDate,
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
                            if (selectedDate == null) {
                              return LocaleKeys.please_select_birthday_date
                                  .tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: ProductPadding.medium),

                        // Relationship Dropdown
                        DropdownButtonFormField<RelationshipType>(
                          value: selectedRelationship,
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
                              child: Text(getRelationshipText(type)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedRelationship = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: ProductPadding.medium),

                        // Phone Number Field
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.phone_number.tr(),
                            hintText: '(5..)......',
                            prefixIcon: Icon(
                              Icons.phone,
                              color: context.general.colorScheme.primary,
                            ),
                            suffixIcon: IconButton(
                              key: phoneIconKey,
                              icon: Icon(
                                Icons.info_outline,
                                color: context.general.colorScheme.primary,
                              ),
                              onPressed: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: Text(LocaleKeys.phone_number.tr()),
                                    content: Text(LocaleKeys.phone_info.tr()),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        child: Text(LocaleKeys.ok.tr()),
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
                        BlocBuilder<BirthdayFormViewModel, BirthdayFormState>(
                          builder: (context, state) {
                            return _BirthdayTextField(
                              controller: greetingController,
                              label: LocaleKeys.greeting_message.tr(),
                              icon: Icons.message,
                              minLines: 3,
                              maxLines: null,
                              validator: Validators.requiredValidator,
                              translateError: translateError,
                              suffixIcon: state.aiLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Padding(
                                        padding: ProductPadding.allSmall(),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      key: aiButtonKey,
                                      onPressed: () {
                                        if (nameController.text.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                LocaleKeys.name.tr() +
                                                    ' ' +
                                                    LocaleKeys.required_field
                                                        .tr(),
                                              ),
                                              backgroundColor: context
                                                  .general
                                                  .colorScheme
                                                  .error,
                                            ),
                                          );
                                          return;
                                        }
                                        context
                                            .read<BirthdayFormViewModel>()
                                            .suggestGreeting(
                                              name: nameController.text.trim(),
                                              surname: surnameController.text
                                                  .trim(),
                                              relationship: getRelationshipText(
                                                selectedRelationship,
                                              ),
                                            );
                                      },
                                      icon: Icon(
                                        Icons.auto_awesome,
                                        color:
                                            context.general.colorScheme.primary,
                                      ),
                                      tooltip: LocaleKeys.ai_suggestion.tr(),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),

                        // Buttons
                        BlocBuilder<BirthdayFormViewModel, BirthdayFormState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed:
                                  state.status == BirthdayFormStatus.loading
                                  ? null
                                  : handleSave,
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
}
