import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nebula/Pages/InChatPage.dart';
import 'package:nebula/backend/FireBase.dart';
import 'package:nebula/main.dart';
class PersonalChat extends StatefulWidget {
  @override
  _PersonalChatState createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  var _chatPage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chatPage = database.collection("Chats").snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: _chatPage,
          builder: (context, AsyncSnapshot snapshots) {
            if (!snapshots.hasData)
              return Center(
                  child: CircularProgressIndicator());
            else{
              var _personalElementList1 = snapshots.data.docs.where((value) => value.data()["users"].contains(auth.currentUser.uid.toString()) as bool).toList();
              return ListView.separated(
                  itemBuilder: (context, int index) {
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
                                              secondUserId:_personalElementList1[index]["users"].where((value) => !(value.contains(auth.currentUser.uid) as bool)).toString().replaceAll("(", "").replaceAll(")", ""),
                                              SeconduserName:_personalElementList1[index]["names"].where((value) => !(value.contains(auth.currentUser.displayName) as bool)).toString().replaceAll("(", "").replaceAll(")", ""),
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
                                  color: Theme.of(context).cardColor,
                                 // gradient:LinearGradient(begin: Alignment.centerLeft,end: Alignment.centerRight,colors: [Color(0xFFD5DAFF),Color(0xFFE0ECFF),Color(0xFFD8DEFF),Color(0xFFE7EDFF),Color(0xFFD4C9FF),]),
                                  borderRadius:
                                  BorderRadius.circular(
                                      10.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors
                                            .black26,
                                        spreadRadius: 2.0,
                                        blurRadius: 6.0,
                                        offset:
                                        Offset(4.0, 7.0))
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceAround,
                                children: [
                                ProFilePic(id: _personalElementList1[index]["users"].where((value) => !(value.contains(auth.currentUser.uid) as bool)).toString().replaceAll("(", "").replaceAll(")", "")),
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
                                        0.8,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Container(
                                          child: Text(
                                            _personalElementList1[
                                            index]
                                            ["names"].where((value) =>!(value.contains(auth.currentUser.displayName) as bool)).toString().replaceAll("(", "").replaceAll(")", ""),
                                            style: GoogleFonts.openSans(textStyle:TextStyle(
                                                fontWeight:
                                                FontWeight.w600,
                                                fontSize: GFS(23,
                                                    context),
                                                color: Theme
                                                    .of(
                                                    context)
                                                    .textTheme
                                                    .headline1
                                                    .color),
                                          ),
                                          )
                                        ),

                                        ///name
                                        Container(
                                          child: Text(
                                            (_personalElementList1[index]["lastMessage"].toString().length<=20)?_personalElementList1[index]["lastMessage"].toString():_personalElementList1[index]["lastMessage"].toString().substring(0,20),
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
                                        // Container(
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //     MainAxisAlignment
                                        //         .spaceBetween,
                                        //     children: [
                                        //       Text(
                                        //         "online",
                                        //         style: TextStyle(
                                        //             fontWeight:
                                        //             FontWeight
                                        //                 .w600,
                                        //             fontSize: GFS(
                                        //                 14,
                                        //                 context),
                                        //             color: Color(
                                        //                 0xFF00C313)),
                                        //       ),
                                        //       Container(
                                        //         height: MediaQuery
                                        //             .of(
                                        //             context)
                                        //             .size
                                        //             .height *
                                        //             0.11 *
                                        //             0.9 *
                                        //             0.2,
                                        //         width: MediaQuery
                                        //             .of(
                                        //             context)
                                        //             .size
                                        //             .width *
                                        //             0.8 *
                                        //             0.65 *
                                        //             0.15,
                                        //         color: Color(
                                        //             0xFF0900FF),
                                        //       )
                                        //     ],
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  )

                                  ///Details
                                ],
                              ),
                            ),
                          ),
                        );
                  },
                  separatorBuilder: (context, int index) =>
                      SizedBox(
                        height: MediaQuery.of(context)
                            .size
                            .height *
                            0.04,
                      ),
                  itemCount:
                  _personalElementList1.length
              );
            }
          }),
    );
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
        setState(() {
          msg = value.data()["lastMessage"].toString();

        });


      });
    });

    if(msg == null){
      return "...";
    }
    else return msg;
  }




}
