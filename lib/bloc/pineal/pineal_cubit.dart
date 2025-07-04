import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:breathpacer/config/model/pineal_breathwork_model.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer/utils/constant/jerry_voice.dart';
import 'package:breathpacer/utils/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'pineal_state.dart';

class PinealCubit extends Cubit<PinealState> {
  PinealCubit() : super(PinealInitial());

  int noOfSets = 1;
  int currentSet = 0;
  int durationOfSet = 120;
  bool recoveryBreath = false;
  bool jerryVoice = true;
  bool music = true;
  bool chimes = true;
  bool skipIntro = false;
  int recoveryBreathDuration = 20;
  String jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.pinealSqeez);
  int holdDuration = 20;
  int breathingPeriod = 300;
  List<int> breathingDurationList = [30, 60, 120, 180, 240, 300, 360, 420, 480, 540, 600] ;
  List<int> holdDurationList = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 75, 90, 120, -1] ;
  List<int> recoveryDurationList = [10, 20, 30, 60, 120] ;

  int selectedMusic = 1; 
  String musicPath = "audio/music_1.mp3";
  
  int remainingBreathTime = 0;
  bool isReatartEnable = false;
  bool isSaveDialogOn = false;
  bool isFirstSet = true;
  TextEditingController saveInputCont = TextEditingController();


  void calculateRemainingBreathTime(int time){
    if((remainingBreathTime - time) < 0){
      remainingBreathTime = 0;
    }
    else{
      remainingBreathTime = remainingBreathTime - time ;
    }
    emit(PinealInitial());
  }

  void updateRemainingBreathTime(int time){
    remainingBreathTime = time ;
    emit(PinealInitial());
  }

  void updateBreathing(int number){
    breathingPeriod = number ;
    emit(PinealBreathingUpdate());
  }

  void updateHold(int number){
    holdDuration = number ;
    emit(PinealHoldUpdate());
  }

  void updateRecovery(int number){
    recoveryBreathDuration = number ;
    emit(PinealRecoveryUpdate());
  }

  void toggleJerryVoice(){
    jerryVoice = !jerryVoice ;
    emit(PinealToggleJerryVoice());
  }

  void toggleMusic(){
    music = !music ;
    emit(PinealToggleMusic());
  }

  void toggleSkipIntro(){
    skipIntro = !skipIntro ;
    emit(PinealToggleSkipIntro());
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
    emit(PinealToggleMusic());
  }

  void toggleChimes(){
    chimes = !chimes ;
    emit(PinealToggleChimes());
  }

  bool checkBreathingPeriod(){
    if(breathingPeriod % holdDuration == 0){
      return true;
    }
    else{
      return false;
    }
  }

  // ..
  List<int> breathingTimeList = []; //sec
  List<int> recoveryTimeList = []; //sec
  AudioPlayer closeEyePlayer = AudioPlayer();
  AudioPlayer musicPlayer = AudioPlayer();
  AudioPlayer chimePlayer = AudioPlayer();
  AudioPlayer jerryVoicePlayer = AudioPlayer();
  AudioPlayer breathHoldPlayer = AudioPlayer();
  AudioPlayer recoveryPlayer = AudioPlayer();
  AudioPlayer relaxPlayer = AudioPlayer();
  AudioPlayer motivationPlayer = AudioPlayer();


  void resetSettings(){
    jerryVoice = true;
    music = true;
    chimes = true;
    isFirstSet = true;
    durationOfSet = 120;
    isReatartEnable = false;
    holdDuration = 20;
    breathingPeriod = 300;
    noOfSets = 1;
    skipIntro = false;
    recoveryBreathDuration = 20;

    currentSet = 0;
    remainingBreathTime = 0;
    breathingTimeList.clear();
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
      
      if (motivationPlayer.state == PlayerState.playing || motivationPlayer.state == PlayerState.paused) {
        motivationPlayer.stop();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Dna resetSettings>> ${e.toString()}");
      }
    }
    
    emit(PinealInitial());
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
        }else{
          await closeEyePlayer.play(AssetSource('audio/pineal_start.mp3'), );
        }
        
        Duration? duration = await closeEyePlayer.getDuration();
        waitingTime = duration!.inSeconds;
        emit(NavigateToWaitingScreen());
      }else{
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
        if(isFirstSet){
          if(holdDuration != -1){
            String countDownAudio = "audio/10_countdown.mp3" ;
            if(holdDuration == 15){
              countDownAudio = "audio/15_countdown.mp3" ;
            }
            if(holdDuration == 20){
              countDownAudio = "audio/20_countdown.mp3" ;
            }
            
            await jerryVoicePlayer.stop();
            await jerryVoicePlayer.play(AssetSource(countDownAudio));

            emit(ResumeHoldCounter());
            isFirstSet = false;
          }
        }
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
        await jerryVoicePlayer.play(AssetSource('audio/time_to_hold.mp3'));
        // await jerryVoicePlayer.play(AssetSource('audio/pineal_start_next_set.mp3'));
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
        jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.pinealSqeez);
  
        jerryVoicePlayer.stop();
        await jerryVoicePlayer.play(AssetSource(jerryVoiceAssetFile));

        // jerryVoicePlayer.getCurrentPosition(); // current duration
        // jerryVoicePlayer.getDuration(); // total duration

        jerryVoicePlayer.onPlayerComplete.listen((event) {
          if(holdDuration != -1){
            String countDownAudio = "audio/10_countdown.mp3" ;
            if(holdDuration == 15){
              countDownAudio = "audio/15_countdown.mp3" ;
            }
            if(holdDuration == 20){
              countDownAudio = "audio/20_countdown.mp3" ;
            }

            jerryVoicePlayer.play(AssetSource(countDownAudio));
          }
                    
          //todo: now hold for ....seconds counting start
          emit(ResumeHoldCounter());
        });
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("resetJerryVoiceAndPLayAgain>> ${e.toString()}");
      }
    }
  }

  // void playMotivation(double cntDown) async {
  //   int count = cntDown.toInt() ;
  //   try {
  //     if(holdDuration == -1){
  //       if(motivationPlayer.state != PlayerState.playing && motivationPlayer.state != PlayerState.paused){
  //         await motivationPlayer.play(AssetSource("audio/motivation.mp3"));
  //       }
  //       return ;
  //     }

  //     if(jerryVoice && (count != holdDuration) && (count != holdDuration-1) && (count != holdDuration-2) && (count != holdDuration-3) && (count != 3) && (count != 2) && (count != 1) && (count != 0) && (cntDown%6 == 0)){
  //       jerryVoicePlayer.pause();
  //       Duration? jerryCurrentVoiceDur = await jerryVoicePlayer.getCurrentPosition(); 
  //       int jerryCurrentVoice = jerryCurrentVoiceDur!.inSeconds ;
  //       // print("cntDown%6>>${cntDown%6}");
  //       // print("current_jerry>>$jerryCurrentVoice");
        
  //       // Duration? jerryTotalDur = await jerryVoicePlayer.getDuration(); 
  //       // int jerryTotalVoice = jerryTotalDur!.inSeconds ;

  //       await motivationPlayer.play(AssetSource("audio/motivation.mp3"));
  //       Duration? motivationDur = await motivationPlayer.getDuration(); 
  //       int motivationVoice = motivationDur!.inSeconds ;
  //       print("total_motivation>>$motivationVoice");

  //       motivationPlayer.onPlayerComplete.listen((event) {
  //         // print("jerry_seek>>${jerryCurrentVoice+motivationVoice+2}");
  //         jerryVoicePlayer.seek(Duration(seconds: (jerryCurrentVoice+motivationVoice+2) )); //move forward
  //         jerryVoicePlayer.resume();
  //       });
  //     }
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print("playMotivation>> ${e.toString()}");
  //     }
  //   }
  // }

  void stopMotivation() async {
    try {
      if(jerryVoice){
        await motivationPlayer.stop();
      }
    } catch (e) {
      if (kDebugMode) {
        print("stopMotivation>> ${e.toString()}");
      }
    }
  }

  void updateJerryAudio(String jerryVoice) async {
    jerryVoiceAssetFile = jerryVoice ;
  }

  void playHold() async {
    try {
      if(holdDuration >=10 && holdDuration < 25){
        await jerryVoicePlayer.play(AssetSource("audio/pineal_start_next_set_short.mp3"));
      }else{
        await jerryVoicePlayer.play(AssetSource("audio/pineal_start_next_set.mp3"));
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playHold>> ${e.toString()}");
      }
    }
  }

  void playHoldCountdown({bool isVeryShort = false}) async {
    try {
      if(jerryVoice){
        breathHoldPlayer.stop();
        if(holdDuration == 10){
          if(isVeryShort){
            await breathHoldPlayer.play(AssetSource('audio/single_3_2_1.mp3'));
          }
          else{
            await breathHoldPlayer.play(AssetSource('audio/breathing_out_recovery_countdown.mp3'));
          }
        }else{
          // await breathHoldPlayer.play(AssetSource('audio/3_2_1.mp3'));
          await breathHoldPlayer.play(AssetSource('audio/breathing_out_recovery_countdown.mp3'));
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("playHoldCountdown>> ${e.toString()}");
      }
    }
  }

  void playHoldMotivation() async {
    try {
      if(jerryVoice){
        // if(jerryVoicePlayer.state != PlayerState.playing) jerryVoicePlayer.stop();

        breathHoldPlayer.stop();
        await breathHoldPlayer.play(AssetSource('audio/motivation.mp3'));
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

  void playTimeToRecover() async {
    try {
      if(jerryVoice){
        recoveryPlayer.stop();
        await recoveryPlayer.play(AssetSource('audio/time_to_recover.mp3'));
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
    emit(PinealToggleSave());
  }

  void onCloseDialogClick(){
    isSaveDialogOn = false;
    emit(PinealToggleSave());
  }

  List<PinealBreathworkModel> savedBreathwork = [];

  void onSaveClick() async{
    if(saveInputCont.text.isEmpty){
      emit(PinealToggleSave());
      return ;
    }

    var box = await Hive.openBox('pinealBreathworkBox');

    PinealBreathworkModel breathwork = PinealBreathworkModel(
      title: saveInputCont.text,
      numberOfSets: noOfSets.toString(),
      jerryVoice: jerryVoice,
      music: music,
      chimes: chimes,
      breathingPeriod: breathingPeriod,
      holdTimePerSet: holdDuration,
      recoveryTimePerSet: recoveryBreathDuration,
      breathingTimeList: breathingTimeList,
      recoveryTimeList: recoveryTimeList
    );

    await box.add(breathwork.toJson());
   
    savedBreathwork.add(breathwork);
    isSaveDialogOn = false;
    saveInputCont.clear();

    updateSavedPinealBreathwork();
    
    showToast("Saved Successfuly");
    emit(PinealToggleSave());
  }

  void getAllSavedPinealBreathwork() async{
    var box = await Hive.openBox('pinealBreathworkBox');

    
    if(box.values.isEmpty || savedBreathwork.isNotEmpty){
      emit(PinealBreathworkFetched());
      return ;
    }

    savedBreathwork.clear();
    for (var item in box.values) {
      PinealBreathworkModel breathworks = PinealBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(PinealBreathworkFetched());
    }
  }

  void updateSavedPinealBreathwork() async{
    var box = await Hive.openBox('pinealBreathworkBox');

    
    if(box.values.isEmpty){
      emit(PinealBreathworkFetched());
      return ;
    }

    savedBreathwork.clear();
    for (var item in box.values) {
      PinealBreathworkModel breathworks = PinealBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(PinealBreathworkFetched());
    }
  }


  void deleteSavedPinealBreathwork(int index) async{
    var box = await Hive.openBox('pinealBreathworkBox');

    if(box.values.isEmpty){
      emit(PinealBreathworkFetched());
      return ;
    }
    
    var key = box.keyAt(index);
    await box.delete(key);
    savedBreathwork.removeAt(index);

    emit(PinealBreathworkFetched());
  }
  
}
