import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewOrderPage extends StatefulWidget {
  NewOrderPage({super.key});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  int currentIndex = 1;
  int currentIndexforbvt = 1;
  int bournvitaTotal = 25;
  int teaTotal = 10;

  void incqty() {
    currentIndex++;
    setState(() {
      teaTotal = currentIndex * 10;
    });
  }

  void decqty() {
    if (currentIndex > 1) {
      currentIndex--;
      setState(() {
        teaTotal = currentIndex * 10;
      });
    }
  }

  void inc() {
    currentIndexforbvt++;
    setState(() {
      bournvitaTotal = currentIndexforbvt * 25;
    });
  }

  void dec() {
    if (currentIndexforbvt > 1) {
      currentIndexforbvt--;
      setState(() {
        bournvitaTotal = currentIndexforbvt * 25;
      });
    }
  }

  List<String> options = [];
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    fetchOptions();
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

  Future<void> placeOrder() async {
    try {

      final order = {
        'seller': selectedOption,
        'teaQuantity': currentIndex,
        'teaTotal': teaTotal,
        'bournvitaQuantity': currentIndexforbvt,
        'bournvitaTotal': bournvitaTotal,
        'grandTotal': (currentIndex * 10 + bournvitaTotal),
        'timestamp': FieldValue.serverTimestamp(),
      };


      await FirebaseFirestore.instance.collection('orders').add(order);


      setState(() {
        currentIndex = 1;
        currentIndexforbvt = 1;
        teaTotal = 10;
        bournvitaTotal = 25;
        selectedOption = null;
      });
    } catch (e) {
      print("Error placing order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          "New Order",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
            width: 420,
            child: Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
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
          SizedBox(
            height: 320,
            width: 420,
            child: Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        SizedBox(width: 16),
                        Text("Menu",
                            style:
                            TextStyle(fontSize: 20, color: Colors.brown)),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("ITEM",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      Text("QUANTITY",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      Text("PRICE",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 40),
                        const Text("Tea",
                            style:
                            TextStyle(color: Colors.brown, fontSize: 18)),
                        const SizedBox(width: 60),
                        InkWell(
                          onTap: decqty,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration:
                            BoxDecoration(color: Colors.grey.shade400),
                            child: const Icon(Icons.remove, size: 14),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(currentIndex.toString(),
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: incqty,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration:
                            BoxDecoration(color: Colors.grey.shade400),
                            child: const Icon(Icons.add, size: 14),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.close),
                        const SizedBox(width: 5),
                        const Text("10", style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 15),
                        const Text("=", style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 15),
                        Text(teaTotal.toString(),
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 40),
                        const Text("Bournvita",
                            style:
                            TextStyle(color: Colors.brown, fontSize: 18)),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: dec,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration:
                            BoxDecoration(color: Colors.grey.shade400),
                            child: const Icon(Icons.remove, size: 14),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(currentIndexforbvt.toString(),
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: inc,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration:
                            BoxDecoration(color: Colors.grey.shade400),
                            child: const Icon(Icons.add, size: 14),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.close),
                        const SizedBox(width: 5),
                        const Text("25", style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 15),
                        const Text("=", style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 15),
                        Text(bournvitaTotal.toString(),
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(fontSize: 18)),
                        Text("\u20b9 ${(currentIndex * 10 + bournvitaTotal)}",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.green)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                      ),
                      onPressed: placeOrder,
                      child: const Text("Place Order",
                          style: TextStyle(color: Colors.white, fontSize: 18))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
