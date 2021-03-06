import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nebula/backend/pics.dart';
import 'package:nebula/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nebula/backend/FireBase.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      docu = usersinChat.singleWhere((element) => ((element == auth.currentUser.uid.toString() + SecondUserId) || (element == SecondUserId + auth.currentUser.uid.toString())),orElse: ()
        => auth.currentUser.uid.toString() + SecondUserId
      );

    }).then((value) {
     setState(() {
        messages = database.collection("Chats").doc(docu).collection("Messages").orderBy("timestamp").snapshots();

      });

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,), onPressed: () => Navigator.pop(context)),
        title: Text(SeconduserName,
          style: GoogleFonts.openSans(textStyle:TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: GFS(26, context),
            color: Colors.white
        ),)
        ),
        actions: [
          IconButton(icon: FaIcon(FontAwesomeIcons.ellipsisV,color: Colors.white,size: GFS(17, context),), onPressed: null)
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
                            if(_keyboardIsVisible()){
                              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {_controller2.animateTo(_controller2.position.maxScrollExtent,duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn ); });
                            }
                            return ReceiveContainer(
                                text: snapshot.data.docs[index]["message"].toString(),
                                image:snapshot.data.docs[index]["image"].toString(),
                            );
                          }
                          else{
                            return SendContainer(
                              text: snapshot.data.docs[index]["message"].toString(),
                              image:snapshot.data.docs[index]["image"].toString(),
                              status: "seen",);
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
                            suffixIcon: IconButton(icon: Icon(Icons.camera), onPressed: () async{
                              var _image = await ImagePicker().getImage(source: ImageSource.gallery);
                              if(_image!=null){
                                addImageInChats(File(_image.path),docu,SecondUserId,SeconduserName);
                              }
                            }),
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
                          database.collection("Chats").doc(docu).collection("Messages").add(
                              {
                                "from":auth.currentUser.uid.toString(),
                                "message": controller2.text,
                                "image": null,
                                "timestamp" : FieldValue.serverTimestamp()

                              });
                          database.collection("Chats").doc(docu).set({
                            "users" : [auth.currentUser.uid,SecondUserId],
                            "names" : [auth.currentUser.displayName,SeconduserName],
                            "lastMessage" : controller2.text,
                            "type": "Personnel"
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

class SendContainer extends StatelessWidget {
  final String text;
  final String status;
  final String image;
  const SendContainer({Key key, this.text, this.status,this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      constraints: BoxConstraints(
        minHeight: MediaQuery
            .of(context)
            .size
            .height * 0.1,
      ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.03,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.1,
                child: checkStatus(status)
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.02, bottom: MediaQuery
                  .of(context)
                  .size
                  .height * 0.02, left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.05, right: MediaQuery
                  .of(context)
                  .size
                  .width * 0.02),
              child: (text != "image")?
              Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.1,
                  maxWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.5,
                  minHeight: MediaQuery
                      .of(context)
                      .size
                      .height * 0.06,
                ),
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColorDark,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(color: Colors.black26,
                          spreadRadius: 1.0,
                          blurRadius: 2.0,
                          offset: Offset(-1.0, 1.5))
                    ]

                ),
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery
                      .of(context)
                      .size
                      .width * 0.4 * 0.1),
                  child: SelectableText(text, style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: GFS(19, context),
                      color: Colors.white
                  ),),
                ),

              ):
              Container(
                width: MediaQuery.of(context).size.width*0.5,
                height:  MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                    color:Theme.of(context).primaryColorDark,
                 //   borderRadius: BorderRadius.only(topLeft:Radius.circular(20.0),topRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
                    boxShadow: [BoxShadow(color: Colors.black26,spreadRadius: 1.0,blurRadius: 2.0,offset: Offset(-1.0,1.5))]

                ),
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02),
                  child:  Container(

                      width: MediaQuery.of(context).size.width,
                      child: Image.network(image,fit: BoxFit.fill,)),
                ),

              )
            ),
          ],
        ),
      ),
    );
  }
}






class ReceiveContainer extends StatelessWidget {
  final String text;
  final String image;
  const ReceiveContainer({Key key, this.text,this.image}) : super(key: key);
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
        child: (text != "image")?
        Container(
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

        ):
        Container(
          width: MediaQuery.of(context).size.width*0.5,
          height:  MediaQuery.of(context).size.width*0.5,
          decoration: BoxDecoration(
              color:Theme.of(context).primaryColorDark,
            //  borderRadius: BorderRadius.only(topLeft:Radius.circular(20.0),topRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
              boxShadow: [BoxShadow(color: Colors.black26,spreadRadius: 1.0,blurRadius: 2.0,offset: Offset(-1.0,1.5))]

          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02),
            child:  Container(

                width: MediaQuery.of(context).size.width,
                child: Image.network(image,fit: BoxFit.fill,)),
          ),

        )
      ),
    );
  }
}



  checkStatus(statusss) {
    {
      if(statusss == 'delivered') return SvgPicture.asset(doubleCheckIcon,fit: BoxFit.contain,color: Colors.black,);
      else if (statusss == 'Not delivered')  return SvgPicture.asset(checkIcon,fit: BoxFit.contain,color: Colors.black,);
      else if (statusss == 'seen') return SvgPicture.asset(doubleCheckIcon,fit: BoxFit.contain,color: Colors.green,);

    }

}