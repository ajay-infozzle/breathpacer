import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:breathpacer/config/model/pyramid_breathwork_model.dart';
import 'package:breathpacer/utils/constant/jerry_voice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'pyramid_state.dart';

class PyramidCubit extends Cubit<PyramidState> {
  PyramidCubit() : super(PyramidInitial());

  String? step ;
  String? speed ; //Standard, Fast, Slow
  bool jerryVoice = false;
  bool music = false;
  bool chimes = false;
  String jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.breatheIn);
  String choiceOfBreathHold = 'Breath in';
  int breathHoldIndex = 0;
  List<String> breathHoldList = ['Breath in', 'Breath out'] ; 

  bool isReatartEnable = false;
  bool isSaveDialogOn = false;
  TextEditingController saveInputCont = TextEditingController();

  void initialSettings(String stepp, String speedd){
    step = stepp;
    speed = speedd;
    jerryVoice = false;
    music = false;
    chimes = false;
    isReatartEnable = true ;
  
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
  void toggleChimes(){
    chimes = !chimes ;
    emit(PyramidToggleChimes());
  }
  void toggleBreathHold(int index){
    choiceOfBreathHold =  breathHoldList[index];
    breathHoldIndex = index;
    emit(PyramidToggleBreathHold());
  }
  void changeJerryVoiceAudio(String audioFile){
    jerryVoiceAssetFile = audioFile;
    emit(PyramidToggleBreathHold());
  }


  int currentRound = 0;
  List<int> breathingTimeList = []; //sec
  List<int> holdTimeList = []; //sec
  AudioPlayer musicPlayer = AudioPlayer();
  AudioPlayer chimePlayer = AudioPlayer();
  AudioPlayer jerryVoicePlayer = AudioPlayer();
  AudioPlayer breathHoldPlayer = AudioPlayer();
  AudioPlayer relaxPlayer = AudioPlayer();

  void resetSettings(String stepp, String speedd){
    jerryVoice = false;
    music = false;
    chimes = false;

    currentRound = 0;
    breathingTimeList.clear();
    holdTimeList.clear();

    // Reset music player if active
    try {
      if (musicPlayer.state == PlayerState.playing) {
        musicPlayer.stop();
        // musicPlayer.seek(Duration.zero);
      }
      
      // Reset chime player if active
      if (chimePlayer.state == PlayerState.playing) {
        chimePlayer.stop();
        // chimePlayer.seek(Duration.zero);
      }
      
      // Reset Jerry Voice player if active
      if (jerryVoicePlayer.state == PlayerState.playing) {
        jerryVoicePlayer.stop();
        // jerryVoicePlayer.seek(Duration.zero);
      }
      
      // Reset breath hold player if active
      if (breathHoldPlayer.state == PlayerState.playing) {
        breathHoldPlayer.stop();
        // breathHoldPlayer.seek(Duration.zero);
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


  void playMusic() async {
    try {
      if(music){
        await musicPlayer.play(AssetSource('audio/music.mp3'), );
      
        //~ Listen for when the music is completed
        musicPlayer.onPlayerComplete.listen((event) {
          // Restart the music once it's completed
          // musicPlayer.seek(Duration.zero);
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

  void playJerry() async {
    try {
      if(jerryVoice){
        //~ for speed purpose
        jerryVoiceAssetFile = speed == "Standard" ? "audio/breath_standard.mp3" : (speed == "Fast" ? "audio/breath_fast.mp3" : "audio/breath_slow.mp3");
      
        await jerryVoicePlayer.play(AssetSource(jerryVoiceAssetFile));

        jerryVoicePlayer.onPlayerComplete.listen((event) {
          // jerryVoicePlayer.seek(Duration.zero);
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
      // await jerryVoicePlayer.seek(Duration.zero);
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
        //~ for speed purpose
        jerryVoiceAssetFile = speed == "Standard" ? "audio/breath_standard.mp3" : (speed == "Fast" ? "audio/breath_fast.mp3" : "audio/breath_slow.mp3");
      
        // jerryVoicePlayer.seek(Duration.zero);
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
    var box = await Hive.openBox('pyramidBreathworkBox');

    PyramidBreathworkModel breathwork = PyramidBreathworkModel(
      title: saveInputCont.text,
      speed: speed,
      step: step,
      jerryVoice: jerryVoice,
      music: music,
      chimes: chimes,
      choiceOfBreathHold: breathHoldList[breathHoldIndex],
      breathingTimeList: breathingTimeList,
      holdTimeList: holdTimeList,
    );

    await box.add(breathwork.toJson());
   
    savedBreathwork.add(breathwork);
    isSaveDialogOn = false;

    emit(PyramidToggleSave());
  }

  void getAllSavedPyramidBreathwork() async{
    var box = await Hive.openBox('pyramidBreathworkBox');

    savedBreathwork.clear();

    if(box.values.isEmpty){
      emit(PyramidBreathworkFetched());
      return ;
    }

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
