import 'package:express_chat/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:express_chat/main.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email;
  String password;
  String roomid;
  bool loading = false;
  bool _validate = false;

  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  final roomidcontroller = new TextEditingController();
  final emailidcontroller = new TextEditingController();
  final passwordcontroller = new TextEditingController();
  Widget textfield(String hinttext, bool value, Function onChanged,
      int maxlength, Function validator, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: new TextFormField(
        validator: validator,
        autovalidate: _validate,
        controller: controller,
        maxLength: maxlength,
        textAlign: TextAlign.center,
        obscureText: value,
        keyboardType: TextInputType.emailAddress,
        onChanged: onChanged,
        decoration: InputDecoration(
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
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new SizedBox(
                  height: 50.0,
                ),
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
                textfield(
                    'Enter your email',
                    false,
                    (value) {
                      email = value;
                    },
                    null,
                    (String arg) {
                      if (arg.length == 0)
                        return 'Cannot be empty!';
                      else
                        return null;
                    },
                    emailidcontroller),
                textfield(
                    'Enter your password',
                    true,
                    (value) {
                      password = value;
                    },
                    null,
                    (String arg) {
                      if (arg.length == 0)
                        return 'Cannot be empty!';
                      else
                        return null;
                    },
                    passwordcontroller),
                textfield(
                    'Enter Room ID:',
                    false,
                    (value) {
                      roomid = value;
                    },
                    6,
                    (String arg) {
                      if (arg.length == 0)
                        return 'Cannot be empty!';
                      else
                        return null;
                    },
                    roomidcontroller),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: new Material(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(18.0),
                    child: new MaterialButton(
                      splashColor: Colors.blueAccent,
                      child: new Text('Create Room',
                          style: new TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      onPressed: () async {
                        if (roomidcontroller.text.isEmpty ||
                            emailidcontroller.text.isEmpty ||
                            passwordcontroller.text.isEmpty) {
                          setState(() {
                            _validate = true;
                          });
                        } else if (emailidcontroller.text.isNotEmpty &&
                            passwordcontroller.text.isNotEmpty) {
                          setState(() {
                            loading = true;
                          });
                          try {
                            final newUser =
                                await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);
                            _firestore.collection('$roomid');
                            _firestore
                                .collection('$roomid' + 'counter')
                                .document('counterValue')
                                .setData({
                              'counter': 1111111111111111111.toString()
                            });
                            if (newUser != null) {
                              setState(() {
                                loading = false;
                              });
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "ROOM CREATED SUCCESSFULLY",
                                desc: "With Room ID:$roomid",
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
                                  ),
                                ],
                              ).show();
                            }
                          } catch (ERROR_USER_NOT_FOUND) {
                            setState(() {
                              loading = false;
                            });
                            Alert(
                              context: context,
                              type: AlertType.info,
                              title: "USER NOT FOUND",
                              desc: "Sign Up for a new account",
                              buttons: [
                                DialogButton(
                                  color: Colors.lightBlueAccent,
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (context) => NewUser())),
                                  width: 120,
                                )
                              ],
                            ).show();
                          }
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
    );
  }
}
