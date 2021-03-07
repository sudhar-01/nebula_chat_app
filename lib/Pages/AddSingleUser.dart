import 'package:flutter/material.dart';
import 'package:nebula/Pages/InChatPage.dart';
import 'package:nebula/backend/FireBase.dart';
import 'package:nebula/main.dart';
class AddSingleUser extends StatefulWidget {
  @override
  _AddSingleUserState createState() => _AddSingleUserState();
}

class _AddSingleUserState extends State<AddSingleUser> {
  var _searchUsers;
  @override
  void initState() {
    super.initState();
    _searchUsers = database.collection("Users").snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,), onPressed: () => Navigator.pop(context)),
        title: Text("Add User",style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: GFS(25, context),
            color: Colors.white
        ),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: _searchUsers,
            builder: (context, AsyncSnapshot snapshots) {
              if (!snapshots.hasData)
                return Center(
                    child: CircularProgressIndicator());
              else{
                var _personalElementList2 = snapshots.data.docs.where((value) => !(value.data()["Id"].contains(auth.currentUser.uid.toString()) as bool)).toList();
                //var _personalElementList2 = snapshots.data.docs.map((e) => e["Id"]!=auth.currentUser.uid).toList();
                return ListView.builder(
                    itemBuilder: (context, int index) {
                        return Padding(
                            padding: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.04),
                            child: Center(
                              child: InkWell(
                                onTap: () =>
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                InChat(
                                                  secondUserId: _personalElementList2[index]["Id"].toString(),
                                                  SeconduserName:_personalElementList2[index]["Name"].toString(),
                                                ))),
                                child:ListTile(
                                  leading: CircleAvatar(backgroundColor: Colors.grey,radius: MediaQuery.of(context).size.width*0.1,),
                                  title: Text(
                                             _personalElementList2[
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
                                )
                                // child: Container(
                                //   height: MediaQuery
                                //       .of(context)
                                //       .size
                                //       .height *
                                //       0.07,
                                //   width: MediaQuery
                                //       .of(context)
                                //       .size
                                //       .width *
                                //       0.9,
                                //   decoration: BoxDecoration(
                                //       color: Theme.of(context).cardColor,
                                //       // gradient: LinearGradient(begin: Alignment.centerLeft,end: Alignment.centerRight,colors: [Color(0xFFD5DAFF),Color(0xFFE0ECFF),Color(0xFFD8DEFF),Color(0xFFE7EDFF),Color(0xFFD4C9FF),]),
                                //       borderRadius:
                                //       BorderRadius.circular(
                                //           5.0),
                                //       boxShadow: [
                                //         BoxShadow(
                                //             color: Colors
                                //                 .black26,
                                //             spreadRadius: 1.0,
                                //             blurRadius: 4.0,
                                //             offset:
                                //             Offset(2.0, 4.0))
                                //       ]),
                                //   child: Row(
                                //     mainAxisAlignment:
                                //     MainAxisAlignment
                                //         .spaceEvenly,
                                //     children: [
                                //       Container(
                                //         height:
                                //         MediaQuery
                                //             .of(context)
                                //             .size
                                //             .height *
                                //             0.07 *
                                //             0.75,
                                //         width:
                                //         MediaQuery
                                //             .of(context)
                                //             .size
                                //             .width *
                                //             0.8 *
                                //             0.15,
                                //         decoration: BoxDecoration(
                                //           color: Colors.black26,
                                //           borderRadius:
                                //           BorderRadius
                                //               .circular(5.0),
                                //         ),
                                //       ),
                                //
                                //       ///picture
                                //       Container(
                                //         height:
                                //         MediaQuery
                                //             .of(context)
                                //             .size
                                //             .height *
                                //             0.11 *
                                //             0.9,
                                //         width:
                                //         MediaQuery
                                //             .of(context)
                                //             .size
                                //             .width *
                                //             0.8 *
                                //             0.65,
                                //         child: Container(
                                //           child: Text(
                                //            _personalElementList2[
                                //             index]
                                //             ["Name"]
                                //                 .toString(),
                                //             style: TextStyle(
                                //                 fontWeight:
                                //                 FontWeight
                                //                     .w600,
                                //                 fontSize: GFS(
                                //                     20,
                                //                     context),
                                //                 color: Theme
                                //                     .of(
                                //                     context)
                                //                     .textTheme
                                //                     .headline1
                                //                     .color),
                                //           ),
                                //         ),
                                //       )
                                //
                                //       ///Details
                                //     ],
                                //   ),
                                // ),

                            ),
                          );
                    },
                    itemCount:
                    _personalElementList2.length
                );}
            }),

      ),
    );
  }
}
