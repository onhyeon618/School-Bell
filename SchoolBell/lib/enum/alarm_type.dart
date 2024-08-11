enum AlarmType {
  /// 수업 종료
  classEnd,

  /// 쉬는시간 종료
  restEnd,

  /// 마지막 수업 종료
  lastClassEnd;

  factory AlarmType.fromInt(int state) {
    if (state == 0) {
      return AlarmType.classEnd;
    } else if (state == 1) {
      return AlarmType.restEnd;
    } else {
      return AlarmType.lastClassEnd;
    }
  }
}
