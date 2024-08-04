import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_bell/enum/class_state.dart';
import 'package:vector_graphics/vector_graphics.dart';

class ClassScreen extends StatelessWidget {
  final ClassState currentState;
  final int currentPeriod;

  const ClassScreen({
    super.key,
    required this.currentState,
    required this.currentPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final String classStr = currentState == ClassState.idle ? '' : '$currentPeriod';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$classStr${currentState.description}',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 46),
          SvgPicture(
            AssetBytesLoader(currentState.imagePath),
            width: MediaQuery.of(context).size.width - 40,
          ),
        ],
      ),
    );
  }
}
