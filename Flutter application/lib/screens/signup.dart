import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _auth = FirebaseAuth.instance;
  bool showspinner = false;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
        ),
        inAsyncCall: showspinner,
        child: Container(
          color: Colors.black54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'NEXTFLIX',

                  style: GoogleFonts.robotoCondensed(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 45.0,
                      letterSpacing: 1.0),
                  textAlign: TextAlign.center,

                  // style: TextStyle(
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 25.0),
                child: Container(
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                      labelText: "Email",
                      labelStyle: GoogleFonts.robotoCondensed(
                          fontSize: 20.0,
                          color: Colors.white54,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w500),
                    ),
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 20.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),

                  height: 50.0,
                  // color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 25.0),
                child: Container(
                  child: TextField(
                    cursorColor: Colors.white,
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                      labelText: "Password",
                      labelStyle: GoogleFonts.robotoCondensed(
                          fontSize: 20.0,
                          color: Colors.white54,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w500),
                    ),
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 20.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),

                  height: 50.0,
                  // color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 100.0),
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      showspinner = true;
                    });
                    try {
                      final newuser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newuser != null) {
                        Navigator.pushNamed(context, 'home');
                      }
                      setState(() {
                        showspinner = false;
                      });
                    } catch (e) {
                      setState(() {
                        showspinner = false;
                      });
                      Fluttertoast.showToast(
                          msg: "Invalid Details ... Try again",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      print(e);
                    }
                  },
                  child: Container(
                    child: Center(
                      child: Text(
                        'Sign up',
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),

                    height: 50.0,
                    // color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.white30,
                        fontSize: 15.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'login');
                      },
                      child: Text(
                        'Log In',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.red,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
