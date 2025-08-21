enum DialogType {
  basic(positive: '확인', negative: '취소'),
  setClassSize(positive: '시작', negative: '취소'),
  setBellMode(positive: '설정하기', negative: '취소'),
  setTimeLength(positive: '설정하기', negative: '취소'),
  setBellSound(positive: '설정하기', negative: '취소');

  const DialogType({required this.positive, required this.negative});

  final String positive;
  final String negative;
}
