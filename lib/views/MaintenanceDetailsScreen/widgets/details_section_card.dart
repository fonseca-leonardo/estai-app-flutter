import 'package:flutter/material.dart';

/// Card com linhas de informação separadas por divisórias sutis.
class DetailsSectionCard extends StatelessWidget {
  final List<Widget> rows;

  const DetailsSectionCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
            rows[i],
          ],
        ],
      ),
    );
  }
}
