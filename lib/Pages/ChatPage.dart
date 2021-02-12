import 'package:flutter/material.dart';
import 'package:nebula_chat_app/main.dart';
import 'package:nebula_chat_app/backend/pics.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nebula_chat_app/Pages/InChatPage.dart';
import 'package:nebula_chat_app/backend/FireBase.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with SingleTickerProviderStateMixin {
  var chatPage;
  TabController tabController;
  @override
  void initState() {

    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    database.collection("Online").doc(auth.currentUser.uid).get().then((value){
      if(!value.exists)
      {
        database.collection("Online").doc(auth.currentUser.uid).set(
            {
              auth.currentUser.uid.toString(): auth.currentUser.uid.toString()
            });
      }

    });
    database.collection("Users").doc(auth.currentUser.uid).get().then((value) {
        if (!value.exists) {
          if(auth.currentUser.emailVerified) {
          database.collection("Users").doc(auth.currentUser.uid).set({
            "Id": auth.currentUser.uid,
            "Name": auth.currentUser.displayName,
          });
        }
      }
      });
    chatPage = database.collection("Users").snapshots();
    if(auth.currentUser.displayName == null){
      auth.currentUser.updateProfile(displayName: name);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(auth.currentUser);
    print(auth.currentUser.emailVerified);
    return Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.04),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.07,
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
                                setState(() {
                                  themeState =
                                      (themeState == light) ? dark : light;
                                });
                              }),
                          Container(
                            width:
                                MediaQuery.of(context).size.width * 0.9 * 0.5,
                            height: MediaQuery.of(context).size.height * 0.07,
                            alignment: Alignment.center,
                            child: Text(
                              "nebuLa",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: GFS(35, context),
                                  shadows: [
                                    Shadow(
                                        offset: Offset(3.0, 4.0),
                                        blurRadius: 2.0)
                                  ],
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9 * 0.2,
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                onPressed: null),
                          )
                        ],
                      ),
                    ),
                  ),        ///Nebula title
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1.0,
                              blurRadius: 4.0)
                        ]),
                  ),      ///Search Bar
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: TabBar(
                        indicatorColor: Colors.transparent,
                        controller: tabController,
                        tabs: [
                          Text(
                            "Chat",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: GFS(17, context),
                                color: Colors.white),
                          ),
                          Text(
                            "Group",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: GFS(17, context),
                                color: Colors.white),
                          ),
                        ]),
                  ),      ///Section Bar
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1.0,
                              blurRadius: 4.0)
                        ]),
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        Container(
                          child: StreamBuilder(
                              stream: chatPage,
                              builder: (context, AsyncSnapshot snapshots) {
                                if (!snapshots.hasData)
                                  return Center(
                                      child: CircularProgressIndicator());
                                else
                                  return ListView.separated(
                                      itemBuilder: (context, int index) {
                                        if (snapshots
                                            .data.docs[index]["Name"]
                                            .toString() !=
                                            auth.currentUser.displayName
                                                .toString()) {
                                          return
                                            Center(
                                              child: InkWell(
                                                onTap: () =>
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                InChat(
                                                                  secondUserId: snapshots
                                                                      .data
                                                                      .docs[
                                                                  index]
                                                                  ["Id"]
                                                                      .toString(),
                                                                  SeconduserName: snapshots
                                                                      .data
                                                                      .docs[
                                                                  index]
                                                                  ["Name"]
                                                                      .toString(),
                                                                ))),
                                                child: Container(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height *
                                                      0.12,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width *
                                                      0.9,
                                                  decoration: BoxDecoration(
                                                      color: Theme
                                                          .of(context)
                                                          .cardColor,
                                                      // gradient: LinearGradient(begin: Alignment.centerLeft,end: Alignment.centerRight,colors: [Color(0xFFD5DAFF),Color(0xFFE0ECFF),Color(0xFFD8DEFF),Color(0xFFE7EDFF),Color(0xFFD4C9FF),]),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors
                                                                .black26,
                                                            spreadRadius: 1.0,
                                                            blurRadius: 4.0,
                                                            offset:
                                                            Offset(2.0, 4.0))
                                                      ]),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        height:
                                                        MediaQuery
                                                            .of(context)
                                                            .size
                                                            .height *
                                                            0.11 *
                                                            0.75,
                                                        width:
                                                        MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            0.8 *
                                                            0.2,
                                                        decoration: BoxDecoration(
                                                          color: Colors.black26,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(10.0),
                                                        ),
                                                      ),

                                                      ///picture
                                                      Container(
                                                        height:
                                                        MediaQuery
                                                            .of(context)
                                                            .size
                                                            .height *
                                                            0.11 *
                                                            0.9,
                                                        width:
                                                        MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            0.8 *
                                                            0.65,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                snapshots
                                                                    .data
                                                                    .docs[
                                                                index]
                                                                ["Name"]
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                    fontSize: GFS(
                                                                        20,
                                                                        context),
                                                                    color: Theme
                                                                        .of(
                                                                        context)
                                                                        .textTheme
                                                                        .headline1
                                                                        .color),
                                                              ),
                                                            ),

                                                            ///name
                                                            Container(
                                                              child: Text(
                                                                "Hello how are you are you fine...",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                    fontSize: GFS(
                                                                        14,
                                                                        context),
                                                                    color: Theme
                                                                        .of(
                                                                        context)
                                                                        .textTheme
                                                                        .headline1
                                                                        .color),
                                                              ),
                                                            ),

                                                            ///Chat
                                                            Container(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "online",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                        fontSize: GFS(
                                                                            14,
                                                                            context),
                                                                        color: Color(
                                                                            0xFF00C313)),
                                                                  ),
                                                                  Container(
                                                                    height: MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .height *
                                                                        0.11 *
                                                                        0.9 *
                                                                        0.2,
                                                                    width: MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .width *
                                                                        0.8 *
                                                                        0.65 *
                                                                        0.15,
                                                                    color: Color(
                                                                        0xFF0900FF),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )

                                                      ///Details
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                        }
                                        else return Container(height: 0.1,);
                                      },
                                      separatorBuilder: (context, int index) =>
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                          ),
                                      itemCount:
                                          snapshots.data.docs.length
                                  );
                              }),
                        ),

                        ///Personnel Chat
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InChat())),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      // gradient: LinearGradient(begin: Alignment.centerLeft,end: Alignment.centerRight,colors: [Color(0xFFD5DAFF),Color(0xFFE0ECFF),Color(0xFFD8DEFF),Color(0xFFE7EDFF),Color(0xFFD4C9FF),]),
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            spreadRadius: 1.0,
                                            blurRadius: 4.0,
                                            offset: Offset(2.0, 4.0))
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.11 *
                                                0.75,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8 *
                                                0.2,
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),

                                      ///picture
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.11 *
                                                0.9,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8 *
                                                0.65,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                "Aravindh",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: GFS(20, context),
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .headline1
                                                        .color),
                                              ),
                                            ),

                                            ///name
                                            Container(
                                              child: Text(
                                                "Hello how are you are you fine...",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: GFS(14, context),
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .headline1
                                                        .color),
                                              ),
                                            ),

                                            ///Chat
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "online",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            GFS(14, context),
                                                        color:
                                                            Color(0xFF00C313)),
                                                  ),
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.11 *
                                                            0.9 *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8 *
                                                            0.65 *
                                                            0.15,
                                                    color: Color(0xFF0900FF),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )

                                      ///Details
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        ///Group chat
                      ],
                    ),
                  )      ///Chats Block
                ],
              ),
            )  ///Front
          ],
        ),
      ),
    );
  }
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
