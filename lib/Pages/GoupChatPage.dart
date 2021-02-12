import 'package:flutter/material.dart';
import 'package:nebula_chat_app/main.dart';
class GroupChat extends StatefulWidget {
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height:MediaQuery.of(context).size.height*0.12,
            width: MediaQuery.of(context).size.width*0.9,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.centerLeft,end: Alignment.centerRight,colors: [Color(0xFFD5DAFF),Color(0xFFE0ECFF),Color(0xFFD8DEFF),Color(0xFFE7EDFF),Color(0xFFD4C9FF),]),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [BoxShadow(color: Colors.black26,spreadRadius: 1.0,blurRadius: 4.0,offset: Offset(2.0,4.0))]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height:MediaQuery.of(context).size.height*0.11*0.75,
                  width: MediaQuery.of(context).size.width*0.8*0.2,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                ), ///picture
                Container(
                  height:MediaQuery.of(context).size.height*0.11*0.9,
                  width: MediaQuery.of(context).size.width*0.8*0.65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Aravindh",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: GFS(20, context),
                            color: Colors.black
                        ),),
                      ),  ///name
                      Container(
                        child: Text("Hello how are you are you fine...",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: GFS(14, context),
                            color: Colors.black
                        ),),
                      ), ///Chat
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("online",style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: GFS(14, context),
                                color: Color(0xFF00C313)
                            ),),
                            Container(
                              height:MediaQuery.of(context).size.height*0.11*0.9*0.2,
                              width: MediaQuery.of(context).size.width*0.8*0.65*0.15,
                              color: Color(0xFF0900FF),
                            )

                          ],
                        ),
                      )
                    ],

                  ),

                ) ///Details
              ],
            ),

          )
        ],
      ),
    );
  }
}
