import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/domicilio.dart';
import '../models/producto.dart';
import 'api_config.dart';
import 'session_service.dart';

class DomicilioService {
  static Future<List<Domicilio>> listar() async {
    final usuarioId = SessionService.usuarioId;

    if (usuarioId == null) return [];

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/domicilios.php?usuario_id=$usuarioId'),
    );
    final data = jsonDecode(response.body);
    final domicilios = data is Map<String, dynamic> ? data['domicilios'] : null;

    if (domicilios is! List) return [];

    return domicilios
        .whereType<Map<String, dynamic>>()
        .map(Domicilio.fromJson)
        .toList();
  }

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

    final response = await http.post(
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
    );

    return jsonDecode(response.body);
  }
}
