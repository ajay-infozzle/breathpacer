class PyramidBreathworkModel {
  
  String? title;
  String? speed; 
  String? step;
  bool? jerryVoice;
  bool? music;
  bool? chimes;
  String? choiceOfBreathHold;
  int? holdDuration;
  List<int>? breathingTimeList;
  List<int>? holdBreathInTimeList;
  List<int>? holdBreathOutTimeList;

  PyramidBreathworkModel({
    required this.title,
    required this.speed,
    required this.step,
    required this.jerryVoice,
    required this.music,
    required this.chimes,
    required this.choiceOfBreathHold,
    required this.holdDuration,
    required this.breathingTimeList,
    required this.holdBreathInTimeList,
    required this.holdBreathOutTimeList,
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
      'holdDuration': holdDuration,
      'breathingTimeList': breathingTimeList,
      'holdBreathInTimeList': holdBreathInTimeList,
      'holdBreathOutTimeList': holdBreathOutTimeList,
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
      holdDuration: json['holdDuration'],
      breathingTimeList: List<int>.from(json['breathingTimeList']),
      holdBreathInTimeList: List<int>.from(json['holdBreathInTimeList']),
      holdBreathOutTimeList: List<int>.from(json['holdBreathOutTimeList']),
    );
  }
}