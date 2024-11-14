import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tea_dairy/pages/bill_history_page.dart';
import 'package:tea_dairy/pages/seller_page.dart';

import 'Manage_menu_item_page.dart';
import 'new_order_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<Map<String, dynamic>> fetchMonthlyData() async {
    num teaCoffeeCount = 0;
    num totalAmount = 0;

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('timestamp', isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month))
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        teaCoffeeCount += (data['teaQuantity'] ?? 0) + (data['bournvitaQuantity'] ?? 0);
        totalAmount += data['grandTotal'] ?? 0;
      }
    } catch (e) {
      print("Error fetching monthly data: $e");
    }

    return {
      'teaCoffeeCount': teaCoffeeCount,
      'totalAmount': totalAmount,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchMonthlyData(),
      builder: (context, snapshot) {
        num teaCoffeeCount = 0;
        num totalAmount = 0;

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          teaCoffeeCount = (snapshot.data!['teaCoffeeCount'] ?? 0) as int;
          totalAmount = (snapshot.data!['totalAmount'] ?? 0) as int;
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),
            ),
            onPressed: () {},
            backgroundColor: Colors.brown,
            child: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.brown,
            title: const Text(
              "Tea Diary",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 300,
                      width: 190,
                      decoration: const BoxDecoration(
                        color: Colors.brown,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(teaCoffeeCount.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 28)),
                          const Text("Tea/Coffee\n in August",
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Container(
                      height: 300,
                      width: 190,
                      decoration: const BoxDecoration(
                        color: Colors.brown,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("\u20b9 $totalAmount",
                              style: const TextStyle(color: Colors.white, fontSize: 28)),
                          const Text("Amount of\n August",
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SellerPage()));
                      },
                      child: SizedBox(
                        height: 120,
                        width: 130,
                        child: Card(
                          elevation: 3,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people,
                                color: Colors.brown,
                                size: 40,
                              ),
                              Text(
                                "Sellers",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Item()));
                      },
                      child: SizedBox(
                        height: 120,
                        width: 130,
                        child: Card(
                          elevation: 3,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.library_books_outlined,
                                color: Colors.brown,
                                size: 34,
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                "Item",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 120,
                        width: 130,
                        child: Card(
                          elevation: 3,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.emoji_people_outlined,
                                color: Colors.brown,
                                size: 34,
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                "Sellerwise Item",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewOrderPage()));
                      },
                      child: SizedBox(
                          height: 120,
                          width: 130,
                          child: Card(
                            elevation: 3,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.note_add_sharp,
                                  color: Colors.brown,
                                  size: 34,
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "New Order",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                        height: 120,
                        width: 130,
                        child: Card(
                          elevation: 3,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calculate_outlined,
                                color: Colors.brown,
                                size: 34,
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                "Generate Bill",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BillHistoryPage(),
                            ));
                      },
                      child: SizedBox(
                          height: 120,
                          width: 130,
                          child: Card(
                            elevation: 3,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  color: Colors.brown,
                                  size: 34,
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "Bill History",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
