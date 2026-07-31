import 'package:flutter/material.dart';
import '../models/carrito.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';
import '../widgets/pesquera_scaffold.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<Producto>> productos;
  String busqueda = '';

  @override
  void initState() {
    super.initState();
    productos = ProductoService.obtenerProductos();
  }

  @override
  Widget build(BuildContext context) {
    return PesqueraScaffold(
      child: FutureBuilder<List<Producto>>(
        future: productos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ErrorState(error: snapshot.error.toString());
          }

          final lista = (snapshot.data ?? []).where((producto) {
            return producto.nombre
                .toLowerCase()
                .contains(busqueda.toLowerCase().trim());
          }).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      children: [
                        const Text(
                          'Nuestro Menu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF0A3D62),
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Del mar a tu mesa: descubre los mejores sabores de La Pesquera.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF2C3E50),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 640),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Buscar producto...',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFF1C40F),
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) =>
                                setState(() => busqueda = value),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _Category(
                          title: 'Pescados y Carnes',
                          products: lista
                              .where((p) =>
                                  p.categoria.toLowerCase() ==
                                  'pescados y carnes')
                              .toList(),
                          onAdd: _add,
                        ),
                        _Category(
                          title: 'Sopas',
                          products: lista
                              .where(
                                  (p) => p.categoria.toLowerCase() == 'sopas')
                              .toList(),
                          onAdd: _add,
                        ),
                        _Category(
                          title: 'Porciones',
                          products: lista
                              .where((p) =>
                                  p.categoria.toLowerCase() == 'porcion')
                              .toList(),
                          onAdd: _add,
                        ),
                        _Category(
                          title: 'Bebidas',
                          products: lista
                              .where(
                                  (p) => p.categoria.toLowerCase() == 'bebida')
                              .toList(),
                          onAdd: _add,
                        ),
                      ],
                    ),
                  ),
                ),
                const PesqueraFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _add(Producto producto) {
    Carrito.agregar(producto);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${producto.nombre} agregado al carrito')),
    );
    setState(() {});
  }
}

class _Category extends StatelessWidget {
  final String title;
  final List<Producto> products;
  final void Function(Producto) onAdd;

  const _Category({
    required this.title,
    required this.products,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 34),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xFFF1C40F), width: 5),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF0A3D62),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...products.map(
            (producto) => _MenuRow(producto: producto, onAdd: onAdd),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final Producto producto;
  final void Function(Producto) onAdd;

  const _MenuRow({required this.producto, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 620;

    return InkWell(
      onTap: () => _showPreview(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/${producto.imagen}',
                width: isMobile ? 64 : 82,
                height: isMobile ? 54 : 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: isMobile ? 64 : 82,
                  height: isMobile ? 54 : 64,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      color: Color(0xFF2C3E50),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  if (producto.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      producto.descripcion,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '\$${producto.precioFormateado}',
              style: const TextStyle(
                color: Color(0xFF0A3D62),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () => onAdd(producto),
              icon: const Icon(Icons.add),
              tooltip: 'Agregar',
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF1C40F),
                foregroundColor: const Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPreview(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/${producto.imagen}',
                height: 210,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              producto.nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF0A3D62),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${producto.precioFormateado}',
              style: const TextStyle(
                color: Color(0xFF0A3D62),
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onAdd(producto);
              },
              child: const Text('Agregar al carrito'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'No se pudo cargar el menu. Verifica que XAMPP este activo.\n$error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
