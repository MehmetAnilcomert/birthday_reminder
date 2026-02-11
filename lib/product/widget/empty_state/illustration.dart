part of '../../../feature/home/view/widget/empty_state.dart';

final class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: context.general.colorScheme.primaryContainer.withValues(
              alpha: 0.3,
            ),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: context.general.colorScheme.secondaryContainer.withValues(
              alpha: 0.4,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.cake_outlined,
            size: 80,
            color: context.general.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
