class Reserva {
  final int id;
  final String fecha;
  final String hora;
  final int personas;
  final String estado;
  final String nombre;
  final String telefono;
  final String observaciones;

  Reserva({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.personas,
    required this.estado,
    required this.nombre,
    required this.telefono,
    required this.observaciones,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: int.tryParse((json['id'] ?? '').toString()) ?? 0,
      fecha: _clean(json['fecha']),
      hora: _clean(json['hora']),
      personas: int.tryParse((json['personas'] ?? '').toString()) ?? 0,
      estado: _clean(json['estado']).isEmpty ? 'pendiente' : _clean(json['estado']),
      nombre: _clean(json['nombre']),
      telefono: _clean(json['telefono']),
      observaciones: _clean(json['observaciones']),
    );
  }

  static String _clean(dynamic value) => (value ?? '').toString().trim();
}
