import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore database = FirebaseFirestore.instance;
//
addUser() async {
  await database.collection("Chats").get().then((value) => print(value.docs.length));

}