import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/producto.dart';
import 'api_config.dart';
import 'session_service.dart';

class DomicilioService {
  static Future<Map<String, dynamic>> crear({
    required String nombre,
    required String direccion,
    required String telefono,
    required String pago,
    required String observaciones,
    required List<Producto> productos,
    required double total,
  }) async {
    final usuarioId = SessionService.usuarioId;

    if (usuarioId == null) {
      return {
        'success': false,
        'mensaje': 'Debes iniciar sesion para pedir domicilio',
      };
    }

    if (productos.isEmpty) {
      return {
        'success': false,
        'mensaje': 'Agrega productos al carrito',
      };
    }

    final productosJson = jsonEncode(
      productos
          .map(
            (producto) => {
              'id': producto.id,
              'nombre': producto.nombre,
              'precio': producto.precio,
              'imagen': producto.imagen,
              'categoria': producto.categoria,
            },
          )
          .toList(),
    );

    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/domicilios.php'),
            body: {
              'usuario_id': usuarioId.toString(),
              'nombre': nombre,
              'direccion': direccion,
              'telefono': telefono,
              'pago': pago,
              'observaciones': observaciones,
              'productos': productosJson,
              'total': total.toStringAsFixed(0),
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
