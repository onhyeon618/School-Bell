import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:school_bell/enum/class_state.dart';
import 'package:vector_graphics/vector_graphics.dart';

class ClassScreen extends StatelessWidget {
  const ClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 상태 관리 방식 고민
    final int currentState = context.select<ClassManager, int>((ClassManager cm) => cm.currentState);
    final int currentClass = context.read<ClassManager>().currentClass;

    final String classStr = currentState == 0 ? '' : currentClass.toString();

    final size = MediaQuery.of(context).size.width - 40;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            // TODO: currentState 타입을 ClassState 으로 변경
            '$classStr${ClassState.values[currentState].description}',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 46),
          SvgPicture(
            AssetBytesLoader(ClassState.values[currentState].imagePath),
            width: size,
            height: size,
          ),
        ],
      ),
    );
  }
}
