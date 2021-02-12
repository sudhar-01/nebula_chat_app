import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore database = FirebaseFirestore.instance;

addUser() {
  // database.collection("Online").doc(auth.currentUser.uid).get().then((value){
  //   if(!value.exists)
  //   {
  //     database.collection("Online").doc(auth.currentUser.uid).set(
  //         {
  //           auth.currentUser.uid.toString(): auth.currentUser.uid.toString()
  //         });
  //   }
  //
  // });
    database.collection("Users").doc(auth.currentUser.uid).get().then((value) {
        if(auth.currentUser.emailVerified){
          if (!value.exists) {
          database.collection("Users").doc(auth.currentUser.uid).set({
            "Id": auth.currentUser.uid,
            "Name": auth.currentUser.displayName,
          });

        }

        // database.collection("Users").add(
        //    {
        //      "Id": auth.currentUser.uid,
        //      "Name": auth.currentUser.displayName,
        //    });
      }
    });
}