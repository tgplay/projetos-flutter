import 'package:flutter/material.dart';

void main() => runApp(MeuApp());

class MeuApp extends StatelessWidget {
  callAction() {
    // Ação para o botão de ligar
    print('Ligar pressionado');
  }

  mapAction() {
    // Ação para o botão de mapa
    print('Mapa pressionado');
  }

  shareAction() {
    // Ação para o botão de compartilhar
    print('Compartilhar pressionado');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Meu primeiro App'),
        ),
        body: Column(
          children: [
            Image.asset('assets/muro.jpg'),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Kotel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Jerusalém, Israel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.star,
                        color: Colors.blue,
                      ),
                      Text('9,786'),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Botao(
                    icon: Icons.call,
                    text: 'Ligar',
                    onPress: callAction,
                  ),
                  const SizedBox(width: 10), // Espaçamento entre os botões
                  Botao(
                      icon: Icons.location_on,
                      text: 'Mapa',
                      onPress: mapAction),
                  const SizedBox(width: 10), // Espaçamento entre os botões
                  Botao(
                    icon: Icons.share,
                    text: 'Compartilhar',
                    onPress: shareAction,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'O Muro das Lamentações, também conhecido como Kotel, é um local sagrado para o judaísmo, localizado em Jerusalém. É o único remanescente do Segundo Templo de Jerusalém e é um destino de peregrinação para judeus de todo o mundo.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Botao extends StatelessWidget {
  Botao({
    this.onPress,
    required this.icon,
    required this.text,
  });

  Function()? onPress;
  IconData icon;
  String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Inserir um botão dentro de um Expanded
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.blue,
            ),
            Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
