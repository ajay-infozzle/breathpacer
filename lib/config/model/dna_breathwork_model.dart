class DnaBreathworkModel {
  
  String? title;
  String? numberOfSets; 
  String? breathingApproach; 
  int? durationOfEachSet; 
  bool? jerryVoice;
  bool? recoveryEnabled;
  bool? holdEnabled;
  bool? music;
  bool? chimes;
  bool? pineal;
  String? choiceOfBreathHold;
  int? numberOfBreath;
  int? holdDuration;
  int? recoveryDuration;
  List<int>? breathingTimeList;
  List<int>? breathInholdTimeList;
  List<int>? breathOutholdTimeList;
  List<int>? recoveryTimeList;

  DnaBreathworkModel({
    required this.title,
    required this.numberOfSets,
    required this.breathingApproach,
    required this.durationOfEachSet,
    required this.jerryVoice,
    required this.recoveryEnabled,
    required this.holdEnabled,
    required this.music,
    required this.chimes,
    required this.pineal,
    required this.choiceOfBreathHold,
    required this.numberOfBreath,
    required this.holdDuration,
    required this.recoveryDuration,
    required this.breathingTimeList,
    required this.breathInholdTimeList,
    required this.breathOutholdTimeList,
    required this.recoveryTimeList,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'numberOfSets': numberOfSets,
      'breathingApproach': breathingApproach,
      'durationOfEachSet': durationOfEachSet,
      'jerryVoice': jerryVoice,
      'recoveryEnabled': recoveryEnabled,
      'holdEnabled': holdEnabled,
      'music': music,
      'chimes': chimes,
      'pineal': pineal,
      'choiceOfBreathHold': choiceOfBreathHold,
      'numberOfBreath': numberOfBreath,
      'holdDuration': holdDuration,
      'recoveryDuration': recoveryDuration,
      'breathingTimeList': breathingTimeList,
      'breathInholdTimeList': breathInholdTimeList,
      'breathOutholdTimeList': breathOutholdTimeList,
      'recoveryTimeList': recoveryTimeList,
    };
  }

  // Create from JSON
  factory DnaBreathworkModel.fromJson(Map<String, dynamic> json) {
    return DnaBreathworkModel(
      title: json['title'],
      numberOfSets: json['numberOfSets'],
      breathingApproach: json['breathingApproach'],
      durationOfEachSet: json['durationOfEachSet'],
      jerryVoice: json['jerryVoice'],
      recoveryEnabled: json['recoveryEnabled'],
      holdEnabled: json['holdEnabled'],
      music: json['music'],
      chimes: json['chimes'],
      pineal: json['pineal'],
      choiceOfBreathHold: json['choiceOfBreathHold'],
      numberOfBreath: json['numberOfBreath'],
      holdDuration: json['holdDuration'],
      recoveryDuration: json['recoveryDuration'],
      breathingTimeList: List<int>.from(json['breathingTimeList']),
      breathInholdTimeList: List<int>.from(json['breathInholdTimeList']),
      breathOutholdTimeList: List<int>.from(json['breathOutholdTimeList']),
      recoveryTimeList: List<int>.from(json['recoveryTimeList']),
    );
  }
}