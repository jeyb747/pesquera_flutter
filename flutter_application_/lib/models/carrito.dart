import 'producto.dart';

class Carrito {
  static final List<Producto> items = [];

  static void agregar(Producto producto) {
    items.add(producto);
  }

  static void eliminar(Producto producto) {
    items.remove(producto);
  }

  static double get total {
    double suma = 0;

    for (var producto in items) {
      suma += producto.precioNumerico;
    }

    return suma;
  }
}
