class SessionService {
  static Map<String, dynamic>? usuario;

  static int? get usuarioId {
    final value = usuario?['id'] ?? usuario?['usuario_id'];
    if (value == null) return null;
    return int.tryParse(value.toString());
  }

  static String? get nombre {
    final value = usuario?['nombre'] ?? usuario?['usuario'];
    return value?.toString();
  }

  static bool get estaLogueado => usuarioId != null;

  static void iniciar(Map<String, dynamic> data) {
    usuario = data;
  }

  static void cerrar() {
    usuario = null;
  }
}
