import 'package:birthday_reminder/feature/birthday/view/birthday_form_view.dart';
import 'package:birthday_reminder/feature/birthday/view_model/birthday_form_view_model.dart';
import 'package:birthday_reminder/product/cache/product_preferences.dart';
import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/product/models/birthday_model.dart';
import 'package:birthday_reminder/product/state/base/base_state.dart';
import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:birthday_reminder/product/utility/mixin/error_translator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

mixin BirthdayFormViewMixin on BaseState<BirthdayFormView>, ErrorTranslator {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final phoneController = TextEditingController();
  final greetingController = TextEditingController();
  final dateController = TextEditingController();

  DateTime? selectedDate;
  RelationshipType selectedRelationship = RelationshipType.friend;

  final phoneIconKey = GlobalKey();
  final aiButtonKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;
  final List<TargetFocus> targets = [];

  bool get isEditing => widget.birthday != null;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      nameController.text = widget.birthday!.name ?? '';
      surnameController.text = widget.birthday!.surname ?? '';
      phoneController.text = widget.birthday!.phoneNumber ?? '';
      greetingController.text = widget.birthday!.greetingMessage ?? '';
      selectedDate = widget.birthday!.birthdayDate;
      selectedRelationship =
          widget.birthday!.relationship ?? RelationshipType.friend;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized && isEditing) {
      updateDateController();
      isInitialized = true;
    }

    if (!isInitialized && !isEditing) {
      isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndShowTutorial();
      });
    }
  }

  void _checkAndShowTutorial() {
    final isShown = ProductStateItems.productPreferences.getBool(
      key: ProductPreferencesKeys.isTutorialShown,
    );
    if (!isShown) {
      _showInitialPopup();
    }
  }

  void _showInitialPopup() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.tutorial_welcome_title.tr()),
        content: Text(
          LocaleKeys.tutorial_welcome_description.tr(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _initTutorial();
              tutorialCoachMark.show(context: context);
            },
            child: Text(LocaleKeys.tutorial_continue.tr()),
          ),
        ],
      ),
    );
  }

  void _initTutorial() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: 'phoneIcon',
        keyTarget: phoneIconKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.tutorial_phone_title.tr(),
                    style: context.general.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    LocaleKeys.tutorial_phone_description.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: 'aiButton',
        keyTarget: aiButtonKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.tutorial_ai_title.tr(),
                    style: context.general.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    LocaleKeys.tutorial_ai_description.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: context.general.colorScheme.primary,
      textSkip: LocaleKeys.tutorial_skip.tr(),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        ProductStateItems.productPreferences.setBool(
          key: ProductPreferencesKeys.isTutorialShown,
          value: true,
        );
      },
      onSkip: () {
        ProductStateItems.productPreferences.setBool(
          key: ProductPreferencesKeys.isTutorialShown,
          value: true,
        );
        return true;
      },
    );
  }

  void updateDateController() {
    if (selectedDate != null) {
      dateController.text = DateFormat(
        'dd MMMM yyyy',
        context.locale.toString(),
      ).format(selectedDate!);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    greetingController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
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
      selectedDate = picked;
      updateDateController();
    }
  }

  void handleSave(BuildContext context) {
    if (formKey.currentState!.validate()) {
      if (selectedDate == null) {
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
        name: nameController.text.trim(),
        surname: surnameController.text.trim(),
        birthdayDate: selectedDate!,
        relationship: selectedRelationship,
        greetingMessage: greetingController.text.trim(),
        phoneNumber: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        createdAt: widget.birthday?.createdAt ?? DateTime.now(),
        updatedAt: isEditing ? DateTime.now() : null,
      );

      final viewModel = context.read<BirthdayFormViewModel>();
      if (isEditing) {
        viewModel.updateBirthday(birthday, user.email);
      } else {
        viewModel.addBirthday(birthday, user.email);
      }
    }
  }

  String getRelationshipText(RelationshipType type) {
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
