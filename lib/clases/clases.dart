class Pizza {
  final String tipo;
  final List<Ingrediente> ingredientes;

  Pizza({required this.tipo, required this.ingredientes});
}

class Pedido {
  Pizza? pizza;
  String? nombre;
  String? tipoPago;

  Pedido({this.pizza, this.nombre, this.tipoPago});
}

class Ingrediente {
  String? pizza;
  String? ingrediente;

  Ingrediente({
    this.pizza,
    this.ingrediente,
  });
}
