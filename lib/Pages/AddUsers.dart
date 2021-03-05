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
  GlobalKey<ScaffoldState> _enterGroupName = GlobalKey();
  List<Map<String,dynamic>> listValue;
  var addUserList;
  @override
  void initState() {
    // TODO: implement initState
    database.collection("Users").snapshots()
    ..listen((event) {
      setState(() {
        listValue = List.generate(event.docs.length, (index) => {
          "Name" :event.docs[index]["Name"],
          "Id": event.docs[index]["Id"],
          "isSelected" : false
        });
        print(listValue);

      });
    });
    super.initState();
    _groupName = TextEditingController();
    addUserList = database.collection("Users").snapshots();
    listValue = [];



  }
  @override
  Widget build(BuildContext context) {
    print(listValue);
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
                            return ListView.builder(
                              itemCount: snapshots.data.docs.length,
                              itemBuilder: (context, int index) =>
                                  CheckboxListTile(
                                    activeColor: Colors.green,
                                    value: listValue[index]["isSelected"],
                                    title: Text(snapshots.data
                                        .docs[index]['Name'], style: TextStyle(
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
                      if(_groupName.text.isNotEmpty){
                        database.collection("GroupChats").doc(_groupName.text).set({
                          "Name": _groupName.text,
                          "lastMessage":" ",
                          "type":"Group",
                          "users": listValue.map((e) => e["Id"]).toList()
                        }).catchError((onError) => Scaffold.of(context).showSnackBar(SnackBar(backgroundColor:Colors.red,duration: Duration(seconds: 1),content: Text(onError.toString()))));
                        database.collection("GroupChats").doc(_groupName.text).collection("Messages").add(
                            {
                              "from": auth.currentUser.uid.toString(),
                              "message": "hi",
                              "timestamp" : FieldValue.serverTimestamp()
                            });
                        print("group created name:${_groupName.text}  members: ${listValue.where((element) => element["isSelected"] == true)}");
                        _groupName.text = "";
                        Navigator.pop(context);

                      }
                      else{
                       Scaffold.of(context).showSnackBar(SnackBar(key:_enterGroupName,backgroundColor:Colors.red,duration: Duration(seconds: 1),content: Text("Please enter group name")));
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
