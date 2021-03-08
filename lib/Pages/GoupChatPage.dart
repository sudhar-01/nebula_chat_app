import 'package:flutter/material.dart';
import 'package:nebula/Pages/GroupInChats.dart';
import 'package:nebula/backend/FireBase.dart';
import 'package:nebula/main.dart';
class GroupChat extends StatefulWidget {
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  var _groupChats;
  @override
  void initState() {
    super.initState();
    _groupChats = database.collection('GroupChats').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: _groupChats,
          builder: (context, AsyncSnapshot snapshots) {
            if (!snapshots.hasData)
              return Center(
                  child: CircularProgressIndicator());
            else {
              var elementList = snapshots.data.docs.where((value) => value.data()["users"].contains(auth.currentUser.uid.toString()) as bool).toList();
              return ListView.separated(
                    itemBuilder: (context, int index) {
                      return Center(
                        child: InkWell(
                          onTap: () =>
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      GroupInChat(nameOfGroup: elementList
                                          [index]["Name"].toString(),
                                        members:elementList[index]["users"],))),
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
                                        .center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Container(
                                        child: Text(
                                          elementList
                                             [
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
                                          (elementList[index]["lastMessage"].toString().length<=20)?elementList[index]["lastMessage"].toString():elementList[index]["lastMessage"].toString().substring(0,20),

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

                                    ],
                                  ),
                                ),

                                ///Details
                                ///
                                IconButton(icon: Icon(Icons.delete), onPressed: (){

                                  database.collection("GroupChats").doc(elementList[index]["Name"]).delete();

                                })
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, int index) =>
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height *
                              0.04,
                        ),
                    itemCount:
                    elementList.length
                );

            }
          }),
    );
  }
}
