enum ClassState {
  idle(description: '지금은 쉬는 중♡', imagePath: 'assets/character/character_play.svg.vec'),
  inClass(description: '교시 수업 중…', imagePath: 'assets/character/character_study.svg.vec'),
  restTime(description: '교시 쉬는 시간', imagePath: 'assets/character/character_rest.svg.vec');

  const ClassState({required this.description, required this.imagePath});

  final String description;
  final String imagePath;

  factory ClassState.fromInt(int state) {
    if (state == 0) {
      return ClassState.idle;
    } else if (state == 1) {
      return ClassState.inClass;
    } else {
      return ClassState.restTime;
    }
  }
}
