
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore database = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

//
addUser() async {
  await database.collection("Chats").get().then((value) => print(value.docs.length));

}



addImage(File _image) {
  var _token1;
  FirebaseMessaging().getToken().then((value) {
    _token1 = value;
    storage.ref().child("Profile/${auth.currentUser.uid}.png")
        .putFile(_image)
        .then((value) {
      value.ref.getDownloadURL().then((url) {
        database.collection("Users").doc(auth.currentUser.uid).update({
        "Id": auth.currentUser.uid,
        "Name": auth.currentUser.displayName,
        "token": _token1,
        "ProfilePic": url.toString()
      });
      });
    });
  });
}

class ProFilePic extends StatefulWidget {
  final String id;

  const ProFilePic({Key key, this.id}) : super(key: key);
  @override
  _ProFilePicState createState() => _ProFilePicState(id);
}

class _ProFilePicState extends State<ProFilePic> {
  final String id;
  String pic;

  _ProFilePicState(this.id);
  @override
  Widget build(BuildContext context) {
    getImage(id);
    return CircleAvatar(
        backgroundImage:
      NetworkImage(
          (pic!=null)?pic:"https://thumbs.dreamstime.com/z/default-avatar-profile-flat-icon-social-media-user-vector-portrait-unknown-human-image-default-avatar-profile-flat-icon-184330869.jpg"
      ),
    );
  }

  getImage(String id) {
    database.collection("Users").doc(id).get().then((value) {
      setState(() {
         pic = value["ProfilePic"].toString();
      });
    });
  }
}

