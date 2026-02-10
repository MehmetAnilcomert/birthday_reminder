import 'package:auto_route/auto_route.dart';
import 'package:birthday_reminder/feature/auth/view_model/auth_view_model.dart';
import 'package:birthday_reminder/feature/auth/view_model/state/auth_state.dart';
import 'package:birthday_reminder/feature/home/view/widget/birthday_card.dart';
import 'package:birthday_reminder/feature/home/view/widget/empty_state.dart';
import 'package:birthday_reminder/feature/home/view_model/home_view_model.dart';
import 'package:birthday_reminder/feature/home/view_model/state/home_state.dart';
import 'package:birthday_reminder/product/navigation/app_router.gr.dart';
import 'package:birthday_reminder/product/state/base/base_state.dart';
import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:kartal/kartal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends BaseState<HomeView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final viewModel = HomeViewModel();
        final user = ProductStateItems.authViewModel.state.user;
        if (user != null) {
          viewModel.loadBirthdays(user.id);
        }
        return viewModel;
      },
      child: Builder(
        builder: (context) {
          // Listen to Auth state changes to reload if user changes (or handle logout)
          return BlocListener<AuthViewModel, AuthState>(
            // Access global AuthViewModel
            bloc: ProductStateItems.authViewModel,
            listener: (context, state) {
              if (state.user != null) {
                context.read<HomeViewModel>().loadBirthdays(state.user!.id);
              }
            },
            child: Scaffold(
              body: Stack(
                children: [
                  // Background color
                  Container(color: context.general.colorScheme.surface),

                  // Content
                  Column(
                    children: [
                      _buildHeader(context),
                      Expanded(child: _buildBody(context)),
                    ],
                  ),

                  // Search Bar Positioned
                  Positioned(
                    top: 140,
                    left: 16,
                    right: 16,
                    child: _buildSearchBar(context),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  final result = await context.router.push(BirthdayFormRoute());
                  if (result == true) {
                    final user = ProductStateItems.authViewModel.state.user;
                    if (user != null && context.mounted) {
                      context.read<HomeViewModel>().loadBirthdays(user.id);
                    }
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(LocaleKeys.add_birthday.tr()),
                elevation: 4,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            color: context.general.colorScheme.shadow.withOpacity(0.2),
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
                Text(
                  LocaleKeys.welcome.tr(), // Or "Hello,"
                  style: context.general.textTheme.titleMedium?.copyWith(
                    color: context.general.colorScheme.onPrimary.withOpacity(
                      0.8,
                    ),
                  ),
                ),
                Text(
                  LocaleKeys.app_name.tr(),
                  style: context.general.textTheme.headlineMedium?.copyWith(
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
            onPressed: () {
              ProductStateItems.authViewModel.signOut();
              context.router.replaceAll([const LoginRoute()]);
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.general.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.general.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
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
            horizontal: 20,
            vertical: 16,
          ),
        ),
        onChanged: (query) {
          context.read<HomeViewModel>().updateSearchQuery(query);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40), // Space for SearchBar
      child: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == HomeStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: context.general.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? LocaleKeys.error.tr(),
                    style: context.general.textTheme.bodyLarge?.copyWith(
                      color: context.general.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state.filteredBirthdays.isEmpty && state.searchQuery.isEmpty) {
            return const EmptyBirthdayState();
          }

          if (state.filteredBirthdays.isEmpty && state.searchQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: context.general.colorScheme.outlineVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sonuç bulunamadı',
                    style: context.general.textTheme.bodyLarge?.copyWith(
                      color: context.general.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final user = ProductStateItems.authViewModel.state.user;
              if (user != null) {
                await context.read<HomeViewModel>().loadBirthdays(user.id);
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                0,
                8,
                0,
                80,
              ), // Bottom padding for FAB
              itemCount: state.filteredBirthdays.length,
              itemBuilder: (context, index) {
                final birthday = state.filteredBirthdays[index];
                return BirthdayCard(
                  birthday: birthday,
                  onEdit: () async {
                    final result = await context.router.push(
                      BirthdayFormRoute(birthday: birthday),
                    );
                    if (result == true) {
                      final user = ProductStateItems.authViewModel.state.user;
                      if (user != null && context.mounted) {
                        context.read<HomeViewModel>().loadBirthdays(user.id);
                      }
                    }
                  },
                  onDelete: () {
                    _showDeleteConfirmation(context, birthday.id);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String birthdayId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LocaleKeys.delete_birthday.tr()),
        content: Text(LocaleKeys.delete_confirmation.tr()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(LocaleKeys.no.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<HomeViewModel>().deleteBirthday(birthdayId);
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys.birthday_deleted.tr()),
                  backgroundColor: context.general.colorScheme.tertiary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.general.colorScheme.error,
              foregroundColor: context.general.colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(LocaleKeys.yes.tr()),
          ),
        ],
      ),
    );
  }
}
