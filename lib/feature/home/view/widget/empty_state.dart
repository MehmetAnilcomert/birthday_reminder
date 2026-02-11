import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/product/utility/constants/product_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

part '../../../../product/widget/empty_state/description.dart';
part '../../../../product/widget/empty_state/title.dart';
part '../../../../product/widget/empty_state/decorative_elements.dart';
part '../../../../product/widget/empty_state/illustration.dart';

class EmptyBirthdayState extends StatelessWidget {
  const EmptyBirthdayState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: ProductPadding.allLarge(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration (Circle inner and outer circle with cake icon)
            _Illustration(),
            SizedBox(height: ProductPadding.medium),

            // Title
            _Title(),
            SizedBox(height: ProductPadding.medium),

            // Description
            _Description(),
            SizedBox(height: ProductPadding.large),

            // Decorative elements (Icons)
            _DecorativeElements(),
          ],
        ),
      ),
    );
  }
}
