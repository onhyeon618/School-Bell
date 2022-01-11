import 'package:flutter/material.dart';

class CountingScreen extends StatelessWidget {
  CountingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '지금은 쉬는 중♡',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 46),
          Image.asset('assets/character_play.png')
        ],
      ),
    );
  }
}
