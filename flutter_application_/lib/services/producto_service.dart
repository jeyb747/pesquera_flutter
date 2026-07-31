import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';
import 'api_config.dart';

class ProductoService {

  static Future<List<Producto>> obtenerProductos() async {

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/productos.php',
      ),
    );

    final List data = jsonDecode(response.body);

    return data.map((e) => Producto.fromJson(e)).toList();
  }
}
