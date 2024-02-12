import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:vector_graphics/vector_graphics.dart';

class ClassScreen extends StatelessWidget {
  const ClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          titleText(context),
          const SizedBox(height: 46),
          mainImage(context),
        ],
      ),
    );
  }

  Widget titleText(BuildContext context) {
    final int currentState = context.select<ClassManager, int>((ClassManager cm) => cm.currentState);
    final int currentClass = context.read<ClassManager>().currentClass;

    switch (currentState) {
      case CurrentState.waiting:
        return Text(
          '지금은 쉬는 중♡',
          style: Theme.of(context).textTheme.displayLarge,
        );
      case CurrentState.inClass:
        return Text(
          '$currentClass교시 수업 중…',
          style: Theme.of(context).textTheme.displayLarge,
        );
      case CurrentState.restTime:
        return Text(
          '$currentClass교시 쉬는 시간',
          style: Theme.of(context).textTheme.displayLarge,
        );
      default:
        return Text(
          '지금은 쉬는 중♡',
          style: Theme.of(context).textTheme.displayLarge,
        );
    }
  }

  Widget mainImage(BuildContext context) {
    final int currentState = context.select<ClassManager, int>((ClassManager cm) => cm.currentState);

    final width = MediaQuery.of(context).size.width - 40;
    final height = MediaQuery.of(context).size.width - 40;

    switch (currentState) {
      case CurrentState.waiting:
        return SvgPicture(
          const AssetBytesLoader('assets/character/character_play.svg.vec'),
          width: width,
          height: height,
        );
      case CurrentState.inClass:
        return SvgPicture(
          const AssetBytesLoader('assets/character/character_study.svg.vec'),
          width: width,
          height: height,
        );
      case CurrentState.restTime:
        return SvgPicture(
          const AssetBytesLoader('assets/character/character_rest.svg.vec'),
          width: width,
          height: height,
        );
      default:
        return SvgPicture(
          const AssetBytesLoader('assets/character/character_play.svg.vec'),
          width: width,
          height: height,
        );
    }
  }
}
