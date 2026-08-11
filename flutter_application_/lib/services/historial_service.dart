import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class HistorialService {
  static Future<List<Map<String, dynamic>>> _obtener(
    String endpoint,
    String key,
    int usuarioId,
  ) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/$endpoint')
          .replace(queryParameters: {'usuario_id': '$usuarioId'});
      final response = await http.get(uri).timeout(const Duration(seconds: 20));
      if (response.statusCode < 200 || response.statusCode >= 300) return [];
      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic> || data['success'] != true) return [];
      final values = data[key];
      if (values is! List) return [];
      return values.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> reservas(int usuarioId) =>
      _obtener('reservas.php', 'reservas', usuarioId);

  static Future<List<Map<String, dynamic>>> domicilios(int usuarioId) =>
      _obtener('domicilios.php', 'domicilios', usuarioId);
}
