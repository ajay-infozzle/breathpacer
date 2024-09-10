import 'package:bloc/bloc.dart';
import 'package:breathpacer/utils/constant/jerry_voice.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'dna_state.dart';

class DnaCubit extends Cubit<DnaState> {
  DnaCubit() : super(DnaInitial());

  String? speed ; //Standard, Fast, Slow
  int noOfSets = 1;
  int currentSet = 0;

  bool isTimeBreathingApproch = false;
  int noOfBreath = 10;
  int durationOfSet = 120;
  bool recoveryBreath = false;
  bool holdingPeriod = false;
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

  bool isReatartEnable = false;
  bool isSaveDialogOn = false;
  TextEditingController saveInputCont = TextEditingController();



  void updateSetsNumber(int number){
    noOfSets = number ;
    emit(DnaUpdateSetNumber());
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

  void toggleHolding(){
    holdingPeriod = !holdingPeriod ;
    emit(DnaToggleHolding());
  }

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

}
