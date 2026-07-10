import '../l10n/app_localizations.dart';

enum BoatType {
  jetski,
  sailboat,
  boat,
  yacht;

  String get apiValue {
    switch (this) {
      case BoatType.jetski:
        return 'JetSki';
      case BoatType.sailboat:
        return 'Sailboat';
      case BoatType.boat:
        return 'Boat';
      case BoatType.yacht:
        return 'Yacht';
    }
  }

  static BoatType fromApiValue(String value) {
    return BoatType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => BoatType.boat,
    );
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case BoatType.jetski:
        return l10n.boatTypeJetski;
      case BoatType.sailboat:
        return l10n.boatTypeSailboat;
      case BoatType.boat:
        return l10n.boatTypeBoat;
      case BoatType.yacht:
        return l10n.boatTypeYacht;
    }
  }
}
