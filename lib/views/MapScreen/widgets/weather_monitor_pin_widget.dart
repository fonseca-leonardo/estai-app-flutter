import 'package:flutter/material.dart';

class WeatherMonitorPinWidget extends StatelessWidget {
  final bool isSelected;

  const WeatherMonitorPinWidget({
    super.key,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade400,
            Colors.cyan.shade300,
            Colors.teal.shade400,
          ],
        ),
        border: Border.all(
          color: Colors.white,
          width: 2.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.6),
                  blurRadius: 8,
                  spreadRadius: 4,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: Center(
        child: Icon(
          Icons.thermostat,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
