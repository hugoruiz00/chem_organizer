// main.dart
import 'dart:ui';

import 'package:chem_organizer/src/pages/login_page.dart';
import 'package:chem_organizer/src/pages/main_view.dart';
import 'package:chem_organizer/src/pages/message_view.dart';
import 'package:chem_organizer/src/services/push_notifications_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await PushNotificationsServices.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    //context
    PushNotificationsServices.messagesStream.listen((message) {
      //print('My App $message');
      navigatorKey.currentState?.pushNamed('message', arguments: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: 'home',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueGrey.shade50,
        accentColor: Colors.deepPurpleAccent.shade100,
        errorColor: Colors.amber,
        dialogTheme: DialogTheme(),
        appBarTheme: AppBarTheme(
          elevation: 0,
          brightness: Brightness.dark,
          titleSpacing: 10,
          backgroundColor: Color.fromRGBO(133, 45, 145, 1.0),
        ),
        cardTheme: CardTheme(
          color: Color.fromRGBO(178, 91, 165, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
          ),
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        ),
        timePickerTheme: TimePickerThemeData(
          helpTextStyle: TextStyle(color: Colors.white70),
          backgroundColor: Colors.purple.shade400,
          dialHandColor: Colors.amber.shade500,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
              height: 3,
              fontSize: 30.0,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w500,
              color: Colors.white70),
          headline2: TextStyle(
              height: 3,
              fontSize: 28.0,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w500,
              color: Colors.white70),
          headline3: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade400),
          bodyText1: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      routes: {
        'home': (_) => FirebaseAuth.instance.currentUser == null
            ? LoginPage()
            : MainView(user: FirebaseAuth.instance.currentUser!.uid),
        'message': (_) => MessageView(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
