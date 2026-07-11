import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Baixa e persiste no dispositivo imagens da marina retornadas pelo `/me`
/// (ex.: `logoUrl` e `backgroundUrl`), para que possam ser exibidas mesmo
/// offline e sem precisar rebaixar a cada abertura.
///
/// Cada instância cuida de uma imagem, identificada por [fileName] (nome do
/// arquivo em disco) e [urlKey] (chave no `SharedPreferences` onde a URL de
/// origem é guardada para detectar mudanças). Use os construtores nomeados
/// [MarinaImageStorageService.logo] e [MarinaImageStorageService.background].
class MarinaImageStorageService {
  MarinaImageStorageService({
    required this.fileName,
    required this.urlKey,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Serviço para a logo da marina.
  factory MarinaImageStorageService.logo({http.Client? client}) =>
      MarinaImageStorageService(
        fileName: 'marina_logo.png',
        urlKey: 'marina_logo_url',
        client: client,
      );

  /// Serviço para a imagem de fundo da marina.
  factory MarinaImageStorageService.background({http.Client? client}) =>
      MarinaImageStorageService(
        fileName: 'marina_background.png',
        urlKey: 'marina_background_url',
        client: client,
      );

  final String fileName;
  final String urlKey;
  final http.Client _client;

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  /// Retorna o arquivo local da imagem, se já tiver sido baixado antes.
  Future<File?> getSaved() async {
    try {
      final file = await _file();
      return await file.exists() ? file : null;
    } catch (e) {
      debugPrint('[MarinaImageStorageService:$fileName] getSaved error: $e');
      return null;
    }
  }

  /// Sincroniza a imagem local com [url]:
  /// - `null`/vazio: limpa a imagem persistida e retorna `null`.
  /// - já baixada e mesma URL: retorna o arquivo existente sem rebaixar.
  /// - URL nova ou arquivo ausente: baixa, salva e retorna o arquivo.
  Future<File?> syncFromUrl(String? url) async {
    if (url == null || url.isEmpty) {
      await clear();
      return null;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUrl = prefs.getString(urlKey);
      final file = await _file();

      if (savedUrl == url && await file.exists()) {
        return file;
      }

      final response = await _client.get(Uri.parse(url));
      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        debugPrint(
          '[MarinaImageStorageService:$fileName] download failed: '
          '${response.statusCode}',
        );
        // Mantém a imagem anterior, se houver.
        return await file.exists() ? file : null;
      }

      await file.writeAsBytes(response.bodyBytes, flush: true);
      await prefs.setString(urlKey, url);
      return file;
    } catch (e) {
      debugPrint('[MarinaImageStorageService:$fileName] syncFromUrl error: $e');
      return await getSaved();
    }
  }

  /// Remove a imagem persistida (usar no logout).
  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(urlKey);
      final file = await _file();
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('[MarinaImageStorageService:$fileName] clear error: $e');
    }
  }
}
