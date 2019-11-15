import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'screens/create_room.dart';
import 'package:express_chat/screens/join_rom.dart';
import 'screens/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
    title: "Express Chat",
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Widget homepagebutton(String title, Color color, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: new Material(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        child: new MaterialButton(
          splashColor: color,
          child: new Text(title,
              style: new TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          onPressed: onPressed,
          minWidth: 200.0,
          height: 26.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Container(
                  height: 70.0,
                  child: Hero(
                      tag: 'logo',
                      child: new Image.asset('assets/images/logo.png')),
                ),
              ),
              Flexible(
                child: SizedBox(
                  width: 300,
                  child: TypewriterAnimatedTextKit(
                      text: [
                        "Express Chat",
                      ],
                      textStyle: TextStyle(
                        fontSize: 42.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Open Sans",
                        color: Colors.deepOrangeAccent,
                      ),
                      textAlign: TextAlign.start,
                      alignment: AlignmentDirectional.topStart),
                ),
              ),
            ],
          ),
          new SizedBox(
            height: 50.0,
          ),
          homepagebutton('Join Room', Colors.lightBlueAccent, () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
          }),
          homepagebutton('Create Room', Colors.blueAccent.shade200, () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => RegisterScreen()));
          }),
          homepagebutton('Sign Up', Colors.indigoAccent.shade200, () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => NewUser()));
          }),
        ],
      ),
    );
  }
}
