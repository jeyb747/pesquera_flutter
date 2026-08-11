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
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio: json['precio'].toString(),
      imagen: json['imagen'] ?? '',
      categoria: json['categoria'] ?? '',
    );
  }
}