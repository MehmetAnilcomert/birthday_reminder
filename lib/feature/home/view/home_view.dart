import 'package:auto_route/auto_route.dart';
import 'package:birthday_reminder/feature/auth/view_model/auth_view_model.dart';
import 'package:birthday_reminder/feature/auth/view_model/state/auth_state.dart';
import 'package:birthday_reminder/feature/home/view/mixin/home_view_mixin.dart';
import 'package:birthday_reminder/feature/home/view/widget/birthday_card.dart';
import 'package:birthday_reminder/feature/home/view/widget/empty_state.dart';
import 'package:birthday_reminder/feature/home/view_model/home_view_model.dart';
import 'package:birthday_reminder/feature/home/view_model/state/home_state.dart';
import 'package:birthday_reminder/product/navigation/app_router.gr.dart';
import 'package:birthday_reminder/product/state/base/base_state.dart';
import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/product/utility/constants/product_padding.dart';
import 'package:kartal/kartal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widget/home_view_widgets.dart';

@RoutePage()
/// Home view
class HomeView extends StatefulWidget {
  /// Home view
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends BaseState<HomeView> with HomeViewMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final viewModel = HomeViewModel();
        final user = ProductStateItems.authViewModel.state.user;
        if (user != null) {
          viewModel.loadBirthdays(user.id, user.email);
        }
        return viewModel;
      },
      child: Builder(
        builder: (context) {
          return BlocListener<AuthViewModel, AuthState>(
            bloc: ProductStateItems.authViewModel,
            listener: (context, state) async {
              if (state.user != null) {
                await context.read<HomeViewModel>().loadBirthdays(
                  state.user!.id,
                  state.user!.email,
                );
              }
            },
            child: Scaffold(
              body: Stack(
                children: [
                  Container(color: context.general.colorScheme.surface),
                  Column(
                    children: [
                      const _HomeHeader(),
                      Expanded(child: _buildBody(context)),
                    ],
                  ),
                  Positioned(
                    top: 140,
                    left: ProductPadding.medium,
                    right: ProductPadding.medium,
                    child: _HomeSearchBar(controller: searchController),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  final result = await context.router.push(BirthdayFormRoute());
                  if (result == true) {
                    final user = ProductStateItems.authViewModel.state.user;
                    if (user != null && context.mounted) {
                      await context.read<HomeViewModel>().loadBirthdays(
                        user.id,
                        user.email,
                      );
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

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: ProductPadding.medium),
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
                  const SizedBox(height: ProductPadding.medium),
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
                  const SizedBox(height: ProductPadding.medium),
                  Text(
                    LocaleKeys.search_no_results.tr(),
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
                await context.read<HomeViewModel>().loadBirthdays(
                  user.id,
                  user.email,
                );
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                0,
                ProductPadding.small,
                0,
                80,
              ),
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
                        await context.read<HomeViewModel>().loadBirthdays(
                          user.id,
                          user.email,
                        );
                      }
                    }
                  },
                  onDelete: () async {
                    await showDeleteConfirmation(context, birthday.id);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
