import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'pineal_state.dart';

class PinealCubit extends Cubit<PinealState> {
  PinealCubit() : super(PinealInitial());

  bool recoveryBreath = false;
  bool jerryVoice = false;
  bool music = false;
  bool chimes = false;
  int recoveryBreathDuration = 120;
  int holdDuration = 120;
  int breathingPeriod = 120;
  List<int> breathingDurationList = [60, 120, 180, 240, 300, 360, 420, 480, 540, 600] ;
  List<int> holdDurationList = [60, 120, 180, 240, 300, 360, 420, 480, 540, 600, -1] ;
  List<int> recoveryDurationList = [60, 120, 180, 240, 300, 360, 420, 480, 540, 600] ;
  

  bool isReatartEnable = false;
  bool isSaveDialogOn = false;
  TextEditingController saveInputCont = TextEditingController();


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

  void toggleChimes(){
    chimes = !chimes ;
    emit(PinealToggleChimes());
  }
}
