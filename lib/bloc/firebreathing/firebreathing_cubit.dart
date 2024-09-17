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
  int durationOfSets = 30;  //sec
  bool recoveryBreath = false;
  int recoveryBreathDuration = 10;
  bool holdingPeriod = false;
  int holdDuration = 10;
  bool jerryVoice = false;
  bool music = false;
  bool chimes = false;
  bool pineal = false;
  String jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.fireBreathing); //~ temporary
  String choiceOfBreathHold = 'Breath in';
  int breathHoldIndex = 0;
  List<String> breathHoldList = ['Breath in', 'Breath out'] ; 
  List<int> setsList = [1, 2, 3, 4, 5] ; 
  List<int> durationsList = [30, 60, 120, 180, 240, 300, 360, 420, 480, 540, 600] ; //sec
  List<int> recoveryDurationList = [10,20, 30, 40, 60, 120, 180] ;
  List<int> holdDurationList = [10, 20, 30, 40, 50, 60] ;

  bool isReatartEnable = false;
  bool isSaveDialogOn = false;
  TextEditingController saveInputCont = TextEditingController();


  void initialSettings(String stepp, String speedd){
    noOfSets = 1;
    currentSet = 0;
    durationOfSets = 30;
    jerryVoice = false;
    music = false;
    chimes = false;
    pineal = false;
    recoveryBreath = false;
    recoveryBreathDuration = 10;
    holdingPeriod = false;
    holdDuration = 10;
    isReatartEnable = true ;
    jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.breatheIn);
    breathHoldIndex = 0;
    isSaveDialogOn = false;
    saveInputCont.clear();
  
    emit(FirebreathingInitial());
  }

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

  void updateRecoveryDuration(int number){
    recoveryBreathDuration = number ;
    emit(FirebreathingToggleRecoveryBreath());
  }

  void toggleHolding(){
    holdingPeriod = !holdingPeriod ;
    emit(FirebreathingToggleHolding());
  }

  void updateHold(int number){
    holdDuration = number ;
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
  AudioPlayer closeEyePlayer = AudioPlayer();
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


  void playCloseEyes() async {
    try {
      if(jerryVoice){
        await closeEyePlayer.play(AssetSource('audio/close_eyes.mp3'), );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("closeEyesMusic>> ${e.toString()}");
      }
    }
  }

  void stopCloseEyes() async {
    if(jerryVoice){
      await closeEyePlayer.stop();
    }
  }

  void playMusic() async {
    try {
      if(music){
        await musicPlayer.play(AssetSource('audio/music.mp3'), );
      
        //~ Listen for when the music is completed
        musicPlayer.onPlayerComplete.listen((event) {
          musicPlayer.play(AssetSource('audio/music.mp3'));
        });
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playMusic>> ${e.toString()}");
      }
    }
  }

  void stopMusic() async {
    if(music){
      await musicPlayer.stop();
    }
  }

  void resetMusic() async {
    try {
      if(music){
        musicPlayer.stop();
      }
    } on Exception catch (e) {
     if (kDebugMode) {
        print("resetMusic>> ${e.toString()}");
      }
    }
  }

  void playChime() async {
    try {
      if(chimes){
        await chimePlayer.play(AssetSource('audio/bell.mp3'));
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playChime>> ${e.toString()}");
      }
    }
  }

  void resetChime() async {
    try {
      if(chimes){
        await chimePlayer.stop();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("resetChime>> ${e.toString()}");
      }
    }
  }

  void playJerry() async {
    try {
      if(jerryVoice){
        //~ for pineal purpose if selected
        jerryVoiceAssetFile = pineal ? jerryVoiceOver(JerryVoiceEnum.pineal) : jerryVoiceOver(JerryVoiceEnum.fireBreathing) ;
      
        await jerryVoicePlayer.play(AssetSource(jerryVoiceAssetFile));

        jerryVoicePlayer.onPlayerComplete.listen((event) {
          jerryVoicePlayer.play(AssetSource(jerryVoiceAssetFile));
        });
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playJerry>> ${e.toString()}");
      }
    }
  }

  void stopJerry() async {
    try {
      if(jerryVoice){
        await jerryVoicePlayer.stop();
      }
    } catch (e) {
      if (kDebugMode) {
        print("stopJerry>> ${e.toString()}");
      }
    }
  }

  void resetJerryVoiceAndPLayAgain() async {
    try {
      if(jerryVoice){
        //~ for pineal purpose if enable
        jerryVoiceAssetFile = pineal ? jerryVoiceOver(JerryVoiceEnum.pineal) : jerryVoiceOver(JerryVoiceEnum.fireBreathing)  ;
  
        jerryVoicePlayer.stop();
        await jerryVoicePlayer.play(AssetSource(jerryVoiceAssetFile));
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("resetJerryVoiceAndPLayAgain>> ${e.toString()}");
      }
    }
  }

  void updateJerryAudio(String jerryVoice) async {
    jerryVoiceAssetFile = jerryVoice ;
  }

  void playHold() async {
    try {
      if(jerryVoice){
        if(breathHoldIndex == 0){
          await breathHoldPlayer.play(AssetSource('audio/hold_in_breath.mp3'));
        }
        if(breathHoldIndex == 1){
          await breathHoldPlayer.play(AssetSource('audio/hold_out_breath.mp3'));
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playHold>> ${e.toString()}");
      }
    }
  }

  void stopHold() async {
    try {
      if(jerryVoice){
        await breathHoldPlayer.stop();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("stopHold>> ${e.toString()}");
      }
    }
  }
  

  void playRecovery() async {
    try {
      if(jerryVoice){
        await recoveryPlayer.play(AssetSource('audio/recover.mp3'));
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playRecovery>> ${e.toString()}");
      }
    }
  }

  void stopRecovery() async {
    try {
      if(jerryVoice){
        await recoveryPlayer.stop();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("stopRecovery>> ${e.toString()}");
      }
    }
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
