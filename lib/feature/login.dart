import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worklytics/core/NewConn.dart';
import 'package:worklytics/core/bezierContainer.dart';
import 'package:worklytics/core/colors.dart';
import 'package:worklytics/core/constant.dart';
import 'package:worklytics/core/showDialogue.dart';
import 'package:worklytics/feature/admin_view.dart';
import 'package:worklytics/feature/signup.dart';
import 'package:worklytics/feature/user_view.dart';
// import 'home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {



  TextEditingController emailController =  TextEditingController();
  TextEditingController passwordController =  TextEditingController();



  @override
  void initState(){
    // CheckConn().check();

    initPlatformState();
    print('Welcome to Log in page');
    super.initState();

  }


  void initPlatformState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isLoggedIn = prefs.getString("loggedIn")??"no" ;
    String isAdmin = prefs.getString("isAdmin")??"no" ;

    if(isLoggedIn=="yes"){
      if(isAdmin=='yes'){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminView()),
        );

      }else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserView()),
        );

      }
    }

  }



  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller:controller,
              obscureText: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    log("show submkit error");

    return InkWell(
      onTap: ()async{
        int  lemail = emailController.text.length;
        int  lpass = passwordController.text.length;
        String e =emailController.text.toLowerCase();
        String p =passwordController.text;
        if(lemail>1 && lpass>1) {
          bool check = await CheckConn().check();
          if (check == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            try {
              var _documentRef = MyConstant().SignUpAlfa.where("email",isEqualTo: emailController.text.toLowerCase());

              print("i m email id ${emailController.text}");
              print("shoyiguwafuyjsgsjhgfv");
              print(_documentRef);
              print("shoyiguwafuyjsgsjhgfv");

              var userFromFirebase = await _documentRef.get();
              if (userFromFirebase.docs.length == 0) {
                prefs.clear();
                DialogBuilder(context).showResultDialog('Invalid Credentials!');
                await Future.delayed(const Duration(seconds: 2));

              }else{
                userFromFirebase.docs.forEach((doc) async {
                  print("i m passwordController id ${passwordController.text}");
                  print("i m passwordController id--- ${doc["password"]}");

                  // print(doc["registerPhone"]);
                  if (doc["password"]== passwordController.text) {
                    prefs.setString("loggedIn",'yes') ;
                    prefs.setInt('phone', int.parse(doc["phone"].toString()));
                    prefs.setString("nameLogin", doc["nameLogin"]);
                    prefs.setString("password", doc["password"]);
                    prefs.setString("email", doc["email"]);
                    //
                    if(doc["owner"]=='yes'){
                      prefs.setString("isAdmin",'yes') ;

                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => AdminView()));

                    }else{
                      prefs.setString("isAdmin",'no') ;

                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => UserView()));

                    }

                  } else {
                    prefs.clear();
                    DialogBuilder(context).showResultDialog('Invalid Credentials!');
                    await Future.delayed(const Duration(seconds: 2));
                  }
                });
              }

            } on Exception catch (e) {
              log(e.toString());
              ///empty database
              prefs.clear();
              DialogBuilder(context).showResultDialog('Something went wrong\n please try after sometime');
              // DialogBuilder(context).showResultDialog('Invalid Credentials963!');
              await Future.delayed(const Duration(seconds: 2));
            }

          }

        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Invalid credential741!!'),
          ));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: const  LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.deepPurple,
                ]
            )),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }


  Widget _createAccountLabel() {
    return  Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
      InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUp()));
        },
        child: Text(
              'Register',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            )),
          ],
        ),
      );

  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'W',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headlineMedium,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),  children: [
        TextSpan(
          text: 'ork',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        TextSpan(
          text: 'lytics',
          style: TextStyle(
              color: primaryColor,
              fontSize: 30),
        ),
      ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email id", emailController),

        _entryField("Password",passwordController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(height: 50),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      _submitButton(),

                      _divider(),
                      // _facebookButton(),
                      SizedBox(height: height * .055),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ));
  }
}
