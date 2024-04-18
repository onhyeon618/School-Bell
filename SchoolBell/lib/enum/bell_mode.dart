enum BellMode {
  onTime(name: '정각 모드', description: '매 시 50분과 0분에 울려요.'),
  byCustom(name: '커스텀 모드', description: '시작한 순간부터 시간을 재요.');

  const BellMode({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}
