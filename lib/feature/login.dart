import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worklytics/core/bezierContainer.dart';
import 'package:worklytics/core/my_colors.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {



  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool showError=true;
  bool hasBeenPress = true;

  @override
  void initState(){
    // CheckConn().check();

    initPlatformState();
    print('Welcome to Log in page');
    // fetchMovies();
    super.initState();

  }


  void initPlatformState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isLoggedIn = prefs.getString("loggedIn")??"no" ;
    if(isLoggedIn=="yes"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }

  }
  bool show =false;



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

 /* Widget _submitButton() {
    log("show submkit error");

    return InkWell(
      onTap: ()async{
        int  lemail = emailController.text.length;
        int  lpass = passwordController.text.length;
        String e =emailController.text;
        String p =passwordController.text;
        if(lemail>1 && lpass>1) {
          var check = await checkConnection();
          if (check == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            try {
              var _documentRef = SignUpAlfa.where("email",isEqualTo: emailController.text);

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

                  // print(doc["registerPhone"]);
                  if (doc["password"] == passwordController.text) {
                    prefs.setString("loggedIn",'yes') ;
                    prefs.setInt('phone', int.parse(doc["phone"].toString()));
                    prefs.setString("nameLogin", doc["nameLogin"]);
                    prefs.setString("password", doc["password"]);
                    prefs.setString("email", doc["email"]);
                    // _showNotification(doc["name"]);
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Home()));
                  } else {
                    prefs.clear();
                    DialogBuilder(context).showResultDialog('Invalid Credentials 1221!');
                    await Future.delayed(const Duration(seconds: 2));
                  }
                });
              }

            } on Exception catch (e) {
              log(e.toString());
              ///empty database
              prefs.clear();
              DialogBuilder(context).showResultDialog('Invalid Credentials!');
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
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
*/
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
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
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
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'P',
         /* style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headlineMedium,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Palette().appColorTimeINMaster,
          ),*/
          children: [
            TextSpan(
              text: 'ro',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'ject',
              style: TextStyle(color: Palette().appColorTimeINMaster, fontSize: 30),
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
                      // _submitButton(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Forgot Password ?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
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
