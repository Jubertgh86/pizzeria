import 'package:flutter/material.dart';
import 'pantallas/pantalla_ingredientes.dart';
import 'package:provider/provider.dart';

import 'pantallas/pantalla_fin_orden.dart';
import 'pantallas/pantalla_principal.dart';
import 'provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PedidoProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Jubert Pizza',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomePage(),
          routes: {
            '/ingredientes': (context) => const IngredientesPage(),
            '/finalizar': (context) => const FinalizarPage(),
          },
        ));
  }
}
