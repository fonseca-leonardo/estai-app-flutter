import 'package:flutter/material.dart';

class NavigationDataItem {
  final String title;
  final String data;

  const NavigationDataItem({required this.title, required this.data});
}

class NavigationData extends StatelessWidget {
  final Widget? child;
  final List<NavigationDataItem>? data;

  NavigationData({super.key, this.child, this.data})
    : assert(
        child != null || (data != null && data.isNotEmpty),
        'Either child or data must be provided',
      );

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (data != null && data!.isNotEmpty) {
      // Se data foi fornecido, renderiza a lista de itens
      final dataList = data!;
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: dataList.map((item) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.data,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          );
        }).toList(),
      );
    } else if (child != null) {
      // Se apenas child foi fornecido, usa diretamente
      content = child!;
    } else {
      // Fallback (não deveria chegar aqui devido ao assert)
      content = const SizedBox.shrink();
    }

    return Container(
      width: 144,

      decoration: BoxDecoration(
        color: Colors.black.withAlpha(140),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white.withAlpha(64), width: 1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: content,
    );
  }
}
