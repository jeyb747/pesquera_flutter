import 'package:flutter/material.dart';
import '../services/historial_service.dart';
import '../services/session_service.dart';
import '../widgets/pesquera_scaffold.dart';
import '../widgets/pesquera_style.dart';
import 'menu_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late Future<_Historial> _future;

  @override
  void initState() {
    super.initState();
    _future = _cargar();
  }

  Future<_Historial> _cargar() async {
    final usuarioId = SessionService.usuarioId;
    if (usuarioId == null) return const _Historial([], []);
    final results = await Future.wait([
      HistorialService.reservas(usuarioId),
      HistorialService.domicilios(usuarioId),
    ]);
    return _Historial(results[0], results[1]);
  }

  @override
  Widget build(BuildContext context) => PesqueraScaffold(
        child: FutureBuilder<_Historial>(
          future: _future,
          builder: (context, snapshot) {
            final loading = snapshot.connectionState != ConnectionState.done;
            final data = snapshot.data ?? const _Historial([], []);
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(children: [
                    _hero(context),
                    const SizedBox(height: 20),
                    _Panel(
                      title: 'MIS RESERVAS',
                      subtitle: 'Consulta la fecha, hora y estado de tus reservas.',
                      child: loading
                          ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                          : data.reservas.isEmpty
                              ? const Text('Aún no tienes reservas registradas.', style: TextStyle(color: Colors.black54))
                              : Column(children: data.reservas.map(_ReservaTile.new).toList()),
                    ),
                    const SizedBox(height: 16),
                    _Panel(
                      title: 'SEGUIMIENTO DE PEDIDOS',
                      subtitle: 'Te mostramos en qué etapa se encuentra tu domicilio.',
                      child: loading
                          ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                          : data.domicilios.isEmpty
                              ? const Text('Aún no tienes pedidos a domicilio.', style: TextStyle(color: Colors.black54))
                              : Wrap(spacing: 12, runSpacing: 12, children: data.domicilios.map((item) => SizedBox(width: 310, child: _PedidoTile(item))).toList()),
                    ),
                  ]),
                ),
              ),
            );
          },
        ),
      );

  Widget _hero(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [PesqueraStyle.deepNavy, PesqueraStyle.navy]), borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('MI CUENTA', style: TextStyle(color: PesqueraStyle.yellow, fontSize: 11)),
            const SizedBox(height: 8),
            const Text('MIS RESERVAS Y PEDIDOS', style: TextStyle(color: Colors.white, fontSize: 26)),
            const SizedBox(height: 8),
            const Text('Consulta tus reservas y conoce el estado de cada domicilio.', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ])),
          ElevatedButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MenuScreen())), child: const Text('HACER PEDIDO')),
        ]),
      );
}

class _Historial { final List<Map<String, dynamic>> reservas, domicilios; const _Historial(this.reservas, this.domicilios); }
class _Panel extends StatelessWidget { final String title, subtitle; final Widget child; const _Panel({required this.title, required this.subtitle, required this.child}); @override Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: PesqueraStyle.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: PesqueraStyle.title(17)), const SizedBox(height: 5), Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black45)), const SizedBox(height: 18), child])); }
class _ReservaTile extends StatelessWidget { final Map<String, dynamic> item; const _ReservaTile(this.item); @override Widget build(BuildContext context) { final estado = '${item['estado'] ?? 'pendiente'}'.toUpperCase(); return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD7E5ED)), borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.calendar_month_outlined, color: PesqueraStyle.navy), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${item['fecha'] ?? ''}  •  ${item['hora'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w700, color: PesqueraStyle.ink)), Text('${item['personas'] ?? ''} personas', style: const TextStyle(color: Colors.black54, fontSize: 12))])), _Status(estado)])); } }
class _PedidoTile extends StatelessWidget { final Map<String, dynamic> item; const _PedidoTile(this.item); @override Widget build(BuildContext context) { final estado = '${item['estado'] ?? 'pendiente'}'.toUpperCase(); final total = item['total'] ?? '0'; return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD7E5ED)), borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('PEDIDO #${item['pedido_id'] ?? item['id'] ?? ''}', style: const TextStyle(fontSize: 11, color: Colors.black54)), const SizedBox(height: 5), Text('${r'$'}$total', style: PesqueraStyle.title(19)), const SizedBox(height: 6), Text('${item['direccion'] ?? ''}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black54)), const SizedBox(height: 10), _Status(estado)])); } }
class _Status extends StatelessWidget { final String value; const _Status(this.value); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFE6F8EA), borderRadius: BorderRadius.circular(20)), child: Text(value, style: const TextStyle(color: Color(0xFF18794E), fontSize: 10, fontWeight: FontWeight.bold))); }
