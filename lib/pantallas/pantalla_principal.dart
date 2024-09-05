import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../clases/clases.dart';
import '../../provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 40),
            const SizedBox(width: 10),
            const Text('Jubert Pizza',
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Elija el tipo de pizza:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPizzaOption(
                    context,
                    'Vegetariana',
                    'assets/vegetariana.png',
                    () {
                      Provider.of<PedidoProvider>(context, listen: false)
                          .seleccionarPizza(
                              Pizza(tipo: 'Vegetariana', ingredientes: []));
                      Navigator.pushNamed(context, '/ingredientes');
                    },
                  ),
                  _buildPizzaOption(
                    context,
                    'Normal',
                    'assets/normales.png',
                    () {
                      Provider.of<PedidoProvider>(context, listen: false)
                          .seleccionarPizza(
                              Pizza(tipo: 'Normal', ingredientes: []));
                      Navigator.pushNamed(context, '/ingredientes');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPizzaOption(BuildContext context, String title, String imagePath,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, height: 120),
              const SizedBox(height: 10),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
