import 'package:flutter/material.dart';

import '../clases/clases.dart';

class PedidoProvider extends ChangeNotifier {
  Pizza? _pizza;
  String? _nombre;
  String? _tipoPago;

  Pizza? get pizza => _pizza;
  String? get nombre => _nombre;
  String? get tipoPago => _tipoPago;

  void seleccionarPizza(Pizza pizza) {
    _pizza = pizza;
    notifyListeners();
  }

  void agregarIngrediente(Ingrediente ingrediente) {
    _pizza?.ingredientes.add(ingrediente);
    notifyListeners();
  }

  void finalizarPedido(String nombre, String tipoPago) {
    _nombre = nombre;
    _tipoPago = tipoPago;
    notifyListeners();
  }
}
