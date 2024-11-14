import 'package:cloud_firestore/cloud_firestore.dart';

class firestore{
  final CollectionReference firestores =
      FirebaseFirestore.instance.collection("seller details");

  //create
  Future<void> addToSellerList(String name,String phone,String Address){
    return firestores.add({
      "name": name,
      "phone no": phone,
      "address" : Address,
      "timestamp" : Timestamp.now(),
    });
  }
  Stream<QuerySnapshot> getSellerList(){
    final sellerlist =
        firestores.orderBy('timestamp',descending: true).snapshots();
    return sellerlist;
  }
}