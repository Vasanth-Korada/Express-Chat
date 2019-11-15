import 'package:flutter/material.dart';
import 'package:express_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

FirebaseUser loggedInUser;
final _firestore = Firestore.instance;
String roomid;
String roomemail;
String documentNumber;
var now = new DateTime.now();
var time = new DateFormat("H:m:s:ms").format(now);
bool loading = false;

class ChatScreen extends StatefulWidget {
  ChatScreen(String roomId, String roomEmail) {
    roomid = roomId;
    roomemail = roomEmail;
  }
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _textcontroller = new TextEditingController();
  // int counter = 1111111111111111111;
  String messageText;

  Future<Null> getCounterValue() async {
    _firestore
        .collection('$roomid' + 'counter')
        .document('counterValue')
        .get()
        .then((DocumentSnapshot snapshot) {
      this.setState(() {
        int temp = int.parse(snapshot.data['counter']);
        documentNumber = (temp - 1).toString();
        debugPrint("Get Counter Value : $documentNumber");
      });
    });
  }

  String incrementCounter() {
    _firestore
        .collection('$roomid' + 'counter')
        .document('counterValue')
        .get()
        .then((snapshot) {
      int counter = int.parse(snapshot.data['counter']);
      counter = counter + 1;
      _firestore
          .collection('$roomid' + 'counter')
          .document('counterValue')
          .setData({'counter': counter.toString()});
      documentNumber = counter.toString();
    });
    return (documentNumber.toString());
  }

  @override
  void initState() {
    getCounterValue();
    getUser();
    super.initState();
  }

  void getUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            Row(
              children: <Widget>[
                new Text(
                  "SIGN OUT",
                  style: new TextStyle(
                      fontFamily: "Open Sans",
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                IconButton(
                    icon: Icon(Icons.power_settings_new),
                    tooltip: "Sign Out",
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      final _firestore = Firestore.instance;
                      _firestore
                          .collection('users')
                          .document('$roomemail')
                          .setData({'roomid': ""});
                      print("Preferences Removed");
                      _auth.signOut();
                      setState(() {
                        loading = false;
                      });
                      Navigator.pop(context);
                    }),
              ],
            ),
          ],
          title: Text('ROOM:$roomid'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessageStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.lightBlueAccent,
                        cursorWidth: 2.0,
                        style: TextStyle(fontWeight: FontWeight.w500),
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        controller: _textcontroller,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: RaisedButton(
                        color: Colors.lightBlueAccent,
                        onPressed: () {
                          _textcontroller.clear();
                          String documentNumber = incrementCounter();
                          debugPrint("Document Number : $documentNumber");
                          _firestore
                              .collection('$roomid')
                              .document(documentNumber.toString())
                              .setData({
                            'sender': loggedInUser.email,
                            'text': messageText,
                          });
                        },
                        child: Text(
                          'Send',
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold),
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

class MessageStream extends StatefulWidget {
  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('$roomid').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: new LinearProgressIndicator());
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            children: snapshot.data.documents.reversed.map((document) {
              return new MessageBox(
                text: document['text'],
                sender: document['sender'],
                isMe: loggedInUser.email == document['sender'],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class MessageBox extends StatelessWidget {
  MessageBox({@required this.sender, @required this.text, @required this.isMe});
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          '$sender',
          style: new TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: GestureDetector(
            child: Material(
              elevation: 6.0,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: new Text(
                  '$text',
                  style: new TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 14.0,
                      color: isMe ? Colors.white : Colors.black54),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
