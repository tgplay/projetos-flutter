void main() {
  String nome = "Laranja";
  double peso = 100.2;
  String corFruta = "Verde e Amarela";
  String sabor = "Doce e Cítrica";
  int diasDesdeColheita = 20;
  bool isMadura = funcEstaMadura(diasDesdeColheita);

  print(isMadura);
}

// funcao funcEstaMadura, que vai devolver algo do tipo bool(verdadeiro ou falso)
// e está recebendo o parametro dias que é do tipo int(inteiro)

// Esse função é como se fosse uma maquina de dizer verdadeiro ou falso com base na informação que ela está recebendo. Nesse caso, se a fruta está madura ou não com base na quantidade de dias desde a colheita.

// O nome do parametro não precisa ser o mesmo nome da variável que está sendo passada para a função. O importante é o tipo de dado que está sendo passado. Nesse caso, tanto a variável diasDesdeColheita quanto o parametro "dias" são do tipo int.
bool funcEstaMadura(int dias) {
  if (dias >= 30) {
    return true;
  } else {
    return false;
  }
}
