import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tea_dairy/service/firestore.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final firestore fire = firestore();

  void openDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: 190,
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  "Add New Seller",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Name",
              ),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                hintText: "Mobile No.",
              ),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                hintText: "Address",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(horizontal: 60),
              ),
              onPressed: () {
                fire.addToSellerList(
                  nameController.text,
                  phoneController.text,
                  addressController.text,
                );
                nameController.clear();
                phoneController.clear();
                addressController.clear();
                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(horizontal: 55),
                ),
                onPressed: (){
                  Navigator.pop(context);
                  },
                child: const Text("Cancel", style: TextStyle(color: Colors.white),)
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: openDialog,
          ),
        ],
        backgroundColor: Colors.brown,
        title: const Text(
          "Seller List",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fire.getSellerList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No sellers available"));
          }

          // Printing the document list for debugging
          print("Documents in snapshot: ${snapshot.data!.docs}");

          List<DocumentSnapshot> sellerList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: sellerList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = sellerList[index];
              String docID = document.id;

              // Check document data structure
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              String sellerName = data['name'] ?? 'No Name';
              String sellerPhone = data['phone no'] ?? 'No Phone';
              String sellerAddress = data['address'] ?? 'No Address';

              return ListTile(
                title: Text(sellerName),
                subtitle: Text('Phone: $sellerPhone\nAddress: $sellerAddress'),
              );
            },
          );
        },
      ),
    );
  }
}
