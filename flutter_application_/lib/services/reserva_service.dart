import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'session_service.dart';

class ReservaService {
  static Future<Map<String, dynamic>> crear({
    required String nombre,
    required String telefono,
    required String fecha,
    required String hora,
    required int personas,
    required String observaciones,
  }) async {
    final usuarioId = SessionService.usuarioId;

    if (usuarioId == null) {
      return {
        'success': false,
        'mensaje': 'Debes iniciar sesion para reservar',
      };
    }

    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/reservas.php'),
            body: {
              'usuario_id': usuarioId.toString(),
              'nombre': nombre,
              'telefono': telefono,
              'fecha': fecha,
              'hora': hora,
              'personas': personas.toString(),
              'observaciones': observaciones,
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return {
          'success': false,
          'mensaje': 'El servidor no pudo procesar la solicitud.',
        };
      }

      dynamic data;

      try {
        data = jsonDecode(response.body);
      } on FormatException {
        return {
          'success': false,
          'mensaje': 'El servidor devolvio una respuesta no valida.',
        };
      }

      if (data is Map<String, dynamic>) {
        return data;
      }

      return {
        'success': false,
        'mensaje': 'El servidor devolvio una respuesta no valida.',
      };
    } on TimeoutException {
      return {
        'success': false,
        'mensaje': 'El servidor tardo demasiado. Intenta nuevamente.',
      };
    } catch (_) {
      return {
        'success': false,
        'mensaje': 'No fue posible conectar con el servidor.',
      };
    }
  }
}
