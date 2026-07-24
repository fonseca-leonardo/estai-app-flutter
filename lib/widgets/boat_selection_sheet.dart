import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/boat.dart';
import '../services/boat_cache_service.dart';
import '../viewmodels/boat_viewmodel.dart';
import '../views/BoatFormScreen/boat_form_screen.dart';

/// Resultado da seleção de barco: [boat] preenchido quando o usuário escolheu
/// um barco para a monitoria, ou `null` quando optou por navegar sem monitoria.
class BoatSelectionResult {
  final Boat? boat;

  const BoatSelectionResult({this.boat});
}

/// Bottom sheet exibida ao iniciar uma navegação para usuários com marina:
/// permite escolher qual barco será monitorado, iniciar sem monitoria ou
/// cadastrar um barco quando não há nenhum. Somente barcos associados à
/// marina atual ([marinaId]) são listados, pois só eles podem ser
/// monitorados. A lista vem do [BoatViewModel] (cache-first), então funciona
/// offline.
class BoatSelectionSheet extends StatefulWidget {
  final String marinaId;

  const BoatSelectionSheet({super.key, required this.marinaId});

  /// Retorna `null` quando o usuário fechou a sheet sem decidir (não iniciar).
  static Future<BoatSelectionResult?> show(
    BuildContext context, {
    required String marinaId,
  }) {
    return showModalBottomSheet<BoatSelectionResult>(
      context: context,
      backgroundColor: const Color(0xFF0A0A0A),
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BoatSelectionSheet(marinaId: marinaId),
    );
  }

  @override
  State<BoatSelectionSheet> createState() => _BoatSelectionSheetState();
}

class _BoatSelectionSheetState extends State<BoatSelectionSheet> {
  final BoatCacheService _boatCache = BoatCacheService();

  String? _selectedBoatId;
  String? _lastUsedBoatId;

  @override
  void initState() {
    super.initState();
    _loadLastSelectedBoat();
  }

  Future<void> _loadLastSelectedBoat() async {
    final lastBoat = await _boatCache.getLastSelectedBoat();
    if (!mounted || lastBoat == null) return;
    setState(() {
      _lastUsedBoatId = lastBoat.id;
    });
  }

  Boat? _resolveSelectedBoat(List<Boat> boats) {
    if (boats.isEmpty) return null;

    for (final boat in boats) {
      if (boat.id == _selectedBoatId) return boat;
    }
    for (final boat in boats) {
      if (boat.id == _lastUsedBoatId) return boat;
    }
    return boats.first;
  }

  void _startWithBoat(Boat boat) {
    Navigator.of(context).pop(BoatSelectionResult(boat: boat));
  }

  void _startWithoutMonitoring() {
    Navigator.of(context).pop(const BoatSelectionResult());
  }

  void _openBoatForm() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const BoatFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Consumer<BoatViewModel>(
        builder: (context, boatViewModel, _) {
          final boats = boatViewModel.boats
              .where((boat) => boat.marinaId == widget.marinaId)
              .toList();
          final selectedBoat = _resolveSelectedBoat(boats);

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                l10n.selectBoatTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.selectBoatSubtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              if (boats.isEmpty && boatViewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (boats.isEmpty)
                _EmptyBoatsContent(onRegisterBoat: _openBoatForm)
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: boats.length,
                    itemBuilder: (context, index) {
                      final boat = boats[index];
                      return _BoatOptionCard(
                        boat: boat,
                        isSelected: boat.id == selectedBoat?.id,
                        onTap: () {
                          setState(() {
                            _selectedBoatId = boat.id;
                          });
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: boats.isEmpty
                      ? _startWithoutMonitoring
                      : () => _startWithBoat(selectedBoat!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    boats.isEmpty
                        ? l10n.startAnyway
                        : l10n.startNavigationAction,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (boats.isNotEmpty)
                Center(
                  child: TextButton(
                    onPressed: _startWithoutMonitoring,
                    child: Text(
                      l10n.startWithoutMonitoring,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyBoatsContent extends StatelessWidget {
  final VoidCallback onRegisterBoat;

  const _EmptyBoatsContent({required this.onRegisterBoat});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.directions_boat_outlined,
            color: Colors.white.withValues(alpha: 0.5),
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noBoatsMonitoringWarning,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onRegisterBoat,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.registerBoat),
          ),
        ],
      ),
    );
  }
}

class _BoatOptionCard extends StatelessWidget {
  final Boat boat;
  final bool isSelected;
  final VoidCallback onTap;

  const _BoatOptionCard({
    required this.boat,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isSelected ? 0.15 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: isSelected ? 0.6 : 0.1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.directions_boat, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boat.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${boat.model} · ${boat.year}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
