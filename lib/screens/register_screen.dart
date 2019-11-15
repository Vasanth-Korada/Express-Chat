import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../main.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool loading = false;
  Widget textfield(String hinttext, bool value, Function onChanged,
      [String helperText]) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: new TextField(
        textAlign: TextAlign.center,
        obscureText: value,
        keyboardType: TextInputType.emailAddress,
        onChanged: onChanged,
        decoration: InputDecoration(
          helperText: helperText,
          hintText: hinttext,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            children: <Widget>[
              new SizedBox(
                height: 50.0,
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: new SizedBox(
                        height: 140.0,
                        child: Hero(
                            tag: 'logo',
                            child: new Image.asset('assets/images/logo.png'))),
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                  textfield('Enter your email', false, (value) {
                    email = value;
                  }),
                  textfield('Enter your password', true, (value) {
                    password = value;
                  }, "Password should be of minimum 6 characters!"),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: new Material(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(18.0),
                      child: new MaterialButton(
                        splashColor: Colors.lightBlueAccent,
                        child: new Text('Sign Up',
                            style: new TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          try {
                            final user =
                                await _auth.createUserWithEmailAndPassword(
                                    email: email, password: password);

                            if (user != null) {
                              setState(() {
                                loading = false;
                              });
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "Account Created!",
                                desc: "",
                                buttons: [
                                  DialogButton(
                                    color: Colors.lightBlueAccent,
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (context) => HomePage())),
                                    width: 120,
                                  )
                                ],
                              ).show();
                            }
                          } catch (ERROR_WEAK_PASSWORD) {
                            setState(() {
                              loading = false;
                            });
                            Alert(
                              context: context,
                              type: AlertType.error,
                              title: "ERROR",
                              desc:
                                  "- Password should be of minimum 6 characters\n (OR) \n - Email already exists",
                              buttons: [
                                DialogButton(
                                  color: Colors.lightBlueAccent,
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  width: 120,
                                )
                              ],
                            ).show();
                          }
                        },
                        minWidth: 200.0,
                        height: 26.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
