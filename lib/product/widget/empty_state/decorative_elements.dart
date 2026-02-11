part of '../../../feature/home/view/widget/empty_state.dart';

final class _DecorativeElements extends StatelessWidget {
  const _DecorativeElements();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDecoIcon(
          context,
          Icons.celebration,
          context.general.colorScheme.tertiary,
        ),
        const SizedBox(width: ProductPadding.medium),
        _buildDecoIcon(
          context,
          Icons.card_giftcard,
          context.general.colorScheme.secondary,
        ),
        const SizedBox(width: ProductPadding.medium),
        _buildDecoIcon(
          context,
          Icons.emoji_emotions,
          context.general.colorScheme.primaryContainer,
        ),
      ],
    );
  }

  Widget _buildDecoIcon(BuildContext context, IconData icon, Color color) {
    return Container(
      padding: const ProductPadding.allSmall(),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ProductPadding.medium),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
