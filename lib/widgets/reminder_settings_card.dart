import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/notification_channel.dart';
import '../models/reminder_settings.dart';
import 'selectable_pill.dart';

/// Configuração de lembrete (ligado, antecedência e canais) usada nos
/// formulários do Diário da Embarcação. Só descreve o lembrete; quem envia é
/// o backend.
class ReminderSettingsCard extends StatelessWidget {
  final ReminderSettings reminder;
  final bool showHoursBefore;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<int> onDayToggled;
  final ValueChanged<int?> onHoursChanged;
  final ValueChanged<NotificationChannel> onChannelToggled;

  const ReminderSettingsCard({
    super.key,
    required this.reminder,
    required this.showHoursBefore,
    required this.onEnabledChanged,
    required this.onDayToggled,
    required this.onHoursChanged,
    required this.onChannelToggled,
  });

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return SelectablePill(label: label, selected: selected, onTap: onTap);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.reminderTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.reminderSubtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: reminder.enabled,
                onChanged: onEnabledChanged,
                activeThumbColor: Colors.black,
                activeTrackColor: Colors.white,
              ),
            ],
          ),
          if (reminder.enabled) ...[
            _label(l10n.reminderDaysBeforeLabel),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final days in ReminderSettings.daysBeforeOptions)
                  _chip(
                    label: l10n.reminderDaysOption(days),
                    selected: reminder.daysBefore.contains(days),
                    onTap: () => onDayToggled(days),
                  ),
              ],
            ),
            if (showHoursBefore) ...[
              _label(l10n.reminderHoursBeforeLabel),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final hours in ReminderSettings.hoursBeforeOptions)
                    _chip(
                      label: l10n.engineHoursValue(hours.toString()),
                      selected: reminder.hoursBefore == hours,
                      onTap: () => onHoursChanged(
                        reminder.hoursBefore == hours ? null : hours,
                      ),
                    ),
                ],
              ),
            ],
            _label(l10n.reminderChannelsLabel),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final channel in NotificationChannel.values)
                  _chip(
                    label: channel.label(l10n),
                    selected: reminder.channels.contains(channel),
                    onTap: () => onChannelToggled(channel),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
