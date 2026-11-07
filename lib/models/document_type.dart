import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// De quem é o documento: do barco (diário) ou da pessoa ("Meus
/// documentos").
enum DocumentScope { boat, personal }

enum DocumentType {
  registration(DocumentScope.boat, 'Registration', Icons.badge_outlined),
  insurance(DocumentScope.boat, 'Insurance', Icons.shield_outlined),
  inspection(DocumentScope.boat, 'Inspection', Icons.fact_check_outlined),
  radioLicense(
    DocumentScope.boat,
    'RadioLicense',
    Icons.settings_input_antenna,
  ),
  fireExtinguisher(
    DocumentScope.boat,
    'FireExtinguisher',
    Icons.fire_extinguisher,
  ),
  flares(DocumentScope.boat, 'Flares', Icons.local_fire_department_outlined),
  lifeJackets(
    DocumentScope.boat,
    'LifeJackets',
    Icons.health_and_safety_outlined,
  ),
  lifeRaft(DocumentScope.boat, 'LifeRaft', Icons.sailing_outlined),
  otherBoat(DocumentScope.boat, 'OtherBoat', Icons.description_outlined),
  nauticalLicense(
    DocumentScope.personal,
    'NauticalLicense',
    Icons.card_membership,
  ),
  radioOperatorCertificate(
    DocumentScope.personal,
    'RadioOperatorCertificate',
    Icons.headset_mic_outlined,
  ),
  otherPersonal(
    DocumentScope.personal,
    'OtherPersonal',
    Icons.description_outlined,
  );

  final DocumentScope scope;
  final String apiValue;
  final IconData icon;

  const DocumentType(this.scope, this.apiValue, this.icon);

  static List<DocumentType> forScope(DocumentScope scope) =>
      values.where((type) => type.scope == scope).toList();

  static DocumentType fromApiValue(String value) {
    return values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => DocumentType.otherBoat,
    );
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case DocumentType.registration:
        return l10n.documentTypeRegistration;
      case DocumentType.insurance:
        return l10n.documentTypeInsurance;
      case DocumentType.inspection:
        return l10n.documentTypeInspection;
      case DocumentType.radioLicense:
        return l10n.documentTypeRadioLicense;
      case DocumentType.fireExtinguisher:
        return l10n.documentTypeFireExtinguisher;
      case DocumentType.flares:
        return l10n.documentTypeFlares;
      case DocumentType.lifeJackets:
        return l10n.documentTypeLifeJackets;
      case DocumentType.lifeRaft:
        return l10n.documentTypeLifeRaft;
      case DocumentType.otherBoat:
      case DocumentType.otherPersonal:
        return l10n.documentTypeOther;
      case DocumentType.nauticalLicense:
        return l10n.documentTypeNauticalLicense;
      case DocumentType.radioOperatorCertificate:
        return l10n.documentTypeRadioOperatorCertificate;
    }
  }
}
