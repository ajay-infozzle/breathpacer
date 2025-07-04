import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:breathpacer/config/model/pyramid_breathwork_model.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer/utils/constant/jerry_voice.dart';
import 'package:breathpacer/utils/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// import 'package:meta/meta.dart';

part 'pyramid_state.dart';

class PyramidCubit extends Cubit<PyramidState> {
  PyramidCubit() : super(PyramidInitial());

  String? step ;
  String? speed ; //Standard, Fast, Slow
  bool jerryVoice = true;
  bool music = true;
  bool chimes = true;
  bool skipIntro = false;
  String jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.breatheIn);
  String choiceOfBreathHold = 'Breathe in';
  int breathHoldIndex = 0;
  List<String> breathHoldList = ['Breathe in', 'Breathe out', 'Both'] ; 
  int holdDuration = 20;
  List<int> holdDurationList = [10, 20, 30, 40, 50, 60, -1] ;

  
  int selectedMusic = 1; 
  String musicPath = "audio/music_1.mp3"; 

  bool isReatartEnable = false;
  bool isSaveDialogOn = false;
  TextEditingController saveInputCont = TextEditingController();

  void initialSettings(String stepp, String speedd){
    step = stepp;
    speed = speedd;
    jerryVoice = true;
    music = true;
    chimes = true;
    // isReatartEnable = true ;
    holdDuration = 20;
    saveInputCont.clear();
  
    emit(PyramidInitial());
  }

  void toggleJerryVoice(){
    jerryVoice = !jerryVoice ;
    emit(PyramidToggleJerryVoice());
  }

  void toggleMusic(){
    music = !music ;
    emit(PyramidToggleMusic());
  }

  void toggleSkipIntro(){
    skipIntro = !skipIntro;
    emit(PyramidToggleIntro());
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
    emit(PyramidToggleMusic());
  }

  void toggleChimes(){
    chimes = !chimes ;
    emit(PyramidToggleChimes());
  }
  void toggleBreathHold(int index){
    choiceOfBreathHold =  breathHoldList[index];
    breathHoldIndex = index;
    log("breathHoldIndex set-> $breathHoldIndex", name: "toggleBreathHold");
    emit(PyramidToggleBreathHold());
  }

  void updateHold(int number){
    holdDuration = number ;
     emit(PyramidToggleBreathHold());
  }

  void changeJerryVoiceAudio(String audioFile){
    jerryVoiceAssetFile = audioFile;
    emit(PyramidToggleBreathHold());
  }


  int currentRound = 0;
  List<int> breathingTimeList = []; //sec
  List<int> holdInbreathTimeList = []; //sec
  List<int> holdBreathoutTimeList = []; //sec
  AudioPlayer closeEyePlayer = AudioPlayer();
  AudioPlayer musicPlayer = AudioPlayer();
  AudioPlayer chimePlayer = AudioPlayer();
  AudioPlayer jerryVoicePlayer = AudioPlayer();
  AudioPlayer breathHoldPlayer = AudioPlayer();
  AudioPlayer relaxPlayer = AudioPlayer();
  AudioPlayer extraPlayer = AudioPlayer();


  void resetSettings(String stepp, String speedd){
    jerryVoice = true;
    music = true;
    chimes = true;
    isReatartEnable = false;

    currentRound = 0;
    holdDuration = 20;
    breathingTimeList.clear();
    holdBreathoutTimeList.clear();
    holdInbreathTimeList.clear();

    // Reset music player if active
    try {
      if (closeEyePlayer.state == PlayerState.playing ) {
        closeEyePlayer.stop();
      }

      if (musicPlayer.state == PlayerState.playing || musicPlayer.state == PlayerState.paused) {
        musicPlayer.stop();
        // musicPlayer.seek(Duration.zero);
      }
      
      // Reset chime player if active
      if (chimePlayer.state == PlayerState.playing) {
        chimePlayer.stop();
        // chimePlayer.seek(Duration.zero);
      }
      
      // Reset Jerry Voice player if active
      if (jerryVoicePlayer.state == PlayerState.playing || jerryVoicePlayer.state == PlayerState.paused) {
        jerryVoicePlayer.stop();
        // jerryVoicePlayer.seek(Duration.zero);
      }
      
      // Reset breath hold player if active
      if (breathHoldPlayer.state == PlayerState.playing || breathHoldPlayer.state == PlayerState.paused) {
        breathHoldPlayer.stop();
      }

      if (relaxPlayer.state == PlayerState.playing || relaxPlayer.state == PlayerState.paused) {
        relaxPlayer.stop();
      }

      if (extraPlayer.state == PlayerState.playing || extraPlayer.state == PlayerState.paused) {
        extraPlayer.stop();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("resetSettings>> ${e.toString()}");
      }
    }
    
    emit(PyramidInitial());
  }

  void setToogleSaveDialog(){
    isSaveDialogOn = !isSaveDialogOn;
    emit(PyramidToggleSave());
  }


  late int waitingTime ;
  void playCloseEyes() async {
    try {
      if(jerryVoice){
        if(skipIntro){
          await closeEyePlayer.play(AssetSource('audio/skip_intro.mp3'), );
        }
        else if(step == "4"){
          await closeEyePlayer.play(AssetSource('audio/four_step_start.mp3'), );
        }else if(step == "2"){
          await closeEyePlayer.play(AssetSource('audio/two_step_start.mp3'), );
        }
        
        Duration? duration = await closeEyePlayer.getDuration();
        waitingTime = duration!.inSeconds;
        emit(NavigateToWaitingScreen());
      }else{
        waitingTime = 5;
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

  void resetMusic() async {
    try {
      if(music){
        // musicPlayer.seek(Duration.zero);
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
        // await chimePlayer.seek(Duration.zero);
        await chimePlayer.stop();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("resetChime>> ${e.toString()}");
      }
    }
  }

  // void playJerry() async {
  //   try {
  //     if(jerryVoice){
  //       //~ for speed purpose
  //       jerryVoiceAssetFile = speed == "Standard" ? "audio/breath_standard.mp3" : (speed == "Fast" ? "audio/breath_fast.mp3" : "audio/breath_slow.mp3");
      
  //       await jerryVoicePlayer.play(AssetSource(jerryVoiceAssetFile));

  //       jerryVoicePlayer.onPlayerComplete.listen((event) {
  //         // jerryVoicePlayer.seek(Duration.zero);
  //         jerryVoicePlayer.play(AssetSource(jerryVoiceAssetFile));
  //       });
  //     }
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print("playJerry>> ${e.toString()}");
  //     }
  //   }
  // }

  playBreathing(String voice) async{
    // jerryVoiceAssetFile = speed == "Standard" ? "audio/breath_standard.mp3" : (speed == "Fast" ? "audio/breath_fast.mp3" : "audio/breath_slow.mp3");
    try {
      if(jerryVoice){
        //~ check motivation is playing or not
        if(breathHoldPlayer.state != PlayerState.playing){
          await jerryVoicePlayer.stop();
          await jerryVoicePlayer.play(AssetSource(voice));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("playJerryBreathing>> ${e.toString()}");
      }
    }
  }

  void controlVolume({double volume = 1}) async{
    try {
      if(jerryVoice){
        await jerryVoicePlayer.setVolume(volume);
      }
    } catch (e) {
      if (kDebugMode) {
        print("controlVolume>> ${e.toString()}");
      }
    }
  }

  void extraPlay(String voice) async{
    try {
      if(jerryVoice){
        if(extraPlayer.state != PlayerState.playing){
          await extraPlayer.stop();
          await extraPlayer.play(AssetSource(voice));


          extraPlayer.onPlayerComplete.listen((event) async{
            controlVolume(volume: 1);
            if(speed == 'Slow'){
              await Future.delayed(const Duration(milliseconds: 850), () {
                playTimeToHold(isForBreathOut: true);
              },);
            }else{
              playTimeToHold(isForBreathOut: true);
            }
          },);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("extraPlay>> ${e.toString()}");
      }
    }
  }

  void stopJerry() async {
    try {
      if(jerryVoice){
      await jerryVoicePlayer.stop();
      // await jerryVoicePlayer.seek(Duration.zero);
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
        // //~ for speed purpose
        // jerryVoiceAssetFile = speed == "Standard" ? "audio/breath_standard.mp3" : (speed == "Fast" ? "audio/breath_fast.mp3" : "audio/breath_slow.mp3");
      
        // // jerryVoicePlayer.seek(Duration.zero);
        // jerryVoicePlayer.stop();
        // await jerryVoicePlayer.play(AssetSource(jerryVoiceAssetFile));
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

  void playHoldCountdown({bool isBoth = false, required bool isLastRound}) async {
    try {
      if(jerryVoice){
        breathHoldPlayer.stop();
        if(holdDuration == 10){
          // await breathHoldPlayer.play(AssetSource('audio/single_3_2_1.mp3'));
          if(breathHoldIndex == 0){
            isBoth 
            ? await breathHoldPlayer.play(AssetSource('audio/countdown_for_breathe_out_and_hold.mp3'))
            : isLastRound 
              ? await breathHoldPlayer.play(AssetSource('audio/ready_to_breath_out_countdown_at_end.mp3')) 
              : await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_out_countdown.mp3'));
          }else{
            isLastRound 
              ? await breathHoldPlayer.play(AssetSource('audio/ready_to_breath_in_countdown_at_end.mp3'))
              : await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_in_countdown.mp3'));
          }
        }else{
          // await breathHoldPlayer.play(AssetSource('audio/3_2_1.mp3'));
          if(breathHoldIndex == 0){
            isBoth 
            ? await breathHoldPlayer.play(AssetSource('audio/countdown_for_breathe_out_and_hold.mp3'))
            : isLastRound 
              ? await breathHoldPlayer.play(AssetSource('audio/ready_to_breath_out_countdown_at_end.mp3')) 
              : await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_out_countdown.mp3'));
          }else{
            isLastRound 
              ? await breathHoldPlayer.play(AssetSource('audio/ready_to_breath_in_countdown_at_end.mp3'))
              : await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_in_countdown.mp3'));
          }
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playHoldCountdown>> ${e.toString()}");
      }
    }
  }

  void playTimeToHold({bool isForBreathOut = false}) async {
    try {
      if(jerryVoice){
        breathHoldPlayer.stop();
        // await breathHoldPlayer.play(AssetSource('audio/time_to_hold.mp3'));
        isForBreathOut 
        ? await breathHoldPlayer.play(AssetSource('audio/now_hold.mp3'))
        : await breathHoldPlayer.play(AssetSource('audio/breathe_in_and_hold.mp3'));
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

  void playTimeToHoldOutBreath() async {
    try {
      if(jerryVoice){
        breathHoldPlayer.stop();
        await breathHoldPlayer.play(AssetSource('audio/now_hold.mp3'));
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
        await breathHoldPlayer.play(AssetSource('audio/motivation_2.mp3'));
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playHoldMotivation>> ${e.toString()}");
      }
    }
  }

  void stopHold() async {
    try {
      if(jerryVoice){
      await breathHoldPlayer.stop();
    }
    } catch (e) {
      if (kDebugMode) {
        print("stopHold>> ${e.toString()}");
      }
    }
  }

  void playRelax() async {
    try {
      if(jerryVoice){
        await relaxPlayer.play(AssetSource('audio/relax.mp3'), );
      
        //~ Listen for when completed
        relaxPlayer.onPlayerComplete.listen((event) {
          // relaxPlayer.seek(Duration.zero);
          relaxPlayer.stop();
        });
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playRelax>> ${e.toString()}");
      }
    }
  }

  void onCloseDialogClick(){
    isSaveDialogOn = false;
    emit(PyramidToggleSave());
  }

  List<PyramidBreathworkModel> savedBreathwork = [];

  void onSaveClick() async{
    if(saveInputCont.text.isEmpty){
      emit(PyramidToggleSave());
      return ;
    }


    var box = await Hive.openBox('pyramidBreathworkBox');

    PyramidBreathworkModel breathwork = PyramidBreathworkModel(
      title: saveInputCont.text,
      speed: speed,
      step: step,
      jerryVoice: jerryVoice,
      music: music,
      chimes: chimes,
      choiceOfBreathHold: choiceOfBreathHold,
      holdDuration: holdDuration,
      breathingTimeList: breathingTimeList,
      holdBreathInTimeList: holdInbreathTimeList,
      holdBreathOutTimeList: holdBreathoutTimeList
    );

    await box.add(breathwork.toJson());
   
    savedBreathwork.add(breathwork);
    isSaveDialogOn = false;
    saveInputCont.clear();

    updateSavedPyramidBreathwork();
    
    showToast("Saved Successfuly");
    emit(PyramidToggleSave());
  }

  void getAllSavedPyramidBreathwork() async{
    var box = await Hive.openBox('pyramidBreathworkBox');

    if(box.values.isEmpty || savedBreathwork.isNotEmpty){
      emit(PyramidBreathworkFetched());
      return ;
    }
    
    savedBreathwork.clear();
    for (var item in box.values) {
      PyramidBreathworkModel breathworks = PyramidBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(PyramidBreathworkFetched());
    }
  }

  void updateSavedPyramidBreathwork() async{
    var box = await Hive.openBox('pyramidBreathworkBox');

    if(box.values.isEmpty){
      emit(PyramidBreathworkFetched());
      return ;
    }
    
    savedBreathwork.clear();
    for (var item in box.values) {
      PyramidBreathworkModel breathworks = PyramidBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(PyramidBreathworkFetched());
    }
  }

 
  void deleteSavedPyramidBreathwork(int index) async{
    var box = await Hive.openBox('pyramidBreathworkBox');

    if(box.values.isEmpty){
      emit(PyramidBreathworkFetched());
      return ;
    }
    
    var key = box.keyAt(index);
    await box.delete(key);
    savedBreathwork.removeAt(index);

    emit(PyramidBreathworkFetched());
  }

}
