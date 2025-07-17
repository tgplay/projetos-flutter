import 'package:flutter/material.dart';

void main() => runApp(MeuApp());

class MeuApp extends StatelessWidget {
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
                      children: [
                        Text('Kotel'),
                        Text('Jerusalém, Israel'),
                      ],
                    ),
                  ),
                  Row(
                    children: [Icon(Icons.star, color: Colors.blue), Text('5')],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
