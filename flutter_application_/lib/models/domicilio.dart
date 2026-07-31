class Domicilio {
  final int id;
  final int pedidoId;
  final String direccion;
  final String estado;
  final String fecha;
  final String productos;
  final double total;

  Domicilio({
    required this.id,
    required this.pedidoId,
    required this.direccion,
    required this.estado,
    required this.fecha,
    required this.productos,
    required this.total,
  });

  factory Domicilio.fromJson(Map<String, dynamic> json) {
    return Domicilio(
      id: int.tryParse((json['id'] ?? '').toString()) ?? 0,
      pedidoId: int.tryParse((json['pedido_id'] ?? json['id_pedido'] ?? '').toString()) ?? 0,
      direccion: _clean(json['direccion']),
      estado: _clean(json['estado']).isEmpty ? 'pendiente' : _clean(json['estado']),
      fecha: _clean(json['fecha']),
      productos: _clean(json['productos']),
      total: double.tryParse((json['total'] ?? '0').toString()) ?? 0,
    );
  }

  String get totalFormateado {
    return total.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => '.',
        );
  }

  static String _clean(dynamic value) => (value ?? '').toString().trim();
}
