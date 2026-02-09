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
import 'package:birthday_reminder/product/utility/theme/app_colors.dart';
import 'package:birthday_reminder/product/state/container/product_state_container.dart';
import 'package:birthday_reminder/product/service/notification/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              body: Column(
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  LocaleKeys.app_name.tr(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textOnPrimary,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications_active,
                                  color: AppColors.textOnPrimary,
                                ),
                                onPressed: () {
                                  _showNotificationTestDialog(context);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.logout,
                                  color: AppColors.textOnPrimary,
                                ),
                                onPressed: () {
                                  ProductStateItems.authViewModel.signOut();
                                  context.router.replaceAll([
                                    const LoginRoute(),
                                  ]);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: LocaleKeys.search.tr(),
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (query) {
                              context.read<HomeViewModel>().updateSearchQuery(
                                query,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Birthday List
                  Expanded(
                    child: BlocBuilder<HomeViewModel, HomeState>(
                      builder: (context, state) {
                        if (state.status == HomeStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.status == HomeStatus.error) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: AppColors.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  state.errorMessage ?? LocaleKeys.error.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state.filteredBirthdays.isEmpty &&
                            state.searchQuery.isEmpty) {
                          return const EmptyBirthdayState();
                        }

                        if (state.filteredBirthdays.isEmpty &&
                            state.searchQuery.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: AppColors.textHint,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Sonuç bulunamadı',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            final user =
                                ProductStateItems.authViewModel.state.user;
                            if (user != null) {
                              await context.read<HomeViewModel>().loadBirthdays(
                                user.id,
                              );
                            }
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                                    final user = ProductStateItems
                                        .authViewModel
                                        .state
                                        .user;
                                    if (user != null && context.mounted) {
                                      context
                                          .read<HomeViewModel>()
                                          .loadBirthdays(user.id);
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
              ),
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
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(LocaleKeys.yes.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _showNotificationTestDialog(BuildContext context) async {
    // Get token
    final token = await ProductContainer.read<INotificationService>()
        .getToken();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Test'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('FCM Token:'),
            const SizedBox(height: 8),
            SelectableText(token ?? 'No token found'),
            const SizedBox(height: 16),
            const Text(
              'Use this token in Firebase Console -> Messaging -> New Campaign -> Notifications -> Send test message.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: token ?? ''));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Token copied to clipboard')),
                );
              }
            },
            child: const Text('Copy Token'),
          ),
        ],
      ),
    );
  }
}
