

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  SharedPreferences _prefs;

  LoginState(){
    loginState();
  }

  bool _loggedIn = false;
  bool _loading = true;

  bool isLoggedIn() => _loggedIn;

  bool isLoading() => _loading;

  User currentUser() => _user;

  void login(email, pass) async{
    _loading = true;
    notifyListeners();

    if(email != null && pass != null){
      _user = await register(email, pass);
    } else {
      _user = await _handleSignIn();
    }

    _loading = false;
    if (_user != null){
      _prefs.setBool('isLoggedIn', true);
      _loggedIn = true;
      notifyListeners();
    } else {
      _loggedIn = false;
      notifyListeners();
    }
  }

  void logout(){
    _prefs.clear();
    _googleSignIn.signOut();
    _loggedIn = false;
    notifyListeners();
  }

  Future<User> _handleSignIn() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    print('signed in :'+ userCredential.user.displayName);
    // Once signed in, return the UserCredential
    return userCredential.user;
  }

  void loginState() async{
    _prefs = await SharedPreferences.getInstance();
    if(_prefs.containsKey('isLoggedIn')){
      _user = _auth.currentUser;
      _loggedIn = _user != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }


  Future<User> register(email, password) async {
    User registerUser;
    try {
      registerUser = (await
      _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
      ).user;
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password
        );
        registerUser = userCredential.user;
      }
    } catch (e) {
      print(e);
    }

    return registerUser;
  }
}