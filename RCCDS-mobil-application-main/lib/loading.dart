import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class loading extends StatelessWidget {
  const loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xffff4b0f), Color(0xff000000)],
            stops: [0.2, 0.7]
        ),
      ),
      child: Center(
        child: SpinKitCircle(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
