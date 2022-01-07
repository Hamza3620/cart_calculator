import 'package:cart_calculator/product_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cart Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> productsList = [
    Product(0, "Milk", 1, 1.5),
    Product(1, "Biscuits", 2, 2)
  ];
  double total = 0;
  double calculateTotal() {
    total = 0;
    for (int i = 0; i < productsList.length; i++) {
      total += (productsList[i].quanity * productsList[i].price);
    }
    return total;
  }

  @override
  void initState() {
    calculateTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cart Calculator"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        index == 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  rowHeader("Product Name"),
                                  rowHeader("Quantity"),
                                  rowHeader("Price"),
                                ],
                              )
                            : Container(),
                        Container(
                          color:
                              index % 2 == 0 ? Colors.grey[300] : Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              rowItem(productsList[index].name),
                              rowItem("${productsList[index].quanity}"),
                              rowItem("\$${productsList[index].price}"),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              color: Colors.yellow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Total",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    "\$$total",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ));
  }

  rowHeader(String text) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ));
  }

  rowItem(String text) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    ));
  }
}
