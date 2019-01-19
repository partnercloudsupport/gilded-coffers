import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:dnd_coin_balancer/firebase_functions.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:google_sign_in/google_sign_in.dart';

enum FormMode { LOGIN, SIGNUP }

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignIn});
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _name;
  String _errorMessage;

  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  @override
  void initState() {
    _errorMessage = '';
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _showBody(),
//          _showCircularProgress(),
        ],
      )
    );
  }

  Widget _showBody() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showNameInput(),
              _showButtons(),
            ]
          )
        )
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showLogo() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 100.0),
      child: Column(
        children: <Widget>[
          Image.asset('icon/GC-logo.png'),
        ],
      )
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.0, 0.0, 10.0, 5.0),
      child: TextFormField(
        controller: _emailController,
        decoration: new InputDecoration(
          hintText: 'Email',
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          )
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      )
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.0, 5.0, 10.0, 5.0),
      child: TextFormField(
        controller: _passwordController,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )
        ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
        obscureText: true,
      )
    );
  }

  Widget _showNameInput() {
    if (_formMode == FormMode.SIGNUP){
      return Padding(
          padding: EdgeInsets.fromLTRB(4.0, 5.0, 10.0, 0.0),
          child: TextFormField(
            controller: _nameController,
            decoration: new InputDecoration(
                hintText: 'Name',
                icon: new Icon(
                  Icons.perm_identity,
                  color: Colors.grey,
                )
            ),
            validator: (value) => value.isEmpty && _formMode == FormMode.SIGNUP ? 'Email can\'t be empty' : null,
            onSaved: (value) => _name = value,
          )
      );
    } else {
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }
  }

  Widget _showButtons() {
    return ButtonBar(
      children: <Widget>[
        _secondaryButton(),
        _mainButton(),
      ],
    );
  }

  Widget _mainButton() {
    return RaisedButton(
      child: Text(
          _formMode == FormMode.LOGIN ? 'LOGIN' : 'SIGN UP'
      ),
      onPressed: () {
        _loginSignUpHandler();
      },
    );
  }

  Widget _secondaryButton() {
    return FlatButton(
      child: Text(
        _formMode == FormMode.LOGIN ? 'Create New Account' : 'Existing Account'
      ),
      onPressed: () {
        if (_formMode == FormMode.LOGIN){
          setState(() {
            _formMode = FormMode.SIGNUP;
          });
        } else {
          setState(() {
            _formMode = FormMode.LOGIN;
          });
        }
        _emailController.clear();
        _passwordController.clear();
      },
    );
  }

  void _loginSignUpHandler() async {
    if (validateSaveForm()){
      try {
        String uid = '';
        if (_formMode == FormMode.LOGIN){
          uid = await widget.auth.signInEP(_email, _password);
        } else {
          uid = await widget.auth.signUpEP(_email, _password);
          await widget.auth.initialSetup(uid, _name);
        }
        if (uid.length > 0 && uid != null){
          widget.onSignIn();
        }
      } catch(err) {
        setState(() {
          if (_isIos){
            _errorMessage = err.details;
            print(_errorMessage);
          } else {
            _errorMessage = err.message;
            print(_errorMessage);
          }
        });
      }
    }
  }

  bool validateSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    }
    return false;
  }

//  Future<FirebaseUser> _handleSignIn() async {
//    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//    FirebaseUser user = await _auth.signInWithGoogle(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//    print("signed in " + user.displayName);
//    return user;
//  }

//  Widget _showCircularProgress(){
//    if (_isLoading) {
//      return Center(child: CircularProgressIndicator());
//    } return Container(height: 0.0, width: 0.0,);
//
//  }
//
//  Widget _showEmailInput() {
//    return Padding(
//      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
//      child: new TextFormField(
//        maxLines: 1,
//        keyboardType: TextInputType.emailAddress,
//        autofocus: false,
//        decoration: new InputDecoration(
//            hintText: 'Email',
//            icon: new Icon(
//              Icons.mail,
//              color: Colors.grey,
//            )),
//        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
//        onSaved: (value) => _email = value,
//      ),
//    );
//  }

//  Widget _showPasswordInput() {
//    return Padding(
//      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
//      child: new TextFormField(
//        maxLines: 1,
//        obscureText: true,
//        autofocus: false,
//        decoration: new InputDecoration(
//            hintText: 'Password',
//            icon: new Icon(
//              Icons.lock,
//              color: Colors.grey,
//            )),
//        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
//        onSaved: (value) => _password = value,
//      ),
//    );
//  }

//  Widget _showPrimaryButton() {
//    return new Padding(
//        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
//        child: new MaterialButton(
//          elevation: 5.0,
//          minWidth: 200.0,
//          height: 42.0,
//          color: Colors.blue,
//          child: _formMode == FormMode.LOGIN
//              ? new Text('Login',
//              style: new TextStyle(fontSize: 20.0, color: Colors.white))
//              : new Text('Create account',
//              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
//          onPressed: _validateAndSubmit,
//        )
//    );
//  }
//
//  Widget _showSecondaryButton() {
//    return new FlatButton(
//      child: _formMode == FormMode.LOGIN
//          ? new Text('Create an account',
//          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
//          : new Text('Have an account? Sign in',
//          style:
//          new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
//      onPressed: _formMode == FormMode.LOGIN
//          ? _changeFormToSignUp
//          : _changeFormToLogin,
//    );
//  }
//
//  void _changeFormToSignUp() {
//    _formKey.currentState.reset();
//    _errorMessage = "";
//    setState(() {
//      _formMode = FormMode.SIGNUP;
//    });
//  }
//
//  void _changeFormToLogin() {
//    _formKey.currentState.reset();
//    _errorMessage = "";
//    setState(() {
//      _formMode = FormMode.LOGIN;
//    });
//  }

//  Widget _showErrorMessage() {
//    if (_errorMessage.length > 0 && _errorMessage != null) {
//      return new Text(
//        _errorMessage,
//        style: TextStyle(
//            fontSize: 13.0,
//            color: Colors.red,
//            height: 1.0,
//            fontWeight: FontWeight.w300),
//      );
//    } else {
//      return new Container(
//        height: 0.0,
//      );
//    }
//  }
//
//  Widget _showBody(){
//    return new Container(
//        padding: EdgeInsets.all(16.0),
//        child: new Form(
//          key: _formKey,
//          child: new ListView(
//            shrinkWrap: true,
//            children: <Widget>[
//              _showLogo(),
//              _showEmailInput(),
//              _showPasswordInput(),
//              _showPrimaryButton(),
//              _showSecondaryButton(),
//              _showErrorMessage(),
//            ],
//          ),
//        )
//    );
//  }
}

//void _loginWithGoogle(){
//  GoogleSignIn googleSignIn ...;
//  void _authenticateWithGoogle() async {
//  final GoogleSignInAccount googleUser = await googleSignIn.signIn();
//  final GoogleSignInAuthentication googleAuth =
//  await googleUser.authentication;
//  final FirebaseUser user = await
//  widget.firebaseAuth.signInWithGoogle(
//  accessToken: googleAuth.accessToken,
//  idToken: googleAuth.idToken,
//  );
//  // do something with signed-in user
//  }
//}