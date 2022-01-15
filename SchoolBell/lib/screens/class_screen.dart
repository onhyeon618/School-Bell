import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class ClassScreen extends StatelessWidget {
  const ClassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClassManager classManager = Provider.of<ClassManager>(context);

    int currentClass = classManager.currentClass;
    int currentState = classManager.currentState;
    String title;
    String imageUrl;

    switch(currentState) {
      case CurrentState.waiting:
        title = '지금은 쉬는 중♡';
        imageUrl = 'assets/character/character_play.png';
        break;
      case CurrentState.inClass:
        title = '$currentClass교시 수업 중…';
        imageUrl = 'assets/character/character_study.png';
        break;
      case CurrentState.restTime:
        title = '$currentClass교시 쉬는 시간';
        imageUrl = 'assets/character/character_rest.png';
        break;
      default:
        title = '지금은 쉬는 중♡';
        imageUrl = 'assets/character/character_play.png';
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
        const SizedBox(height: 46),
        Image.asset(
          imageUrl,
          width: MediaQuery.of(context).size.width - 40,
          height: MediaQuery.of(context).size.width - 40,
        ),
      ],
    );
  }
}