import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:breathpacer/config/model/dna_breathwork_model.dart';
import 'package:breathpacer/utils/constant/jerry_voice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'dna_state.dart';

class DnaCubit extends Cubit<DnaState> {
  DnaCubit() : super(DnaInitial());

  String speed = "Standard"; //Standard, Fast, Slow
  int noOfSets = 1;
  int currentSet = 0;

  bool isTimeBreathingApproch = false;
  int noOfBreath = 10;
  int durationOfSet = 120;
  int recoveryBreathDuration = 60;
  int holdDuration = 60;
  bool recoveryBreath = false;
  // bool holdingPeriod = false;
  bool jerryVoice = false;
  bool music = false;
  bool chimes = false;
  bool pineal = false;
  String jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.breatheIn); //~ temporary
  String choiceOfBreathHold = 'Breath in';
  int breathHoldIndex = 0;
  String breathingApproachGroupValue = 'No. of Breaths' ; //No. of Breaths,Time per set
  List<String> breathHoldList = ['Breath in', 'Breath out', 'Both'] ; 
  List<int> breathList = [10, 15, 20, 25, 30] ; 
  List<int> setsList = [1, 2, 3, 4, 5] ; 
  List<int> durationsList = [60, 120, 180, 240, 300, 360, 420, 480, 540, 600] ;
  List<int> holdDurationList = [60, 120, 180, 240, 300, 360, 420, 480, 540, 600, -1] ;
  List<int> recoveryDurationList = [60, 120, 180, 240, 300, 360, 420, 480, 540, 600] ;

  bool isReatartEnable = false;
  bool isSaveDialogOn = false;
  TextEditingController saveInputCont = TextEditingController();


  void initialSettings(){
    noOfSets = 1;
    currentSet = 0;
    breathHoldIndex = 0;
    durationOfSet = 120;
    jerryVoice = false;
    music = false;
    chimes = false;
    pineal = false;
    recoveryBreath = false;
    isReatartEnable = true ;
    jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.breatheIn);
    breathHoldIndex = 0;
    isSaveDialogOn = false;
    saveInputCont.clear();
  
    emit(DnaInitial());
  }


  void updateSetsNumber(int number){
    noOfSets = number ;
    emit(DnaUpdateSetNumber());
  }


  void updateHold(int number){
    holdDuration = number ;
    emit(DnaHoldDurationUpdate());
  }

  void updateRecoveryDuration(int number){
    recoveryBreathDuration = number ;
    emit(DnaRecoveryDurationUpdate());
  }

  void updateBreathingApproach(String value){
    breathingApproachGroupValue = value ;
    emit(DnaUpdateBreathingApproach());
  }

  void updateBreathNumber(int number){
    noOfBreath = number ;
    emit(DnaUpdateBreathNumber());
  }

  void updateBreathTime(int number){
    durationOfSet = number ;
    emit(DnaUpdateBreathTime());
  }

  void toggleRecoveryBreath(){
    recoveryBreath = !recoveryBreath ;
    emit(DnaToggleRecoveryBreath());
  }

  // void toggleHolding(){
  //   holdingPeriod = !holdingPeriod ;
  //   emit(DnaToggleHolding());
  // }

  void toggleJerryVoice(){
    jerryVoice = !jerryVoice ;
    emit(DnaToggleJerryVoice());
  }

  void togglePineal(){
    pineal = !pineal ;
    emit(DnaTogglePineal());
  }

  void toggleMusic(){
    music = !music ;
    emit(DnaToggleMusic());
  }

  void toggleChimes(){
    chimes = !chimes ;
    emit(DnaToggleChimes());
  }

  void toggleBreathHold(int index){
    choiceOfBreathHold =  breathHoldList[index];
    breathHoldIndex = index;
    emit(DnaToggleBreathHoldChoice());
  }

  void changeJerryVoiceAudio(String audioFile){
    jerryVoiceAssetFile = audioFile;
    emit(DnaToggleBreathHoldChoice());
  }


  List<int> breathingTimeList = []; //sec
  List<int> holdInbreathTimeList = []; //sec
  List<int> holdBreathoutTimeList = []; //sec
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
    durationOfSet = 120;

    currentSet = 0;
    breathHoldIndex = 0;
    breathingTimeList.clear();
    holdInbreathTimeList.clear();
    holdBreathoutTimeList.clear();
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
        print("Dna resetSettings>> ${e.toString()}");
      }
    }
    
    emit(DnaInitial());
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
        jerryVoiceAssetFile = pineal ? jerryVoiceOver(JerryVoiceEnum.breatheIn) : jerryVoiceOver(JerryVoiceEnum.breatheIn) ;
      
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
        jerryVoiceAssetFile = pineal ? jerryVoiceOver(JerryVoiceEnum.breatheIn) : jerryVoiceOver(JerryVoiceEnum.breatheIn) ;
  
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
        // if(breathHoldIndex == 0){
        //   await breathHoldPlayer.play(AssetSource('audio/hold_in_breath.mp3'));
        // }
        // if(breathHoldIndex == 1){
        //   await breathHoldPlayer.play(AssetSource('audio/hold_out_breath.mp3'));
        // }
        //todo: have to add recover sound
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
      //todo: have to add recover sound
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
    emit(DnaToggleSave());
  }

  void onCloseDialogClick(){
    isSaveDialogOn = false;
    emit(DnaToggleSave());
  }

  List<DnaBreathworkModel> savedBreathwork = [];

  void onSaveClick() async{
    var box = await Hive.openBox('DnaBreathworkBox');

    DnaBreathworkModel breathwork = DnaBreathworkModel(
      title: saveInputCont.text,
      numberOfSets: noOfSets.toString(),
      breathingApproach: breathingApproachGroupValue,
      durationOfEachSet: durationOfSet,
      recoveryEnabled: recoveryBreath,
      jerryVoice: jerryVoice,
      music: music,
      chimes: chimes,
      pineal: pineal,
      choiceOfBreathHold: breathHoldList[breathHoldIndex],
      breathingTimeList: breathingTimeList,
      breathInholdTimeList: holdInbreathTimeList,
      breathOutholdTimeList: holdBreathoutTimeList,
      recoveryTimeList: recoveryTimeList
    );

    await box.add(breathwork.toJson());
   
    savedBreathwork.add(breathwork);
    isSaveDialogOn = false;
    saveInputCont.clear();

    emit(DnaToggleSave());
  }

  void getAllSavedPyramidBreathwork() async{
    var box = await Hive.openBox('dnaBreathworkBox');

    savedBreathwork.clear();

    if(box.values.isEmpty){
      emit(DnaBreathworkFetched());
      return ;
    }

    for (var item in box.values) {
      DnaBreathworkModel breathworks = DnaBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(DnaBreathworkFetched());
    }
  }

  void deleteSavedPyramidBreathwork(int index) async{
    var box = await Hive.openBox('dnaBreathworkBox');

    if(box.values.isEmpty){
      emit(DnaBreathworkFetched());
      return ;
    }
    
    var key = box.keyAt(index);
    await box.delete(key);
    savedBreathwork.removeAt(index);

    emit(DnaBreathworkFetched());
  }

}
