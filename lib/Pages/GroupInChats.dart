import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nebula/Pages/InChatPage.dart';
import 'package:nebula/backend/FireBase.dart';
import 'package:nebula/backend/pics.dart';
import 'package:nebula/main.dart';
class GroupInChat extends StatefulWidget {
  final String nameOfGroup;
  final List<dynamic> members;
  GroupInChat({this.nameOfGroup, this.members});

  @override
  _GroupInChatState createState() => _GroupInChatState(nameOfGroup: nameOfGroup,members: members);
}

class _GroupInChatState extends State<GroupInChat> {
  final String nameOfGroup;
  final List<dynamic> members;
  TextEditingController _messageController;
  var messages1;
  ScrollController _controller3;
  _GroupInChatState({this.nameOfGroup, this.members});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller3 = ScrollController();
    _messageController = TextEditingController();
    print(nameOfGroup);
    print("_____________$members");
    messages1 = database.collection("GroupChats").doc(nameOfGroup).collection("Messages").orderBy("timestamp").snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,), onPressed: () => Navigator.pop(context)),
        title: Text(nameOfGroup,style: TextStyle(
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
                  height: MediaQuery.of(context).size.height*0.77,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                    stream: messages1,
                    builder: (context, snapshot){
                      if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
                      else
                        return ListView.builder(
                            controller: _controller3,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context,int index) {
                              if (!snapshot.hasData) return SizedBox();
                              else {
                                if (snapshot.data.docs[index]["from"] != auth.currentUser.uid.toString()){
                                  if(_keyboardIsVisible()){
                                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {_controller3.animateTo(_controller3.position.maxScrollExtent,duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn ); });
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
                        );;
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
                          controller: _messageController,
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
                              _messageController.text = text;
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
                          print(FieldValue.serverTimestamp().toString());
                          database.collection("GroupChats").doc(nameOfGroup).collection("Messages").add(
                              {
                                "from":auth.currentUser.uid.toString(),
                                "message": _messageController.text,
                                "timestamp" : FieldValue.serverTimestamp()

                              });
                          database.collection("GroupChats").doc(nameOfGroup).set({
                            "users" : members,
                            "Name":nameOfGroup,
                            "lastMessage" : _messageController.text,
                            "type": "Personnel"
                          },);
                          setState(() {
                            _messageController.text = "";
                          });
                          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {_controller3.animateTo(_controller3.position.maxScrollExtent,duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn ); });
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
              borderRadius: BorderRadius.only(bottomRight:Radius.circular(20.0),topRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
              boxShadow: [BoxShadow(color: Colors.black26,spreadRadius: 1.0,blurRadius: 2.0,offset: Offset(2.0,3.0))]

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
                //child: checkStatus(status)
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
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(20.0),topRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
                    boxShadow: [BoxShadow(color: Colors.black26,spreadRadius: 1.0,blurRadius: 2.0,offset: Offset(-1.0,1.5))]

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

}
