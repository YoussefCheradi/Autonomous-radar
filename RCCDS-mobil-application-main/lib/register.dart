import 'package:database/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'main.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'user.dart';
import 'auth.dart';
import 'globale_variable.dart';

void main() => runApp(const MaterialApp(
  home: register(),
  debugShowCheckedModeBanner: false,
));

class register extends StatefulWidget {
  const register({super.key});


  @override
  State<register> createState() => registerscreen();
}

class registerscreen extends State<register> {

  final formKey = GlobalKey<FormState>();


  String email = '';
  String password = '';
  String UserName = '';
  String error = '';

  final AuthService _auth = AuthService();

  final TextEditingController _controller = TextEditingController();

  bool visible = true;
  bool code = true;

  @override

  void dispose() {
    // N'oubliez pas de nettoyer le contrôleur lorsque le widget est supprimé
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.only(top: 60,left: 10),
            child: Text(
              'Hello\nSign Up !',
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
                  padding: const EdgeInsets.only(left: 18,right: 18),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          onChanged: (val){
                            setState(() {
                              text = val;
                            });
                          },
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.person,
                              color: Colors.black,),
                            label: Text('Matricule',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
                              return 'Veuillez saisir votre email';
                            }
                            return null;
                          },
                          controller: _controller,
                          onChanged: (val){
                            setState(() {
                              email = val;
                            });
                          },
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.mail,
                              color: Colors.black,),
                            label: Text('Gmail',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        TextFormField(
                          validator: (value) {
                            if (value!.length <6) {
                              return 'Veuillez saisir password';
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
                                icon: visible ? const Icon(Icons.visibility_off,color: Colors.black) :
                                const Icon(Icons.visibility,color: Colors.black),

                                onPressed: (){
                                  setState(() {
                                    visible = ! visible;
                                  });
                                }),
                            label: const Text('Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50,),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async{
                              if (formKey.currentState!.validate()) {
                                dynamic result = await _auth.registerWhith(email, password);
                                print('====$email====');
                                print('====$password====');
                                if(result == null){
                                  setState(() {
                                    error = 'votre enregistrement est echouer';
                                  });
                                  print(error);
                                }else{
                                  const TextStyle snackBarTextStyle = TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  );
                                  const snackBar = SnackBar(
                                      content: Text('Register Admet',style: snackBarTextStyle,
                                        textAlign: TextAlign.center,));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> login()));
                                }
                              }
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(horizontal: 65, vertical: 12),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0), // Bord arrondi du bouton
                                ),
                              ),
                              elevation: MaterialStateProperty.all<double>(15.0), // Élévation du bouton
                            ),
                            child : const Text('Register',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black
                              ),),
                          ),
                        ),
                        const SizedBox(height: 40,),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            children: [
                              const Text("Do you have account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),),
                              InkWell(
                                onTap: (){

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)=> login())
                                  );
                                },
                                child : const Text('Log In !',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.blue,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
