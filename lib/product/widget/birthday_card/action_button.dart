part of '../../../feature/home/view/widget/birthday_card.dart';

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ProductPadding.small),
      child: Container(
        padding: const EdgeInsets.all(
          6,
        ), // Maintain 6 for action button padding
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ProductPadding.small),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
