import 'package:flutter/material.dart';
import 'day_chip.dart';

/// Faixa horizontal de dias. Pede mais disponibilidade ao chegar perto de um
/// dia que ainda não foi carregado.
class DayStrip extends StatefulWidget {
  final List<DateTime> days;
  final DateTime? selectedDay;
  final bool Function(DateTime day) isLoaded;
  final bool Function(DateTime day) hasAvailability;
  final ValueChanged<DateTime> onSelect;
  final ValueChanged<DateTime> onNeedDay;

  const DayStrip({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.isLoaded,
    required this.hasAvailability,
    required this.onSelect,
    required this.onNeedDay,
  });

  @override
  State<DayStrip> createState() => _DayStripState();
}

class _DayStripState extends State<DayStrip> {
  double get _itemExtent =>
      DayChip.widthFor(MediaQuery.textScalerOf(context)) + DayChip.spacing;

  ScrollController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // O offset inicial depende da largura do chip, que vem do MediaQuery.
    _controller ??= ScrollController(
      initialScrollOffset: _offsetFor(widget.selectedDay),
    );
  }

  double _offsetFor(DateTime? day) {
    final index = day == null ? -1 : widget.days.indexOf(day);
    return index > 1 ? (index - 1) * _itemExtent : 0;
  }

  @override
  void didUpdateWidget(covariant DayStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    // O ViewModel pode pular para o primeiro dia com vaga; acompanha a seleção.
    final controller = _controller;
    if (widget.selectedDay != oldWidget.selectedDay &&
        controller != null &&
        controller.hasClients) {
      final target = _offsetFor(
        widget.selectedDay,
      ).clamp(0.0, controller.position.maxScrollExtent);
      final viewport = controller.position.viewportDimension;
      final current = controller.offset;
      if (target < current || target > current + viewport - _itemExtent * 2) {
        controller.animateTo(
          target,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DayChip.heightFor(MediaQuery.textScalerOf(context)),
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: widget.days.length,
        itemBuilder: (context, index) {
          final day = widget.days[index];
          final loaded = widget.isLoaded(day);
          if (!loaded) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => widget.onNeedDay(day),
            );
          }
          return DayChip(
            day: day,
            selected: day == widget.selectedDay,
            loaded: loaded,
            hasAvailability: widget.hasAvailability(day),
            onTap: () => widget.onSelect(day),
          );
        },
      ),
    );
  }
}
