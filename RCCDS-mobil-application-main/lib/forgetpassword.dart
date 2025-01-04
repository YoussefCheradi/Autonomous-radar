import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';

void main() => runApp(const MaterialApp(
  home: forget(),
  debugShowCheckedModeBanner: false,
));

class forget extends StatefulWidget {
  const forget({super.key});


  @override
  State<forget> createState() => forgetscreen();
}

class forgetscreen extends State<forget> {

  TextEditingController emailController = TextEditingController();
  String email = '';
  bool visible = true;
  bool code = true;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset(String emailController) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController);
      showDialog(context: context, builder: (context) {
        return const AlertDialog(
          content: Text(
            'Mot de passe envoyé à votre email avec succès!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      );
    }on FirebaseAuthException {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              "Écrit l'email sous sa forme",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.only(bottom: 594),
            child: Image.asset('images/background.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150,right: 80),
            child: Transform.scale(
              scale: 1.5,
              child: Image.asset('images/curve.png'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40,left: 22),
            child: Text(
              'Recuperer\n    votre \npassword',
              style: TextStyle(
                fontSize: 37,
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
          Padding(
            padding: const EdgeInsets.only(top: 420,left: 50,right: 50),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black,width: 3),
                    borderRadius: BorderRadius.circular(12)
                ),
                label: const Text(
                  'Entrer votre email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              style: const TextStyle(fontSize: 20,color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 590,left: 70),
            child: ElevatedButton(
                onPressed: (){
                  passwordReset(emailController.text.trim());
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Bord arrondi du bouton
                    ),
                  ),
                  elevation: MaterialStateProperty.all<double>(15.0), // Élévation du bouton
                ),
                child: const Text('Reset password',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}
