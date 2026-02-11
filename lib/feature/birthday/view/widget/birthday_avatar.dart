part of '../birthday_form_view.dart';

class _BirthdayAvatar extends StatelessWidget {
  const _BirthdayAvatar({required this.isEditing});
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.general.colorScheme.primaryContainer,
                    context.general.colorScheme.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.general.colorScheme.primary.withValues(
                      alpha: 0.3,
                    ),
                    blurRadius: ProductPadding.medium,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                isEditing ? Icons.edit : Icons.person_add,
                size: 50,
                color: context.general.colorScheme.onPrimary,
              ),
            ),
          );
        },
      ),
    );
  }
}
