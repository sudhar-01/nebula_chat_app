import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nebula/backend/FireBase.dart';
import 'package:nebula/main.dart';
class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController _groupName;
 // GlobalKey<ScaffoldSta= GlobalKey();
  List<Map<String,dynamic>> listValue;
  var addUserList;
  @override
  void initState() {
    // TODO: implement initState
    database.collection("Users").snapshots()
    ..listen((event) {
      setState(() {
        listValue = List.generate(event.docs.length, (index) =>{
          "Name" :event.docs[index]["Name"],
          "Id": event.docs[index]["Id"],
          "isSelected" : false
        });
        listValue.removeWhere((element) => element["Id"] == auth.currentUser.uid);
      });
    });
    super.initState();
    _groupName = TextEditingController();
    addUserList = database.collection("Users").snapshots();
    listValue = [];



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,), onPressed: () => Navigator.pop(context)),
        title: Text("Add Users",style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: GFS(25, context),
            color: Colors.white
        ),),
      ),
      body: Builder(
        builder:(context) =>  Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                  child: Container(
                    child: TextField(
                      controller: _groupName,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline1.color,
                      ),

                      decoration: InputDecoration(
                          focusColor: Colors.black,
                          hintText: '    Enter the Group name',
                          border: InputBorder.none,
                         // focusedBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                         // enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          hintStyle: TextStyle(
                              color: Theme.of(context).textTheme.headline1.color.withOpacity(0.5),
                              fontSize: GFS(20, context)
                          )
                      ),
                      onSubmitted: (text) {
                        setState(() {
                          _groupName.text = text;
                        });
                      },

                    ),

                  )),
              Expanded(
                flex: 8,
                  child: Container(
                    child: StreamBuilder(
                      stream: addUserList,
                        builder: (context,snapshots) {
                        if(listValue.isEmpty && !snapshots.hasData) return Center(child: CircularProgressIndicator());
                          else if(listValue.isNotEmpty && snapshots.hasData) {
                          var _personalElementList3 = snapshots.data.docs.where((value) => !(value.data()["Id"].contains(auth.currentUser.uid.toString()) as bool)).toList();
                          return ListView.builder(
                              itemCount:_personalElementList3.length,
                              itemBuilder: (context, int index) =>
                                  CheckboxListTile(
                                    activeColor: Colors.green,
                                    value: listValue[index]["isSelected"],
                                    title: Text(_personalElementList3[index]['Name'], style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: GFS(20, context),
                                        color:Theme.of(context).textTheme.headline1.color,
                                    ),),
                                    onChanged: (value) {
                                      setState(() {
                                        listValue[index]["isSelected"] = value;

                                      });

                                    },
                                  )
                          );}
                          else return Text("No Users",style: TextStyle(
                            color:Theme.of(context).textTheme.headline1.color,
                          ),);
                        }
                    ),
                  )),
              Expanded(
                flex: 1,
                  child: InkWell(
                    onTap: () {
                      if(_groupName.text.isNotEmpty && listValue.length>=2){
                        listValue.add({
                          "Name" :auth.currentUser.displayName,
                          "Id":auth.currentUser.uid,
                          "isSelected" : true

                        });
                        database.collection("GroupChats").doc(_groupName.text).set({
                          "Name": _groupName.text,
                          "lastMessage":" ",
                          "type":"Group",
                          "users": listValue.where((element) => element["isSelected"] == true).map((e) => e["Id"]).toList()
                        }).catchError((onError) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor:Colors.red,duration: Duration(seconds: 1),content: Text(onError.toString()))));
                        database.collection("GroupChats").doc(_groupName.text).collection("Messages").add(
                            {
                              "from": auth.currentUser.uid.toString(),
                              "fromName":auth.currentUser.displayName,
                              "message": "hi",
                              "timestamp" : FieldValue.serverTimestamp()
                            });
                        _groupName.text = "";
                        Navigator.pop(context);
                      }
                      else if(listValue.length<2){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor:Colors.red,duration: Duration(seconds: 1),content: Text("There must be more than 2 members in a group")));


                      }
                      else{
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor:Colors.red,duration: Duration(seconds: 1),content: Text("Please enter group name")));
                      }

                  

                    },
                    child: Container(
                      color: Colors.green,
                      child: Center(
                        child: Text("Create Group",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: GFS(25, context),
                            color: Colors.white
                        ),),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
