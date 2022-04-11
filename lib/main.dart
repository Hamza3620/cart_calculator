import 'package:cart_calculator/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productQuantityController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: FloatingActionButton(
            onPressed: () async {
              await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              //if any of the fields are empty we abort the process of new product addition
                              if (!(_productNameController.text.isEmpty ||
                                  _productQuantityController.text.isEmpty ||
                                  _productPriceController.text.isEmpty)) {
                                Product newProduct = Product(
                                    productsList.length,
                                    _productNameController.text,
                                    int.parse(_productQuantityController.text),
                                    double.parse(_productPriceController.text));
                                setState(() {
                                  _productNameController.clear();
                                  _productQuantityController.clear();
                                  _productPriceController.clear();
                                  productsList.add(newProduct);
                                  calculateTotal();
                                });
                              } else {
                                print("Empty values not allowed");
                              }

                              for (int i = 0; i < productsList.length; i++) {
                                print(
                                    "${productsList[i].id} ${productsList[i].name}");
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text("ADD"))
                      ],
                      elevation: 6,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Add a new product'),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close))
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextField(
                              onChanged: (value) {},
                              controller: _productNameController,
                              maxLength: 30,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  hintText: "Product name"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextField(
                              onChanged: (value) {},
                              controller: _productQuantityController,
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  hintText: "Product quantity"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextField(
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (double.parse(value) < 999.99) {
                                    print(value);
                                  } else {
                                    _productPriceController.clear();
                                  }
                                }
                              },
                              controller: _productPriceController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  hintText: "Product price"),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: const Icon(Icons.add),
          ),
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
