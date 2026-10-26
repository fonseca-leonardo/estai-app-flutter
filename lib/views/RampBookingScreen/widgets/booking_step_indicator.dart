import 'package:flutter/material.dart';

/// Barra de progresso em segmentos com o nome da etapa atual.
class BookingStepIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;
  final String label;

  const BookingStepIndicator({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(total, (index) {
            final done = index <= currentIndex;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 4,
                margin: EdgeInsets.only(right: index == total - 1 ? 0 : 6),
                decoration: BoxDecoration(
                  color: done
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Text(
          '${currentIndex + 1}/$total · $label',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
