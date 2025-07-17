import 'package:flutter/material.dart';
// import 'package:flutter_animations/models/product.dart';
import 'package:google_maps_card/models/product.dart';

class ExpansionPage extends StatefulWidget {
  const ExpansionPage({Key? key}) : super(key: key);

  @override
  State<ExpansionPage> createState() => _ExpansionPageState();
}

class _ExpansionPageState extends State<ExpansionPage> {
  final List<Product> _products = Product.generateItems(2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ExpansionPanelList.radio(
            expansionCallback: (int index, bool isExpanded) {
              setState(() => _products[index].isExpanded = !isExpanded);
            },
            children: _products.map<ExpansionPanel>((Product product) {
              return ExpansionPanelRadio(
                // isExpanded: product.isExpanded,
                value: product.id,
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    leading: CircleAvatar(child: Text(product.id.toString())),
                    title: Text(product.title),
                  );
                },
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(product.description),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Comprar'),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
