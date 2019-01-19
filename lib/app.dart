import 'package:flutter/material.dart';
import 'package:dnd_coin_balancer/firebase_functions.dart';
import 'login.dart';
import 'home.dart';
import 'splash.dart';

const gcCyan50 = const Color(0xffe0f7fa);

enum AuthState {UNCONFIRMED, NOT_LOGGED_IN, LOGGED_IN}

class GCApp extends StatefulWidget {
  GCApp({this.auth});
  final BaseAuth auth;

  State<StatefulWidget> createState() => new _GCAppState();
}

class _GCAppState extends State<GCApp> {
  AuthState authState = AuthState.UNCONFIRMED;
  String _uid;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
//        print(user == null);
        if (user != null){
//          print('user isnt null in theory');
          _uid = user.uid;
        }
        authState = _uid == null ? AuthState.NOT_LOGGED_IN : AuthState.LOGGED_IN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(authState){
      case AuthState.UNCONFIRMED:
        return new SplashScreen();
        break;
      case AuthState.NOT_LOGGED_IN:
        return new LoginPage(
            auth: widget.auth,
            onSignIn: _onSignIn,
        );
        break;
      case AuthState.LOGGED_IN:
        return new HomePage(
            auth: widget.auth,
            uid: _uid,
            onSignOut: _onSignOut,
        );
        break;
      default:
        return new SplashScreen();
    }
  }

  void _onSignOut(){
    setState(() {
      authState = AuthState.NOT_LOGGED_IN;
      _uid = '';
    });
  }

  void _onSignIn(){
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _uid = user.uid.toString();
      });
    });
    setState(() {
      authState = AuthState.LOGGED_IN;
    });
  }
}

//Widget _router() {
//  return new StreamBuilder<FirebaseUser>(
//      stream: FirebaseAuth.instance.onAuthStateChanged,
//      builder: (BuildContext context, snapshot) {
//        if (snapshot.connectionState == ConnectionState.waiting) {
//          return new SplashScreen();
//        } else {
//          if (snapshot.hasData) {
//            return new HomePage();
//          }
//          return new LoginPage();
//        }
//      }
//  );
//}

//Route<dynamic> _getRoute(RouteSettings settings) {
//  if (settings.name != '/login') {
//    return null;
//  }
//
//  return MaterialPageRoute<void>(
//    settings: settings,
//    builder: (BuildContext context) => LoginPage(),
//    fullscreenDialog: true,
//  );
//}
