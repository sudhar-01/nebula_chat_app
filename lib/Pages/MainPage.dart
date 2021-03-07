import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nebula/Pages/GoupChatPage.dart';
import 'package:nebula/Pages/PesonalChat.dart';
import 'package:nebula/main.dart';
import 'package:nebula/backend/pics.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nebula/backend/FireBase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with SingleTickerProviderStateMixin {
  var chatPage;
  TabController tabController;
  String _token;
  @override
  void initState() {
   FirebaseMessaging().getToken().then((value) {
     _token = value;
   });
    tabController = TabController(length: 2, vsync: this, initialIndex: 0)
   ..addListener(() {
     setState(() {

    });});
    database.collection("Online").doc(auth.currentUser.uid).get().then((value){
      if(!value.exists)
      {
        database.collection("Online").doc(auth.currentUser.uid).set(
            {
              auth.currentUser.uid.toString(): auth.currentUser.uid.toString()
            });
      }

    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      database.collection("Users").doc(auth.currentUser.uid).get().then((value) {
        if (!value.exists) {
          if(auth.currentUser.emailVerified) {
            database.collection("Users").doc(auth.currentUser.uid).set({
              "Id": auth.currentUser.uid,
              "Name": auth.currentUser.displayName,
              "token": _token
            });
          }
        }
      });
    });

    chatPage = database.collection("Chats").snapshots();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(auth.currentUser.displayName == "" || auth.currentUser.displayName == null){
        print("display name is null");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your name is null...Please update or resubmit your name in Profile page"),duration: Duration(seconds: 4),backgroundColor: Colors.red,));
      }
      database.collection("Users").doc(auth.currentUser.uid).get().then((value) {
        if(value.data()["Name"].toString() == null){
          print("username is null");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your name is null...Please update or resubmit your name in Profile page"),duration: Duration(seconds: 4),backgroundColor: Colors.red,));

        }
      });

    });

  }
  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
   
  

  @override
  Widget build(BuildContext context) {
    print(auth.currentUser);
    return Scaffold(
      floatingActionButton: (tabController.index == 0)?
      FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "AddSingleUser"),
        backgroundColor: Theme.of(context).primaryColorDark,
        isExtended: true,
        child: Icon(Icons.add,color: Colors.white,size: GFS(30,context))):
      FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, 'AddUserPage');
        },
        backgroundColor: Theme.of(context).primaryColorDark,
        icon: Icon(Icons.add,color: Colors.white,size: GFS(30,context)),
        label: Text(
                      "Add group",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: GFS(20, context),
                          color: Colors.white),
                    ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.loose,
          children: [
            BehindBack(),  ///backGround
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.04),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.9 *
                                      0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  child: SvgPicture.asset(
                                    lightbulbIcon,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                onTap: () {
                                    changeBrightness();
                                }),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9 * 0.2,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                  onPressed:() => Navigator.pushNamed(context, "ProfilePage")),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0)),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TabBar(
                                    indicatorColor: Theme.of(context).secondaryHeaderColor,
                                    labelColor: Theme.of(context).secondaryHeaderColor,
                                    unselectedLabelColor:Theme.of(context).textTheme.headline1.color ,
                                    controller: tabController,
                                    tabs: [
                                      Text(
                                        "Chat",
                                        style: GoogleFonts.ubuntu(textStyle: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: GFS(21, context)
                                          ),
                                        )
                                      ),
                                      Text(
                                        "Group",
                                          style: GoogleFonts.ubuntu(textStyle: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: GFS(21, context)
                                          ),
                                          )
                                      ),
                                    ]),
                              ),
                            ),      ///Section Bar
                            Expanded(
                              flex: 9,
                              child: Container(

                                child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    PersonalChat(),///Personnel Chat
                                    GroupChat()///Group chat
                                  ],
                                ),
                              ),
                            )

                          ],
                        ),
                      )),///Nebula title
                    ///Chats Block
                ],
              ),
            )  ///Front
          ],
        ),
      ),
    );
  }

  void changeBrightness() {
    DynamicTheme.of(context).setTheme(Theme.of(context).brightness == dark.brightness? 0:1);
  }

}
changeTheme() {
  themeState = (themeState == light) ? dark : light;
  return themeState;
}
class BehindBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Color(0xFF777BFC),
            Color(0xFF48A6E2),
            Color(0xFF4BC4FF),
            Color(0xFF3C3E7E)
          ])),
    );
  }
}


String fetchLastMessage(String user1 ,String user2) {
  String docu1;
  String msg;
  Future collect = database.collection("Chats").get().then((value) {
    var usersinChat = value.docs.map((e) => e.id).toList();
    docu1 = usersinChat.singleWhere((element) => ((element == user1 +  user2) || (element ==  user2 + user1)),orElse: ()
    => user1 + user2
    );
  }).then((value) {
    database.collection("Chats").doc(docu1).get().then((value) {
    msg = value.data()["lastMessage"].toString();

    });
  });

  if(msg == null){
    return "...";
  }
  else return msg;
}



