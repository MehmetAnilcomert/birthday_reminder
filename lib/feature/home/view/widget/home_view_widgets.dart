part of '../home_view.dart';

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.general.colorScheme.primary,
            context.general.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: context.general.colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
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
                        LocaleKeys.welcome.tr() + ", " + userName.trim();

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
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: context.general.colorScheme.onPrimary,
            ),
            onPressed: () async {
              await ProductStateItems.authViewModel.signOut();
              if (context.mounted) {
                await context.router.replaceAll([const LoginRoute()]);
              }
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.general.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.general.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
}
