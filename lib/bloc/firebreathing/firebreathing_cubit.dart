import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:breathpacer/config/model/fire_breathwork_model.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer/utils/constant/jerry_voice.dart';
import 'package:breathpacer/utils/toast.dart';
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
  int holdDuration = 20;
  bool jerryVoice = true;
  bool music = true;
  bool chimes = true;
  bool pineal = false;
  bool skipIntro = false;
  String jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.fireBreathing); //~ temporary
  String choiceOfBreathHold = 'Breath in';
  int breathHoldIndex = 0;
  List<String> breathHoldList = ['Breath in', 'Breath out'] ; 
  List<int> setsList = [1, 2, 3, 4, 5] ; 
  List<int> durationsList = [30, 60, 120, 180, 240, 300, 360, 420, 480, 540, 600] ; //sec
  List<int> recoveryDurationList = [10,20, 30, 40, 60, 120, 180] ;
  List<int> holdDurationList = [10, 20, 30, 40, 50, 60] ;

  int selectedMusic = 1; 
  String musicPath = "audio/music_1.mp3";

  bool isReatartEnable = false;
  bool isSaveDialogOn = false;
  TextEditingController saveInputCont = TextEditingController();


  void initialSettings(String stepp, String speedd){
    noOfSets = 1;
    currentSet = 0;
    durationOfSets = 30;
    jerryVoice = false;
    music = true;
    chimes = true;
    pineal = false;
    recoveryBreath = false;
    recoveryBreathDuration = 10;
    holdingPeriod = false;
    holdDuration = 20;
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

  void toggleSkipIntro(){
    skipIntro = !skipIntro ;
    emit(FirebreathingToggleSkipIntro());
  }

  void updateMusic(String selected){
    selectedMusic = musicList.indexOf(selected);
    switch (selectedMusic) {
      case 0:
        music = false;
        break;
      case 1:
        music = true;
        musicPath = "audio/music_1.mp3";
        break;
      case 2:
        music = true;
        musicPath = "audio/music_2.mp3";
        break;
      default: 
        music = true;
        musicPath = "audio/music_1.mp3";
    }
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
    jerryVoice = true;
    pineal = false;
    music = true;
    chimes = true;
    isReatartEnable = false;
    recoveryBreath = false;
    holdingPeriod = false;

    currentSet = 0;
    breathingTimeList.clear();
    holdTimeList.clear();
    recoveryTimeList.clear();

    // Reset music player if active
    try {
      if (closeEyePlayer.state == PlayerState.playing ) {
        closeEyePlayer.stop();
      }
      
      if (musicPlayer.state == PlayerState.playing || musicPlayer.state == PlayerState.paused) {
        musicPlayer.stop();
      }
      
      // Reset chime player if active
      if (chimePlayer.state == PlayerState.playing) {
        chimePlayer.stop();
      }
      
      // Reset Jerry Voice player if active
      if (jerryVoicePlayer.state == PlayerState.playing || jerryVoicePlayer.state == PlayerState.paused) {
        jerryVoicePlayer.stop();
      }
      
      // Reset breath hold player if active
      if (breathHoldPlayer.state == PlayerState.playing || breathHoldPlayer.state == PlayerState.paused) {
        breathHoldPlayer.stop();
      }

      if (recoveryPlayer.state == PlayerState.playing || recoveryPlayer.state == PlayerState.paused) {
        recoveryPlayer.stop();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("resetSettings>> ${e.toString()}");
      }
    }
    
    emit(FirebreathingInitial());
  }


  void pauseAudio(AudioPlayer sound, bool check) async {
    if(check){
      if(sound.state == PlayerState.playing){
        sound.pause();
      }
    }
  }

  void resumeAudio(AudioPlayer sound, bool check) async {
    if(check){
      if(sound.state == PlayerState.paused){
        sound.resume();
      }
    }
  }


  late int waitingTime ;
  void playCloseEyes() async {
    try {
      if(jerryVoice){
        if(skipIntro){
          await closeEyePlayer.play(AssetSource('audio/skip_intro.mp3'), );
        }
        else if(pineal){
          await closeEyePlayer.play(AssetSource('audio/firebreathing_pineal_start.mp3'), );
        }
        else{
          await closeEyePlayer.play(AssetSource('audio/firebreathing_start.mp3'), );
        }
        Duration? duration = await closeEyePlayer.getDuration();
        waitingTime = duration!.inSeconds;
        emit(NavigateToWaitingScreen());
      }
      else{
        waitingTime = 10;
        emit(NavigateToWaitingScreen());
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
        switch (selectedMusic) {
          case 0:
            break;
          case 1:
            await musicPlayer.play(AssetSource(musicPath), );
            break;
          case 2:
            await musicPlayer.play(AssetSource(musicPath), );
            break;
          default: 
            await musicPlayer.play(AssetSource(musicPath), );
        }

        // await musicPlayer.play(AssetSource('audio/music.mp3'), );
      
        //~ Listen for when the music is completed
        musicPlayer.onPlayerComplete.listen((event) {
          // Restart the music once it's completed
          // musicPlayer.seek(Duration.zero);
          musicPlayer.play(AssetSource(musicPath));
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
        // jerryVoiceAssetFile = pineal ? jerryVoiceOver(JerryVoiceEnum.pineal) : jerryVoiceOver(JerryVoiceEnum.fireBreathing) ;

        jerryVoiceAssetFile = pineal ? 'audio/firebreathing_pineal.mp3' : 'audio/firebreathing.mp3' ;
        // jerryVoiceAssetFile = 'audio/firebreathing_sound.mp3' ;
      
        await jerryVoicePlayer.play(AssetSource(jerryVoiceAssetFile));

        // jerryVoicePlayer.onPlayerComplete.listen((event) {
        //   jerryVoicePlayer.play(AssetSource(jerryVoiceAssetFile));
        // });
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

  void playTimeToNextSet() async {
    try {
      if(jerryVoice){
        jerryVoicePlayer.stop();
        await jerryVoicePlayer.play(AssetSource('audio/time_to_next_set.mp3'));
      }
      else{
        playChime();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playTimeToNextSet>> ${e.toString()}");
      }
    }
  }

  void resetJerryVoiceAndPLayAgain() async {
    try {
      if(jerryVoice){
        //~ for pineal purpose if enable
        // jerryVoiceAssetFile = pineal ? jerryVoiceOver(JerryVoiceEnum.pineal) : jerryVoiceOver(JerryVoiceEnum.fireBreathing)  ;
        jerryVoiceAssetFile = pineal ? 'audio/firebreathing_pineal.mp3' : 'audio/firebreathing.mp3' ;
  
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


  void playHoldCountdown({required bool isLastRound}) async {
    try {
      if(jerryVoice){
        breathHoldPlayer.stop();
        if(breathHoldIndex == 0){
          if(isLastRound && recoveryBreath == false){
            await breathHoldPlayer.play(AssetSource('audio/ready_to_breath_out_countdown_at_end.mp3'));
            return ;
          }

          recoveryBreath 
          ?await breathHoldPlayer.play(AssetSource('audio/breathing_out_recovery_countdown.mp3'))
          :await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_out_countdown.mp3'));
        }else{
          if(isLastRound && recoveryBreath == false){
            await breathHoldPlayer.play(AssetSource('audio/ready_to_breath_in_countdown_at_end.mp3'));
            return ;
          }

          recoveryBreath 
          ?await breathHoldPlayer.play(AssetSource('audio/breathing_in_recovery_countdown.mp3'))
          :await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_in_countdown.mp3'));
        }
        // if(holdDuration == 10){
        //   // await breathHoldPlayer.play(AssetSource('audio/single_3_2_1.mp3'));
          
        //   if(breathHoldIndex == 0){
        //     recoveryBreath 
        //     ?await breathHoldPlayer.play(AssetSource('audio/breathing_out_recovery_countdown.mp3'))
        //     :await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_out_countdown.mp3'));
        //   }else{
        //     recoveryBreath 
        //     ?await breathHoldPlayer.play(AssetSource('audio/breathing_in_recovery_countdown.mp3'))
        //     :await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_in_countdown.mp3'));
        //   }
        // }else{
        //   // await breathHoldPlayer.play(AssetSource('audio/3_2_1.mp3'));
          
        //   if(breathHoldIndex == 0){
        //     recoveryBreath 
        //     ?await breathHoldPlayer.play(AssetSource('audio/breathing_out_recovery_countdown.mp3'))
        //     :await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_out_countdown.mp3'));
        //   }else{
        //     recoveryBreath 
        //     ?await breathHoldPlayer.play(AssetSource('audio/breathing_in_recovery_countdown.mp3'))
        //     :await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_in_countdown.mp3'));
        //   }
        // }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playHoldCountdown>> ${e.toString()}");
      }
    }
  }

  void playTimeToHold() async {
    try {
      if(jerryVoice){
        breathHoldPlayer.stop();
        
        if(holdingPeriod){
          breathHoldIndex  == 0 
          ? await breathHoldPlayer.play(AssetSource('audio/countdown_for_breathe_in_and_hold.mp3'))
          : await breathHoldPlayer.play(AssetSource('audio/countdown_for_breathe_out_and_hold.mp3'));
        }else if(recoveryBreath){
         await breathHoldPlayer.play(AssetSource('audio/breathing_in_recovery_countdown.mp3'));
        }
      }
      else{
        playChime();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playTimeToHold>> ${e.toString()}");
      }
    }
  }

  void playHoldMotivation() async {
    try {
      if(jerryVoice){
        if(jerryVoicePlayer.state != PlayerState.playing) jerryVoicePlayer.stop();

        breathHoldPlayer.stop();
        await breathHoldPlayer.play(AssetSource('audio/motivation.mp3'));
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playHoldMotivation>> ${e.toString()}");
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

  void playTimeToRecover() async {
    try {
      if(jerryVoice){
        recoveryPlayer.stop();
        // await recoveryPlayer.play(AssetSource('audio/time_to_recover.mp3'));
        await recoveryPlayer.play(AssetSource('audio/recover_short.mp3'));
      }
      else{
        playChime();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playTimeToRecover>> ${e.toString()}");
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
    if(saveInputCont.text.isEmpty){
      emit(FirebreathingToggleSave());
      return ;
    }


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
      choiceOfBreathHold: choiceOfBreathHold,
      holdDuration: holdDuration,
      recoveryDuration: recoveryBreathDuration,
      breathingTimeList: breathingTimeList,
      holdTimeList: holdTimeList,
      recoveryTimeList: recoveryTimeList
    );

    await box.add(breathwork.toJson());
   
    savedBreathwork.add(breathwork);
    isSaveDialogOn = false;
    saveInputCont.clear();

    updateSavedFireBreathwork();
    
    showToast("Saved Successfuly");
    emit(FirebreathingToggleSave());
  }

  void getAllSavedFireBreathwork() async{
    var box = await Hive.openBox('fireBreathworkBox');

    if(box.values.isEmpty || savedBreathwork.isNotEmpty){
      emit(FireBreathworkFetched());
      return ;
    }

    savedBreathwork.clear();
    for (var item in box.values) {
      FireBreathworkModel breathworks = FireBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(FireBreathworkFetched());
    }
  }

  void updateSavedFireBreathwork() async{
    var box = await Hive.openBox('fireBreathworkBox');

    if(box.values.isEmpty){
      emit(FireBreathworkFetched());
      return ;
    }

    savedBreathwork.clear();
    for (var item in box.values) {
      FireBreathworkModel breathworks = FireBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(FireBreathworkFetched());
    }
  }

  void deleteSavedFireBreathwork(int index) async{
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
