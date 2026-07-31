class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final String precio;
  final String imagen;
  final String categoria;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: int.parse(json['id'].toString()),
      nombre: _clean(json['nombre']),
      descripcion: _clean(json['descripcion']),
      precio: _clean(json['precio']),
      imagen: _imageName(_clean(json['imagen'])),
      categoria: _clean(json['categoria']),
    );
  }

  double get precioNumerico {
    final normalized = precio
        .replaceAll(RegExp(r'[^0-9,\.]'), '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0;
  }

  String get precioFormateado {
    final value = precioNumerico;
    if (value <= 0) return precio;
    return value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => '.',
        );
  }

  static String _clean(dynamic value) => (value ?? '').toString().trim();

  static String _imageName(String value) {
    final file = value.split('/').last.trim();
    final normalized = Uri.decodeComponent(file).toLowerCase();

    const aliases = {
      'filete_de_robalo.jpg': 'Filete_de_robalo.jpg',
      'carne_asada.jpg': 'carne_asada.jpg',
      'carne asada.jpg': 'carne_asada.jpg',
      'arroz.jpg': 'Arroz.jpg',
      'ensalada.jpg': 'Ensalada.jpg',
      'gaseosa personal.jpg': 'Gaseosa_personal.jpg',
      'jugo natural.jpg': 'jugo_natural.jpg',
      'sopa de menudencias.jpg': 'sopa_ de_menudencias.jpg',
    };

    return aliases[normalized] ?? file;
  }
}
