class FireBreathworkModel {
  
  String? title;
  String? numberOfSets; 
  int? durationOfEachSet; 
  bool? jerryVoice;
  bool? holdPeriodEnabled;
  bool? recoveryEnabled;
  bool? music;
  bool? chimes;
  bool? pineal;
  String? choiceOfBreathHold;
  List<int>? breathingTimeList;
  List<int>? holdTimeList;
  List<int>? recoveryTimeList;

  FireBreathworkModel({
    required this.title,
    required this.numberOfSets,
    required this.durationOfEachSet,
    required this.jerryVoice,
    required this.holdPeriodEnabled,
    required this.recoveryEnabled,
    required this.music,
    required this.chimes,
    required this.pineal,
    required this.choiceOfBreathHold,
    required this.breathingTimeList,
    required this.holdTimeList,
    required this.recoveryTimeList,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'numberOfSets': numberOfSets,
      'durationOfEachSet': durationOfEachSet,
      'jerryVoice': jerryVoice,
      'holdPeriodEnabled': holdPeriodEnabled,
      'recoveryEnabled': recoveryEnabled,
      'music': music,
      'chimes': chimes,
      'pineal': pineal,
      'choiceOfBreathHold': choiceOfBreathHold,
      'breathingTimeList': breathingTimeList,
      'holdTimeList': holdTimeList,
      'recoveryTimeList': recoveryTimeList,
    };
  }

  // Create from JSON
  factory FireBreathworkModel.fromJson(Map<String, dynamic> json) {
    return FireBreathworkModel(
      title: json['title'],
      numberOfSets: json['numberOfSets'],
      durationOfEachSet: json['durationOfEachSet'],
      jerryVoice: json['jerryVoice'],
      holdPeriodEnabled: json['holdPeriodEnabled'],
      recoveryEnabled: json['recoveryEnabled'],
      music: json['music'],
      chimes: json['chimes'],
      pineal: json['pineal'],
      choiceOfBreathHold: json['choiceOfBreathHold'],
      breathingTimeList: List<int>.from(json['breathingTimeList']),
      holdTimeList: List<int>.from(json['holdTimeList']),
      recoveryTimeList: List<int>.from(json['recoveryTimeList']),
    );
  }
}