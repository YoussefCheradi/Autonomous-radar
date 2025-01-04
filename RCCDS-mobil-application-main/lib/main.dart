import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'user.dart';
import 'auth.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBvj0d7wNmR22_VEds8WN8j9bQvhMSyA_c",
        appId: "1:1019891820257:android:6f7aa1e42a5e32c1ae39a0",
        messagingSenderId: "1019891820257",
        projectId: "projet-login-3cef0"),
  );
  runApp(const MaterialApp(
    home: home(),
    debugShowCheckedModeBanner: false,
  ));
}

class home extends StatefulWidget {
  const home({super.key});


  @override
  State<home> createState() => homescreen();
}

class homescreen extends State<home> {
  bool visible = true;
  bool code = true;

  @override
  Widget build(BuildContext context) {

    return StreamProvider<Usere?>.value(
      initialData: null,
      value: AuthService().user,

      child: Scaffold(

        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.only(bottom: 594),
              child: Transform.scale(
                scale: 2,
                child: Image.asset('images/background.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 309,right: 310),
              child: Transform.scale(
                scale: 4.9,
                child: Image.asset('images/curve2.png'),
              ),
            ),
            Container(
              child: const Padding(
                padding: EdgeInsets.only(top: 300,bottom: 400,left: 110),
                child: CircleAvatar(
                  backgroundImage: AssetImage('tsawer/Screenshot_2024-04-04_141952-removebg-preview.png'),
                  backgroundColor: Colors.transparent,
                  radius: 90,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 700,left: 97),
              child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> register()));

                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 55, vertical: 10),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Bord arrondi du bouton
                      ),
                    ),
                    elevation: MaterialStateProperty.all<double>(15.0), // Élévation du bouton
                  ),
                  child: const Text('Sign Up',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 600,left: 95),
              child: ElevatedButton(
                  onPressed: (){

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  login())
                    );
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 66, vertical: 10),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Bord arrondi du bouton
                      ),
                    ),
                    elevation: MaterialStateProperty.all<double>(15.0), // Élévation du bouton
                  ),
                  child: const Text('Log In',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
