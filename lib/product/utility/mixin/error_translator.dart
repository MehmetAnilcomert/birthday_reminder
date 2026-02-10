import 'package:easy_localization/easy_localization.dart';

mixin ErrorTranslator {
  String? translateError(String? error) {
    if (error == null) return null;
    return error.tr();
  }
}
