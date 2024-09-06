import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:breathpacer/config/model/fire_breathwork_model.dart';
import 'package:breathpacer/utils/constant/jerry_voice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'firebreathing_state.dart';

class FirebreathingCubit extends Cubit<FirebreathingState> {
  FirebreathingCubit() : super(FirebreathingInitial());

  int noOfSets = 1;
  int currentSet = 0;
  int durationOfSets = 120;  //sec
  bool recoveryBreath = false;
  bool holdingPeriod = false;
  bool jerryVoice = false;
  bool music = false;
  bool chimes = false;
  bool pineal = false;
  String jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.breatheIn); //~ temporary
  String choiceOfBreathHold = 'Breath in';
  int breathHoldIndex = 0;
  List<String> breathHoldList = ['Breath in', 'Breath out'] ; 
  List<int> setsList = [1, 2, 3, 4, 5] ; 
  List<int> durationsList = [60, 120, 180, 240, 300, 360, 420, 480, 540, 600] ; //sec

  bool isReatartEnable = false;
  bool isSaveDialogOn = false;
  TextEditingController saveInputCont = TextEditingController();


  void updateSetsDuration(int sec){
    durationOfSets = sec ;
    emit(FirebreathingUpdateSetDuration());
  }

  void updateSetsNumber(int number){
    noOfSets = number ;
    emit(FirebreathingUpdateSetNumber());
  }

  void toggleRecoveryBreath(){
    recoveryBreath = !recoveryBreath ;
    emit(FirebreathingToggleRecoveryBreath());
  }

  void toggleHolding(){
    holdingPeriod = !holdingPeriod ;
    emit(FirebreathingToggleHolding());
  }

  void toggleJerryVoice(){
    jerryVoice = !jerryVoice ;
    emit(FirebreathingToggleJerryVoice());
  }

  void togglePineal(){
    pineal = !pineal ;
    emit(FirebreathingTogglePineal());
  }

  void toggleMusic(){
    music = !music ;
    emit(FirebreathingToggleMusic());
  }

  void toggleChimes(){
    chimes = !chimes ;
    emit(FirebreathingToggleChimes());
  }

  void toggleBreathHold(int index){
    choiceOfBreathHold =  breathHoldList[index];
    breathHoldIndex = index;
    emit(FirebreathingToggleBreathHoldChoice());
  }

  void changeJerryVoiceAudio(String audioFile){
    jerryVoiceAssetFile = audioFile;
    emit(FirebreathingToggleBreathHoldChoice());
  }


  List<int> breathingTimeList = []; //sec
  List<int> holdTimeList = []; //sec
  List<int> recoveryTimeList = []; //sec
  AudioPlayer musicPlayer = AudioPlayer();
  AudioPlayer chimePlayer = AudioPlayer();
  AudioPlayer jerryVoicePlayer = AudioPlayer();
  AudioPlayer breathHoldPlayer = AudioPlayer();
  AudioPlayer recoveryPlayer = AudioPlayer();
  AudioPlayer relaxPlayer = AudioPlayer();

  void resetSettings(){
    jerryVoice = false;
    pineal = false;
    music = false;
    chimes = false;

    currentSet = 0;
    breathingTimeList.clear();
    holdTimeList.clear();
    recoveryTimeList.clear();

    // Reset music player if active
    try {
      if (musicPlayer.state == PlayerState.playing) {
        musicPlayer.stop();
      }
      
      // Reset chime player if active
      if (chimePlayer.state == PlayerState.playing) {
        chimePlayer.stop();
      }
      
      // Reset Jerry Voice player if active
      if (jerryVoicePlayer.state == PlayerState.playing) {
        jerryVoicePlayer.stop();
      }
      
      // Reset breath hold player if active
      if (breathHoldPlayer.state == PlayerState.playing) {
        breathHoldPlayer.stop();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("resetSettings>> ${e.toString()}");
      }
    }
    
    emit(FirebreathingInitial());
  }

  void playRelax() async {
    try {
      if(jerryVoice){
        await relaxPlayer.play(AssetSource('audio/relax.mp3'), );
      
        //~ Listen for when completed
        relaxPlayer.onPlayerComplete.listen((event) {
          relaxPlayer.stop();
        });
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playRelax>> ${e.toString()}");
      }
    }
  }

  void setToogleSaveDialog(){
    isSaveDialogOn = !isSaveDialogOn;
    emit(FirebreathingToggleSave());
  }

  void onCloseDialogClick(){
    isSaveDialogOn = false;
    emit(FirebreathingToggleSave());
  }

  List<FireBreathworkModel> savedBreathwork = [];

  void onSaveClick() async{
    var box = await Hive.openBox('fireBreathworkBox');

    FireBreathworkModel breathwork = FireBreathworkModel(
      title: saveInputCont.text,
      holdPeriodEnabled: holdingPeriod,
      numberOfSets: noOfSets.toString(),
      durationOfEachSet: durationOfSets,
      recoveryEnabled: recoveryBreath,
      jerryVoice: jerryVoice,
      music: music,
      chimes: chimes,
      pineal: pineal,
      choiceOfBreathHold: breathHoldList[breathHoldIndex],
      breathingTimeList: breathingTimeList,
      holdTimeList: holdTimeList,
      recoveryTimeList: recoveryTimeList
    );

    await box.add(breathwork.toJson());
   
    savedBreathwork.add(breathwork);
    isSaveDialogOn = false;

    emit(FirebreathingToggleSave());
  }

  void getAllSavedPyramidBreathwork() async{
    var box = await Hive.openBox('fireBreathworkBox');

    savedBreathwork.clear();

    if(box.values.isEmpty){
      emit(FireBreathworkFetched());
      return ;
    }

    for (var item in box.values) {
      FireBreathworkModel breathworks = FireBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(FireBreathworkFetched());
    }
  }

  void deleteSavedPyramidBreathwork(int index) async{
    var box = await Hive.openBox('fireBreathworkBox');

    if(box.values.isEmpty){
      emit(FireBreathworkFetched());
      return ;
    }
    
    var key = box.keyAt(index);
    await box.delete(key);
    savedBreathwork.removeAt(index);

    emit(FireBreathworkFetched());
  }


}
