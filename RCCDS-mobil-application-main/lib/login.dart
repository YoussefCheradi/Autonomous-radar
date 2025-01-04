import 'dart:async';
import 'package:database/accueil.dart';
import 'package:database/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'register.dart';
import 'main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'user.dart';
import 'auth.dart';
import 'forgetpassword.dart';

void main() => runApp(const MaterialApp(
  home: login(),
  debugShowCheckedModeBanner: false,
));

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => loginscreen();
}

class loginscreen extends State<login> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  String email = '';
  String password = '';
  String error = '';

  final AuthService _auth = AuthService();

  bool visible = true;
  bool code = true;


  @override

  Widget build(BuildContext context) {

    // final user = Provider.of<Usere?>(context);
    // print(user);

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.only(bottom: 594),
              child: Image.asset('images/background.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150,right: 80),
            child: Transform.scale(
              scale: 1.5,
              child: Image.asset('images/curve.png'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60,left: 22),
            child: Text(
              'Hello\nLogin !',
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50,left: 340),
            child: IconButton(
              onPressed: (){

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => const home()));
              },
              icon: const Icon(
                Icons.home,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 300),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value))
                            {
                              return 'Veuillez saisir votre email correct';
                            }
                            return null;
                          },
                          onChanged: (val){
                            setState(() {
                              email = val;
                            });
                          },
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.mail,
                              color: Colors.black,
                            ),
                            label: Text(
                              'Gmail',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.length <6) {
                              return 'Veuillez saisir votre password (+6)';
                            }
                            return null;
                          },
                          onChanged: (val){
                            setState(() {
                              password = val;
                            });
                          },
                          obscureText: visible,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: visible
                                    ? const Icon(Icons.visibility_off,
                                    color: Colors.black)
                                    : const Icon(Icons.visibility, color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    visible = !visible;
                                  });
                                }),
                            label: const Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 200),
                          child: InkWell(
                            onTap: () {

                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context) => const forget()));
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              // dynamic result = await _auth.signInAnon();
                              // if(result == null){
                              //   print('erreur sign in');
                              // }else{
                              //   print('sign in');
                              //   print(result);
                              //}
                              if (formKey.currentState!.validate()) {

                                dynamic result = await _auth.LoginWhith(email, password);
                                const TextStyle snackBarTextStyle = TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                );
                                if(result == null){

                                  const snackBar = SnackBar(
                                      content: Text('Login Error',style: snackBarTextStyle,
                                        textAlign: TextAlign.center,));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }else{
                                  const snackBar = SnackBar(
                                      content: Text('Login Success',style: snackBarTextStyle,
                                        textAlign: TextAlign.center,));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const accueil()));
                                }
                              }
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(horizontal: 65, vertical: 10),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0), // Bord arrondi du bouton
                                ),
                              ),
                              elevation: MaterialStateProperty.all<double>(15.0), // Élévation du bouton
                            ),
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.black,),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 70,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            children: [
                              const Text(
                                "Don't have account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                              InkWell(
                                onTap: () {

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const register()));
                                },
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
