class PinealBreathworkModel {
  
  String? title;
  String? numberOfSets; 
  bool? jerryVoice;
  bool? music;
  bool? chimes;
  int? breathingPeriod;
  int? holdTimePerSet;
  int? recoveryTimePerSet;
  List<int>? breathingTimeList;
  List<int>? recoveryTimeList;

  PinealBreathworkModel({
    required this.title,
    required this.numberOfSets,
    required this.jerryVoice,
    required this.music,
    required this.chimes,
    required this.breathingPeriod,
    required this.holdTimePerSet,
    required this.recoveryTimePerSet,
    required this.breathingTimeList,
    required this.recoveryTimeList,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'numberOfSets': numberOfSets,
      'jerryVoice': jerryVoice,
      'music': music,
      'chimes': chimes,
      'breathingPeriod': breathingPeriod,
      'holdTimePerSet': holdTimePerSet,
      'recoveryTimePerSet': recoveryTimePerSet,
      'breathingTimeList': breathingTimeList,
      'recoveryTimeList': recoveryTimeList,
    };
  }

  // Create from JSON
  factory PinealBreathworkModel.fromJson(Map<String, dynamic> json) {
    return PinealBreathworkModel(
      title: json['title'],
      numberOfSets: json['numberOfSets'],
      jerryVoice: json['jerryVoice'],
      music: json['music'],
      chimes: json['chimes'],
      breathingPeriod: json['breathingPeriod'],
      holdTimePerSet: json['holdTimePerSet'],
      recoveryTimePerSet: json['recoveryTimePerSet'],
      breathingTimeList: List<int>.from(json['breathingTimeList']),
      recoveryTimeList: List<int>.from(json['recoveryTimeList']),
    );
  }
}