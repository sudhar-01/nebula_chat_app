import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nebula/backend/FireBase.dart';
import 'package:nebula/main.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController controllerName;
  TextEditingController controllerEmail;
  TextEditingController controllerToken;
  var _token;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging().getToken().then((value) {
      _token = value;
      controllerToken = TextEditingController(text: _token);
    }).whenComplete(() {
      setState(() {

      });
    });
    if(auth.currentUser != null){
      controllerName = TextEditingController(text: auth.currentUser.displayName.toString());
      controllerEmail = TextEditingController(text:auth.currentUser.email.toString());
    }


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
         leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
         title: Text("Profile",
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: GFS(26, context),
                color: Colors.white),
          )),
    ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                    child: Container(
                      child: Stack(
                        children: [
                          Container(color: Colors.red,),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: IconButton(icon: FaIcon(FontAwesomeIcons.camera,color: Colors.white,), onPressed: () => null),
                          )
                        ],
                      ),

                    )),
                Expanded(
                  flex: 7,
                    child: Container(
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  MediaQuery.of(context).size.width * 0.07,
                                  vertical: MediaQuery.of(context).size.height*0.025),
                              child: TextField(
                                focusNode: FocusNode(
                                    canRequestFocus: false,
                                    descendantsAreFocusable: false),
                                controller: controllerName,
                                decoration: InputDecoration(
                                  labelText: "NAME",
                                  focusColor: Theme.of(context).secondaryHeaderColor,
                                  hoverColor: Theme.of(context).secondaryHeaderColor,
                                  fillColor: Theme.of(context).secondaryHeaderColor,
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: GFS(14, context)
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.headline1.color,
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                    GFS(17, context)),
                                maxLines: 1,
                                toolbarOptions: ToolbarOptions(
                                    copy: true, paste: true, selectAll: true),
                                onSubmitted: (text) {
                                  auth.currentUser.updateProfile(displayName: text);
                                  database.collection("Users").doc(auth.currentUser.uid).update({
                                    "Id": auth.currentUser.uid,
                                    "Name": text,
                                    "token": _token
                                  });
                                  setState(() {
                                    controllerName.text = text;
                                  });
                                },
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  MediaQuery.of(context).size.width * 0.07,
                                  vertical:MediaQuery.of(context).size.height*0.025),
                              child: TextField(
                                controller: controllerEmail,
                                decoration: InputDecoration(
                                  labelText: "E-MAIL",
                                  focusColor: Theme.of(context).secondaryHeaderColor,
                                  hoverColor: Theme.of(context).secondaryHeaderColor,
                                  fillColor:Theme.of(context).secondaryHeaderColor,
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: GFS(14, context)),
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.headline1.color,
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                    GFS(17, context)),
                                maxLines: 1,
                                toolbarOptions: ToolbarOptions(
                                    copy: true, paste: true, selectAll: true),
                                onSubmitted: (text) {
                                  setState(() {
                                    controllerEmail.text = text;
                                  });
                                },
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  MediaQuery.of(context).size.width * 0.07,
                                  vertical:MediaQuery.of(context).size.height*0.025),
                              child: TextField(
                                readOnly: true,
                                controller: controllerToken,
                                decoration: InputDecoration(
                                  labelText: "TOKEN",
                                  focusColor: Theme.of(context).secondaryHeaderColor,
                                  hoverColor:Theme.of(context).secondaryHeaderColor,
                                  fillColor: Theme.of(context).secondaryHeaderColor,
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: GFS(14, context)),
                                  contentPadding: EdgeInsets.zero,
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color:Theme.of(context).textTheme.headline1.color,
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                    GFS(17, context)),
                                maxLines: 1,
                                toolbarOptions: ToolbarOptions(
                                    copy: true, paste: true, selectAll: true),
                                onSubmitted: (text) {
                                  setState(() {
                                    controllerToken.text = text;
                                  });
                                },
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.04),
                            child: InkWell(
                              onTap: () {
                                auth.signOut().then((value) {
                                  Navigator.popAndPushNamed(
                                    context,
                                      'LoginSection'
                                    // MaterialPageRoute(
                                    //     builder: (BuildContext context) =>
                                    //         Profile(),
                                    //     maintainState: false),
                                    // ModalRoute.withName('LoginSection'),
                                  );
                                });
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                        color: Theme.of(context).secondaryHeaderColor)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Log out",
                                      style: TextStyle(
                                          fontSize: GFS(16, context),
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).secondaryHeaderColor),
                                    ),
                                    Icon(
                                      Icons.exit_to_app,
                                      color: Theme.of(context).secondaryHeaderColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                )
              ],
            ),

    ),
        ),
    );
  }
}
