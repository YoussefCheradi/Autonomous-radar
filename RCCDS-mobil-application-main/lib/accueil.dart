import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'VideoPlayerrrr.dart';
import 'login.dart';
import 'user.dart';
import 'auth.dart';
import 'main.dart';
import 'database.dart';

void main() => runApp(const MaterialApp(
  home: accueil(),
  debugShowCheckedModeBanner: false,
));

class accueil extends StatefulWidget {
  const accueil({super.key});

  @override
  State<accueil> createState() => accueilscreen();
}

class accueilscreen extends State<accueil> {
  AuthService authService = AuthService();
  late QuerySnapshot? data;

  bool loading = true;
  bool visible = true;
  bool code = true;
  bool showImage = false;
  int refrech = 0;


  Future<void> getData(String uid) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('infractions')
        .doc('infraction1')
        .get();
    if (userSnapshot.exists) {
      CollectionReference infractionsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('infractions');
      QuerySnapshot infractionsSnapshot = await infractionsRef.get();
      setState(() {
        data = infractionsSnapshot;
        loading = false;
      });
    } else {
      setState(() {
        data = null;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;
    getData(currentUid);
  }

  @override
  Future<void> refreshPage() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const accueil()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: RefreshIndicator(
        onRefresh: () => getData(FirebaseAuth.instance.currentUser!.uid),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.only(bottom: 594),
              child: Image.asset('images/background.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150, right: 80),
              child: Transform.scale(
                scale: 1.5,
                child: Image.asset('images/curve.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 340),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const home()));
                },
                icon: const Icon(
                  Icons.home,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 180, left: 280),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu_open_outlined,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 260),
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : data == null
                  ? Center(
                  child: const Text(
                    'No data exist',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              )
                  : GridView.builder(
                itemCount: data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, mainAxisExtent: 160),
                itemBuilder: (context, i) {
                  Map<String, dynamic> item = data!.docs[i].data()! as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.only(top: 20, right: 15),
                    height: 130,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1, 8),
                            blurRadius: 20,
                            spreadRadius: 20,
                          )
                        ]),
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, left: 8),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.orange,
                                        width: 4,
                                      ),
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('tsawer/Screenshot_2024-04-04_141952-removebg-preview.png'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["nature d'infraction"] ?? 'N/A',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF00017E),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        item["localisation"] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 19),
                                child: Text(
                                  item["date"] ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 50, top: 5),
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.grey,
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (item["image"] == null || item["image"].isEmpty) {
                                                const snackBar = SnackBar(
                                                    content: Text(
                                                      'Image not exist',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ));
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Image.network(item["image"]),
                                                    );
                                                  },
                                                );
                                              }
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.photo_size_select_actual_outlined,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.grey,
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (item["video"] == null || item["video"].isEmpty) {
                                                const snackBar = SnackBar(
                                                    content: Text(
                                                      'Video not exist',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ));
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      content: VideoPlayerr(videoUrl: item["video"]),
                                                    );
                                                  },
                                                );
                                              }
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.video_collection_sharp,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 27),
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 20),
                                        width: 50,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.grey,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              if (item["PV"] == null || item["PV"].isEmpty) {
                                                const snackBar = SnackBar(
                                                    content: Text(
                                                      'PV not exist',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ));
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Image.network(item["PV"]),
                                                    );
                                                  },
                                                );
                                              }
                                            });
                                          },
                                          child: const Text(
                                            'PV',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item["prix"] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
