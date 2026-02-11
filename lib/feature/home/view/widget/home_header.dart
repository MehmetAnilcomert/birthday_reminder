part of '../home_view.dart';

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180, // Sizing can be kept or mapped to a constant if available
      padding: const EdgeInsets.only(
        left: ProductPadding.normal,
        right: ProductPadding.normal,
        top:
            60, // Maintaining specific layout height/padding for now as it's custom header
        bottom: 40,
      ),
      decoration: _buildBoxDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<AuthViewModel, AuthState>(
                  bloc: ProductStateItems.authViewModel,
                  builder: (context, state) {
                    final userName = state.user?.name ?? '';
                    final welcomeText =
                        '${LocaleKeys.welcome.tr()}, ${userName.trim()}';

                    return Text(
                      welcomeText,
                      style: context.general.textTheme.titleMedium?.copyWith(
                        color: context.general.colorScheme.onPrimary.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  LocaleKeys.app_name.tr(),
                  style: context.general.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.general.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          const LogoutButton(),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          context.general.colorScheme.primary,
          context.general.colorScheme.primaryContainer,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(ProductPadding.large),
        bottomRight: Radius.circular(ProductPadding.large),
      ),
      boxShadow: [
        BoxShadow(
          color: context.general.colorScheme.shadow.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}
