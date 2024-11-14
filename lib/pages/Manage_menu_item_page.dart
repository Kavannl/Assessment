import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  Item({super.key});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {

  TextEditingController coffeeController = TextEditingController();
  TextEditingController teaController = TextEditingController();
  TextEditingController bournvitaController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController newItemController = TextEditingController();


  String coffeePrice = "10";
  String teaPrice = "10";
  String bournvitaPrice = "10";


  List<Map<String, dynamic>> menuItems = [];


  List<String> options = [];
  String? selectedOption;


  bool isChecked = false;
  bool isChecked2 = false;
  bool isChecked3 = false;

  @override
  void initState() {
    super.initState();
    fetchOptions();
    fetchMenuItems();
  }

  Future<void> fetchOptions() async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('options')
          .doc('name')
          .get();

      final data = snapshot.data() as Map<String, dynamic>;

      setState(() {
        options = data.values.map((value) => value.toString()).toList();
      });
    } catch (e) {
      print("Error fetching options: $e");
    }
  }

  Future<void> fetchMenuItems() async {
    try {
      final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('menu_items').get();

      setState(() {
        menuItems = snapshot.docs
            .map((doc) => {
          "item": doc['item'],
          "price": doc['price'],
        })
            .toList();
      });
    } catch (e) {
      print("Error fetching menu items: $e");
    }
  }

  Future<void> addNewItem(String item, String price) async {
    try {
      final CollectionReference itemCollection =
      FirebaseFirestore.instance.collection("menu_items");
      await itemCollection.add({
        "item": item,
        "price": price,
      });
      print("Item added successfully!");
      fetchMenuItems(); // Refresh list after adding new item
    } catch (e) {
      print("Error adding item: $e");
    }
  }

  void showDialogForNewItem() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: "Item"),
                controller: newItemController,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Price"),
                controller: newPriceController,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                addNewItem(
                  newItemController.text.trim(),
                  newPriceController.text.trim(),
                );
                newItemController.clear();
                newPriceController.clear();
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Show
  void showDialogForPriceUpdate(TextEditingController controller, Function(String) onSave) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Enter new price"),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: Text("Save", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.brown,
        title: const Text(
          "Manage Menu Item",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: 420,
              child: Card(
                elevation: 3,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Tea Seller    :",
                      style: TextStyle(fontSize: 20, color: Colors.brown),
                    ),
                    DropdownButton<String>(
                      value: selectedOption,
                      hint: const Text("Select Seller"),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue;
                        });
                      },
                      items: options.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            buildItemRow("Tea", teaPrice, teaController, (newPrice) {
              setState(() {
                teaPrice = newPrice;
              });
            }, isChecked, (value) => setState(() => isChecked = value!)),
            buildItemRow("Coffee", coffeePrice, coffeeController, (newPrice) {
              setState(() {
                coffeePrice = newPrice;
              });
            }, isChecked2, (value) => setState(() => isChecked2 = value!)),
            buildItemRow("Bournvita", bournvitaPrice, bournvitaController, (newPrice) {
              setState(() {
                bournvitaPrice = newPrice;
              });
            }, isChecked3, (value) => setState(() => isChecked3 = value!)),

            ...menuItems.map((menuItem) {
              return buildItemRow(
                menuItem['item'],
                menuItem['price'],
                TextEditingController(text: menuItem['price']),
                    (newPrice) {
                  setState(() {
                    menuItem['price'] = newPrice;
                  });
                },
                false,
                    (value) {},
              );
            }).toList(),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: showDialogForNewItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Add New Item",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemRow(String name, String price, TextEditingController controller,
      Function(String) onSave, bool isChecked, Function(bool?) onCheckboxChanged) {
    return SizedBox(
      height: 60,
      width: 420,
      child: Card(
        elevation: 3,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(width: 20),
            Text(name, style: TextStyle(fontSize: 18)),
            Spacer(),
            GestureDetector(
              onTap: () {
                showDialogForPriceUpdate(controller, onSave);
              },
              child: Text(price, style: TextStyle(fontSize: 18)),
            ),
            SizedBox(width: 20),
            Checkbox(value: isChecked, onChanged: onCheckboxChanged),
          ],
        ),
      ),
    );
  }
}
