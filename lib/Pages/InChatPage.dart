import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nebula/backend/pics.dart';
import 'package:nebula/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nebula/backend/FireBase.dart';
import 'package:date_time_format/date_time_format.dart';
class InChat extends StatefulWidget {
  final String secondUserId;
  final String SeconduserName;

  const InChat({Key key, this.secondUserId,this.SeconduserName}) : super(key: key);
  @override
  _InChatState createState() => _InChatState(secondUserId,SeconduserName);
}

class _InChatState extends State<InChat> {
  var messages;
  String docu;
  List ko;
  Future<List<QuerySnapshot>> offlinemessage;
  final String SecondUserId;
  final String SeconduserName;
  String typeMessage;
  ScrollController _controller2;
  TextEditingController controller2;
  _InChatState(this.SecondUserId,this.SeconduserName);
  @override
  void initState() {
    super.initState();
    controller2 = TextEditingController();
    addUser();
    _controller2 = ScrollController();
    database.collection("Chats").get().then((value) {
      var usersinChat = value.docs.map((e) => e.id).toList();
      print(usersinChat);
      docu = usersinChat.singleWhere((element) => ((element == auth.currentUser.uid.toString() + SecondUserId) || (element == SecondUserId + auth.currentUser.uid.toString())),orElse: ()
        => auth.currentUser.uid.toString() + SecondUserId
      );

    }).then((value) {
      messages = database.collection("Chats").doc(docu).collection("Messages").snapshots();
      print("_________________$docu");
    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,), onPressed: () => Navigator.pop(context)),
        title: Text(SeconduserName,style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: GFS(25, context),
            color: Colors.white
        ),),
        actions: [
          IconButton(icon: Icon(Icons.search,color: Colors.white,), onPressed: null)
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColorLight,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.75,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: messages,
                  builder: (context, snapshot){
                    if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
                    else
                      return ListView.builder(
                        controller: _controller2,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context,int index) {

                        if (!snapshot.hasData) return SizedBox();
                        else {
                          if (snapshot.data.docs[index]["from"] == SecondUserId){
                            print("Second ======> $SecondUserId");
                            if(_keyboardIsVisible()){
                              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {_controller2.animateTo(_controller2.position.maxScrollExtent,duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn ); });
                            }
                            return ReceiveContainer(
                                text: snapshot.data.docs[index]["message"].toString());
                          }
                          else{
                            return SendContainer(
                              text: snapshot.data.docs[index]["message"].toString(), status: "seen",);
                          }

                        }
                      }
                      );
                    },
                )
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.1,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.07,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width*0.75,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: [BoxShadow(color: Colors.black26,spreadRadius: 1.0,blurRadius: 3.0)],
                        borderRadius: BorderRadius.circular(40.0)
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.07),
                        child: TextField(
                          controller: controller2,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1.color,
                          ),

                          decoration: InputDecoration(
                              focusColor: Colors.black,
                              hintText: 'Type here',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Colors.black26,
                                  fontSize: GFS(20, context)
                              )
                          ),
                          onSubmitted: (text) {
                            setState(() {
                              controller2.text = text;
                            });
                          },

                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.07,
                      width: MediaQuery.of(context).size.width*0.2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black26,spreadRadius: 1.0,blurRadius: 3.0)],

                      ),

                      child: InkWell(
                        onTap: () {
                          database.collection("Chats").doc(docu).collection("Messages").doc(DateTime.parse(FieldValue.serverTimestamp().toString()).millisecondsSinceEpoch.toString()).set(
                              {
                                "from":auth.currentUser.uid.toString(),
                                "message": controller2.text,
                                "timestamp" : Timestamp.now().millisecondsSinceEpoch.toString()

                              });
                          database.collection("Chats").doc(docu).set({
                            "users" : docu,
                            "lastMessage" : controller2.text
                          },);
                          setState(() {
                            controller2.text = "";
                          });
                          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {_controller2.animateTo(_controller2.position.maxScrollExtent,duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn ); });
                        },
                        child: SizedBox(
                            width:MediaQuery.of(context).size.width*0.1,
                            height:MediaQuery.of(context).size.height*0.035,
                            child: SvgPicture.asset(sendIcon,fit: BoxFit.contain,)),
                      ),
                    )
                  ],
                ),
              )  ///Typing Container
            ],
          ),
        ),
      ),
    );
  }
  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }
  void checkCommon() {
  
  }
}







class ReceiveContainer extends StatelessWidget {
  final String text;
  const ReceiveContainer({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height*0.1,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.02,horizontal:MediaQuery.of(context).size.width*0.05 ),
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width*0.1,
            maxWidth: MediaQuery.of(context).size.width*0.5,
            minHeight: MediaQuery.of(context).size.height*0.06,
          ),
          decoration: BoxDecoration(
            color:Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [BoxShadow(color: Colors.black26,spreadRadius: 1.0,blurRadius: 2.0)]

          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.4*0.1),
            child: SelectableText(text,style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: GFS(19, context),
                color:Theme.of(context).textTheme.headline1.color
            ),),
          ),

        ),
      ),
    );
  }
}
class SendContainer extends StatelessWidget {
  final String text;
  final String status;
  const SendContainer({Key key, this.text,this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height*0.1,
      ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.03,
              width: MediaQuery.of(context).size.width*0.1,
              child: checkStatus(status)
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02,bottom: MediaQuery.of(context).size.height*0.02,left:MediaQuery.of(context).size.width*0.05 ,right:MediaQuery.of(context).size.width*0.02  ),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width*0.1,
                  maxWidth: MediaQuery.of(context).size.width*0.5,
                  minHeight: MediaQuery.of(context).size.height*0.06,
                ),
                decoration: BoxDecoration(
                    color:Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [BoxShadow(color: Colors.black26,spreadRadius: 1.0,blurRadius: 2.0)]

                ),
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.4*0.1),
                  child: SelectableText(text,style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: GFS(19, context),
                      color: Colors.white
                  ),),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }

  checkStatus(statusss) {
    {
      if(statusss == 'delivered') return SvgPicture.asset(doubleCheckIcon,fit: BoxFit.contain,color: Colors.black,);
      else if (statusss == 'Not delivered')  return SvgPicture.asset(checkIcon,fit: BoxFit.contain,color: Colors.black,);
      else if (statusss == 'seen') return SvgPicture.asset(doubleCheckIcon,fit: BoxFit.contain,color: Colors.green,);

    }

  }
}