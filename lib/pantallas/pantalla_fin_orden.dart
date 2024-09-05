import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../../provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widget/snackbarmensajes.dart';

class FinalizarPage extends StatefulWidget {
  const FinalizarPage({super.key});

  @override
  State<FinalizarPage> createState() => _FinalizarPageState();
}

class _FinalizarPageState extends State<FinalizarPage> {
  final _nombreController = TextEditingController();

  String _tipoPago = 'Efectivo';

  Future<Uint8List> loadLogo() async {
    final ByteData data = await rootBundle.load('assets/logo.png');
    return data.buffer.asUint8List();
  }

  Future<void> _crearYDescargarPDF(PedidoProvider pedidoProvider) async {
    final pdf = pw.Document();
    final logo = pw.MemoryImage(await loadLogo());
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Logo
              pw.Center(child: pw.Image(logo, width: 80, height: 80)),
              pw.SizedBox(height: 10),
              // Datos de la empresa
              pw.Text(
                'FARMASALITRE',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text('CARRERA 8 # 13'),
              pw.Text('Santo Domingo Norte'),
              pw.Text('Cel: 809-111-3333'),
              pw.Text('REP DOM'),
              pw.SizedBox(height: 10),
              // Datos del cliente
              pw.Text('Nro Cliente: 00000000001'),
              pw.Text('Cliente: CLIENTE DE MOSTRADOR'),
              pw.Text('vie - 01/05/20 - 11:48:33 p. m.'),
              pw.Text('PV: 0001'),
              pw.Text('Cajero: CAJERO PRINCIPAL'),
              pw.Text('Nro: 00000010'),
              pw.SizedBox(height: 20),
              // Tabla de productos
              pw.Table.fromTextArray(
                border: pw.TableBorder.all(),
                cellAlignment: pw.Alignment.center,
                headers: ['CANT', 'DESCRIPCION', 'PRECIO', 'TOTAL'],
                data: [
                  ['1', 'PRUEBA', '1,793', '1,793'],
                  ['1', 'AZITROMICINA 500mg', '9,450', '9,450'],
                  ['8', 'RECTIFICAR ASIENTOS', '35,510', '35,510'],
                ],
              ),
              pw.SizedBox(height: 20),
              // Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('TOTAL = ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('122,559',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Gracias por su compra',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    try {
      final directory = await getExternalStorageDirectory();
      final path = '${directory!.path}/factura_pedido.pdf';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());
      final result = await OpenFile.open(path);

      if (result.type == 'done') {
        print('PDF abierto correctamente.');
      } else {
        print('Error al abrir el PDF: ${result.message}');
      }
    } catch (e) {
      print('Error al guardar o abrir el archivo PDF.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = Provider.of<PedidoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pizza seleccionada:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      pedidoProvider.pizza?.tipo ?? 'No seleccionada',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ingredientes:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (pedidoProvider.pizza?.ingredientes.isNotEmpty ?? false)
                      ...pedidoProvider.pizza!.ingredientes.map((ingrediente) {
                        return Text(
                          '- ${ingrediente.ingrediente ?? 'N/A'}',
                          style: const TextStyle(fontSize: 16),
                        );
                      })
                    else
                      const Text(
                        'No se seleccionaron ingredientes',
                        style: TextStyle(fontSize: 16),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _tipoPago,
              onChanged: (String? newValue) {
                setState(() {
                  _tipoPago = newValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Tipo de Pago',
                border: OutlineInputBorder(),
              ),
              items: <String>['Efectivo', 'Tarjeta']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                pedidoProvider.finalizarPedido(
                  _nombreController.text,
                  _tipoPago,
                );
                await _solicitarPermisos();
                _crearYDescargarPDF(pedidoProvider);
              },
              child: const Text('Confirmar Pedido'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _solicitarPermisos() async {
    if (await Permission.storage.request().isGranted) {
      // Permiso concedido
    } else {
      // Permiso denegado, maneja la situación
    }
  }

  void mensajes(String mensaje) {
    Utils.showSnackBar(context, mensaje, 3);
  }
}
