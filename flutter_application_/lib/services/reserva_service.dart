import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reserva.dart';
import 'api_config.dart';
import 'session_service.dart';

class ReservaService {
  static Future<List<Reserva>> listar() async {
    final usuarioId = SessionService.usuarioId;

    if (usuarioId == null) return [];

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/reservas.php?usuario_id=$usuarioId'),
    );
    final data = jsonDecode(response.body);
    final reservas = data is Map<String, dynamic> ? data['reservas'] : null;

    if (reservas is! List) return [];

    return reservas
        .whereType<Map<String, dynamic>>()
        .map(Reserva.fromJson)
        .toList();
  }

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

    final response = await http.post(
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
    );

    return jsonDecode(response.body);
  }
}
