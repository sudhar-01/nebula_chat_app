import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nebula/Pages/AddSingleUser.dart';
import 'package:nebula/Pages/AddUsers.dart';
import 'package:nebula/Pages/GroupInChats.dart';
import 'package:nebula/Pages/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nebula/Pages/MainPage.dart';
import 'package:nebula/Pages/InChatPage.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:nebula/Pages/PesonalChat.dart';

void main() async{
 WidgetsFlutterBinding.ensureInitialized();
 SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
 await Firebase.initializeApp();
  runApp(MyApp());
}



ThemeData light = ThemeData.light().copyWith(
  primaryColorLight: Color(0xFFE6E6FF),
  primaryColor: Color(0xFF777BFC),
  cardColor: Colors.white,
  primaryColorDark: Color(0xFF777BFC),
  secondaryHeaderColor: Color(0xFF364AFF),
  accentColor: Colors.white,
  textTheme: TextTheme(
      headline1: TextStyle(color: Colors.black)
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData themeState = light;

ThemeData dark = ThemeData.dark().copyWith(
  primaryColor: Color(0xFF464646),
  primaryColorLight: Color(0xFF000000),
  primaryColorDark: Color(0xFF28295D),
  cardColor: Color(0xFF4F4F4F),
  accentColor: Colors.black,
  textTheme: TextTheme(
    headline1: TextStyle(color: Colors.white)
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
      themeCollection:ThemeCollection(
          themes:{
        0:light,
        1:dark
      },
        fallbackTheme: light
      ),
    builder: (context,theme) =>
      new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nebula',
        theme: changeTheme(),
        initialRoute: (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.emailVerified )?'ChatPage':'LoginSection',
        //initialRoute: 'ChatPage',
        routes: {
          'LoginSection':(context) => Login(),
          'ChatPage':(context) => Chats(),
          'InchatPage':(context) => InChat(),
          'AddUserPage':(context) => AddUser(),
          "PersonnelChat":(context) =>PersonalChat(),
          "GroupInChat":(context) => GroupInChat(),
          "AddSingleUser":(context) => AddSingleUser()
        },
      ),
     );
  }
}


double GFS(double i,BuildContext context){
  return (MediaQuery.of(context).size.width *
      MediaQuery.of(context).devicePixelRatio) < 1080
      ? (i * 1.5) / (MediaQuery.of(context).devicePixelRatio)
      : (MediaQuery.of(context).size.width *
      MediaQuery.of(context).devicePixelRatio) > 1080
      ? (i * 3) / (MediaQuery.of(context).devicePixelRatio)
      : (i * 2.5) / (MediaQuery.of(context).devicePixelRatio);

}

String username = '';
String password = '';
String name = '';

