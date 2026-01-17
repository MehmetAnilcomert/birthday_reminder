import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/birthday_bloc.dart';
import '../bloc/birthday_event.dart';
import '../bloc/birthday_state.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../../product/utility/theme/app_colors.dart';
import '../widgets/birthday_card.dart';
import '../widgets/empty_state.dart';
import '../../birthday_form/view/birthday_form_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBirthdays();
  }

  void _loadBirthdays() {
    final authState = context.read<AuthBloc>().state;
    if (authState.user != null) {
      context.read<BirthdayBloc>().add(
        BirthdayLoadRequested(authState.user!.id),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          'app_name'.tr(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'search'.tr(),
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (query) {
                      context.read<BirthdayBloc>().add(
                        BirthdaySearchQueryChanged(query),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Birthday List
          Expanded(
            child: BlocBuilder<BirthdayBloc, BirthdayState>(
              builder: (context, state) {
                if (state.status == BirthdayStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == BirthdayStatus.error) {
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
                          state.errorMessage ?? 'error'.tr(),
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
                    _loadBirthdays();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: state.filteredBirthdays.length,
                    itemBuilder: (context, index) {
                      final birthday = state.filteredBirthdays[index];
                      return BirthdayCard(
                        birthday: birthday,
                        onEdit: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  BirthdayFormView(birthday: birthday),
                            ),
                          );
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
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const BirthdayFormView()));
        },
        icon: const Icon(Icons.add),
        label: Text('add_birthday'.tr()),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String birthdayId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('delete_birthday'.tr()),
        content: Text('delete_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('no'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<BirthdayBloc>().add(
                BirthdayDeleteRequested(birthdayId),
              );
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('birthday_deleted'.tr()),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('yes'.tr()),
          ),
        ],
      ),
    );
  }
}
