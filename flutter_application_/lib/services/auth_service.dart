import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'session_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, String> body,
  ) async {
    try {
      final response = await http
          .post(Uri.parse('${ApiConfig.baseUrl}/$endpoint'), body: body)
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

  static Future<Map<String, dynamic>> login(
      String correo,
      String password) async {
    final data = await _post('login.php', {
      'correo': correo,
      'password': password,
    });

    if (data['success'] == true && data['usuario'] is Map<String, dynamic>) {
      SessionService.iniciar(data['usuario']);
    }

    return data;
  }

  static Future<Map<String, dynamic>> registro({
    required String nombre,
    required String tipoDocumento,
    required String numeroDocumento,
    required String correo,
    required String telefono,
    required String password,
  }) async {
    return _post('registro.php', {
      'nombre': nombre,
      'tipo_documento': tipoDocumento,
      'numero_documento': numeroDocumento,
      'correo': correo,
      'telefono': telefono,
      'password': password,
    });
  }
}
