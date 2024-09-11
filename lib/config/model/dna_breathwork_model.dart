class DnaBreathworkModel {
  
  String? title;
  String? numberOfSets; 
  String? breathingApproach; 
  int? durationOfEachSet; 
  bool? jerryVoice;
  bool? recoveryEnabled;
  bool? music;
  bool? chimes;
  bool? pineal;
  String? choiceOfBreathHold;
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
    required this.music,
    required this.chimes,
    required this.pineal,
    required this.choiceOfBreathHold,
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
      'music': music,
      'chimes': chimes,
      'pineal': pineal,
      'choiceOfBreathHold': choiceOfBreathHold,
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
      music: json['music'],
      chimes: json['chimes'],
      pineal: json['pineal'],
      choiceOfBreathHold: json['choiceOfBreathHold'],
      breathingTimeList: List<int>.from(json['breathingTimeList']),
      breathInholdTimeList: List<int>.from(json['breathInholdTimeList']),
      breathOutholdTimeList: List<int>.from(json['breathOutholdTimeList']),
      recoveryTimeList: List<int>.from(json['recoveryTimeList']),
    );
  }
}