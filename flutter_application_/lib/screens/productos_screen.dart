import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {

  late Future<List<Producto>> productos;

  @override
  void initState() {
    super.initState();
    productos = ProductoService.obtenerProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
      ),
      body: FutureBuilder<List<Producto>>(
        future: productos,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            );
          }

          final lista = snapshot.data!;

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {

              final producto = lista[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text(producto.descripcion),
                  trailing: Text(
                    "\$${producto.precio}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}