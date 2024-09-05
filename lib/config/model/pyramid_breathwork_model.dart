class PyramidBreathworkModel {
  
  String? title;
  String? speed; 
  String? step;
  bool? jerryVoice;
  bool? music;
  bool? chimes;
  String? choiceOfBreathHold;
  List<int>? breathingTimeList;
  List<int>? holdTimeList;

  PyramidBreathworkModel({
    required this.title,
    required this.speed,
    required this.step,
    required this.jerryVoice,
    required this.music,
    required this.chimes,
    required this.choiceOfBreathHold,
    required this.breathingTimeList,
    required this.holdTimeList,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'speed': speed,
      'step': step,
      'jerryVoice': jerryVoice,
      'music': music,
      'chimes': chimes,
      'choiceOfBreathHold': choiceOfBreathHold,
      'breathingTimeList': breathingTimeList,
      'holdTimeList': holdTimeList,
    };
  }

  // Create from JSON
  factory PyramidBreathworkModel.fromJson(Map<String, dynamic> json) {
    return PyramidBreathworkModel(
      title: json['title'],
      speed: json['speed'],
      step: json['step'],
      jerryVoice: json['jerryVoice'],
      music: json['music'],
      chimes: json['chimes'],
      choiceOfBreathHold: json['choiceOfBreathHold'],
      breathingTimeList: List<int>.from(json['breathingTimeList']),
      holdTimeList: List<int>.from(json['holdTimeList']),
    );
  }
}