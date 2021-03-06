import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nebula/Pages/MainPage.dart';
import 'package:nebula/backend/pics.dart';
import 'package:nebula/backend/FireBase.dart';
import 'package:nebula/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {
  final loginKey = GlobalKey<ScaffoldState>();
  int iter;
  final SnackBar snackBar = SnackBar(content: Text("Invalid username or password"),duration: Duration(seconds: 2),backgroundColor: Colors.red,);
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  TextEditingController _nameController;
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    _nameController = TextEditingController(text:  '');
    iter = 0;


  }

  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser != null){
      FirebaseAuth.instance.currentUser.reload();
      if(iter>0 && FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.emailVerified == false ) {
        setState(() {
          loginKey.currentState.showSnackBar(SnackBar(content: Text(
              "Please verify your email.Please click here to verify"),
              backgroundColor: Colors.red,
              action: SnackBarAction(label: 'verify',
                  onPressed: () =>FirebaseAuth.instance.currentUser.sendEmailVerification().catchError((onError){
                    print(onError);
                  }))));
        });
      }
      print(FirebaseAuth.instance.currentUser.email);
      print(FirebaseAuth.instance.currentUser.emailVerified);
    }
    iter++;
    return Scaffold(
      key: loginKey,
      body:Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SvgPicture.asset(firstpageBG,fit: BoxFit.fill,)//Image.asset("assets/BG.svg",fit: BoxFit.cover,),

              
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
              child: Text("nebuLa",style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: GFS(60, context),
                  shadows: [Shadow(offset: Offset(3.0,4.0),blurRadius: 2.0)],
                  color: Colors.white
              ),),
              ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                  Container(
                    height: MediaQuery.of(context).size.height*0.06,
                    width: MediaQuery.of(context).size.width*0.85,
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                      boxShadow: [BoxShadow(color: Colors.black54,spreadRadius: 1.0,blurRadius: 4.0,offset: Offset(2.0,4.0))]
                    ),
                    child: TextField(
                      controller: _usernameController,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail,color: Theme.of(context).primaryColor,),
                        hintText: 'Email',
                        focusColor: Colors.black,
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
                          _usernameController.text = text;


                        });
                      },

                    ),
                  ),   ///Email
                  SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                  Container(
                    height: MediaQuery.of(context).size.height*0.06,
                    width: MediaQuery.of(context).size.width*0.85,
                    decoration: BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.only(topLeft:Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                        boxShadow: [BoxShadow(color: Colors.black54,spreadRadius: 1.0,blurRadius: 4.0,offset: Offset(2.0,4.0))]
                    ),
                    child: TextField(
                      controller: _nameController,
                      style: TextStyle(
                        color: Colors.black,
                      ),

                      decoration: InputDecoration(
                          focusColor: Colors.black,
                          prefixIcon: Icon(Icons.person,color: Theme.of(context).primaryColor,),
                          hintText: 'Name',
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
                          _nameController.text = text;
                          name = text;


                        });
                      },

                    ),
                  ),   ///Name
                  SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                  Container(
                    height: MediaQuery.of(context).size.height*0.06,
                    width: MediaQuery.of(context).size.width*0.85,
                    decoration: BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.only(topLeft:Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                        boxShadow: [BoxShadow(color: Colors.black54,spreadRadius: 1.0,blurRadius: 4.0,offset: Offset(2.0,4.0))]
                    ),
                    child: TextField(
                      obscureText: true,
                      obscuringCharacter: '*' ,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: _passwordController,
                      decoration: InputDecoration(
                          focusColor: Colors.black,
                          prefixIcon: Icon(Icons.lock_open_outlined,color: Theme.of(context).primaryColor,),
                          hintText: 'Password',
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
                          _passwordController.text = text;


                        });
                      },

                    ),
                  ),   ///Password
                  SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (_usernameController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          username = _usernameController.text;
                          password = _passwordController.text;
                          if(_nameController.text.isNotEmpty){
                            name = _nameController.text;
                          }

                        }
                        else
                          loginKey.currentState.showSnackBar(snackBar);
                      });
                      if(auth.currentUser == null){
                          auth.signInWithEmailAndPassword(email: username, password: password).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => Chats()))).catchError((onError){
                            auth.createUserWithEmailAndPassword(email: username, password: password).then((value) => auth.currentUser.sendEmailVerification()).
                            catchError((onError){
                              loginKey.currentState.showSnackBar(SnackBar(content: Text(onError.toString()),duration: Duration(seconds: 2),backgroundColor: Colors.red,));
                            }).then((value) => auth.currentUser.sendEmailVerification());
                          });
                      }



                      else if(auth.currentUser.emailVerified == true){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Chats()));
                      }



                      else{
                        auth.currentUser.updateProfile(displayName: name).then((value) => database.collection("Users").doc().update( {
                          "Id":auth.currentUser.uid,
                          "Name": name,
                        }));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Chats()));
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.07,
                      width: MediaQuery.of(context).size.width*0.4,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                          boxShadow: [BoxShadow(color: Colors.black54,spreadRadius: 1.0,blurRadius: 4.0,offset: Offset(2.0,4.0))]
                      ),
                      child: Center(
                        child: Text("Login" ,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: GFS(20, context),
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),

                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )


    );
  }
}
