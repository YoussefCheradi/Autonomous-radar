import 'dart:async';
import 'database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user.dart';
import 'register.dart';
import 'globale_variable.dart';

class AuthService {

  final FirebaseAuth auth = FirebaseAuth.instance;

  //create user obj based on firebase user

  Usere? _userFromfirebaseUser(User? user) {
    return user != null ? Usere(uid: user.uid) : null;
  }
  //auth change user strem
  Stream<Usere?> get user{
    // return _auth.authStateChanges().map((User? user) => _userFromfirebaseUser(user));
    return auth.authStateChanges().map(_userFromfirebaseUser);
  }
//register
  Future registerWhith(String email,String password) async{
    try{
      UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //creat new document for user with the uid
      await DatabaseService(uid: user!.uid).updateUserData(text);
      return _userFromfirebaseUser(user);
    }on FirebaseAuthException catch(e){

      return null;
    }
  }

  //login
  Future LoginWhith(String email,String password) async{
    try{
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromfirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signInAnon() async{
    try{
      UserCredential result = await auth.signInAnonymously();
      User? user = result.user;
      return _userFromfirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}