import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../clases/clases.dart';
import '../provider/provider.dart';
import '../widget/snackbarmensajes.dart';

class IngredientesPage extends StatefulWidget {
  const IngredientesPage({super.key});

  @override
  State<IngredientesPage> createState() => _IngredientesPageState();
}

class _IngredientesPageState extends State<IngredientesPage> {
  final List<Ingrediente> ingredientesDisponibles = [
    Ingrediente(pizza: 'Vegetariana', ingrediente: 'Pimiento'),
    Ingrediente(pizza: 'Vegetariana', ingrediente: 'Tofu'),
    Ingrediente(pizza: 'Normal', ingrediente: 'Jamon'),
    Ingrediente(pizza: 'Normal', ingrediente: 'Peperoni')
  ];

  @override
  Widget build(BuildContext context) {
    final pizza = Provider.of<PedidoProvider>(context).pizza;
    final ingredientesDePizza =
        ingredientesDisponibles.where((e) => e.pizza == pizza!.tipo).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccione los Ingredientes'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: ingredientesDePizza.length,
              itemBuilder: (context, index) {
                final ingrediente = ingredientesDePizza[index];
                return GestureDetector(
                  onTap: () {
                    Provider.of<PedidoProvider>(context, listen: false)
                        .agregarIngrediente(ingrediente);
                    mensajes(
                        '${ingrediente.ingrediente} ha sido agregado a su pizza.');
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/${ingrediente.ingrediente!.toLowerCase()}.png',
                          height: 80,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ingrediente.ingrediente!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/finalizar');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Finalizar Pedido'),
            ),
          ),
        ],
      ),
    );
  }

  void mensajes(String mensaje) {
    Utils.showSnackBar(context, mensaje, 3);
  }
}
