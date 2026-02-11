part of '../home_view.dart';

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildBoxDecoration(context),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: LocaleKeys.search.tr(),
          hintStyle: TextStyle(
            color: context.general.colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: context.general.colorScheme.primary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: ProductPadding.large,
            vertical: ProductPadding.medium,
          ),
        ),
        onChanged: (query) {
          context.read<HomeViewModel>().updateSearchQuery(query);
        },
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.general.colorScheme.surface,
      borderRadius: BorderRadius.circular(ProductPadding.medium),
      boxShadow: [
        BoxShadow(
          color: context.general.colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
