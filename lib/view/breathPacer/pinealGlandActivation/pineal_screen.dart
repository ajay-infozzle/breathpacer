import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:breathpacer/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class PinealScreen extends StatefulWidget {
  const PinealScreen({super.key});

  @override
  State<PinealScreen> createState() => _PinealScreenState();
}

class _PinealScreenState extends State<PinealScreen> {

  late CountdownController holdCountdownController;  
  late CountdownController remainingCountdownController;  
  late Timer _timer;
  int _startTime = 0;
  bool _isPaused = false;
  bool isAlreadyTapped = false;

  @override
  void initState() {
    super.initState();
    startTimer();

    if(context.read<PinealCubit>().currentSet == 1){
      context.read<PinealCubit>().updateRemainingBreathTime(context.read<PinealCubit>().breathingPeriod);
    }

    context.read<PinealCubit>().playHold();

    holdCountdownController = CountdownController(autoStart: true);
    remainingCountdownController = CountdownController(autoStart: true);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      
      if(_startTime%10 == 0 && _startTime > 9){
        if(context.read<PinealCubit>().holdDuration == -1 && context.read<PinealCubit>().breathingPeriod - _startTime > 10){
          // context.read<PinealCubit>().playMotivation(0.0);
          context.read<PinealCubit>().playHoldMotivation();
        }
      }

      setState(() {
        _startTime++;
      });
    });
  }

  void stopTimer() {
    try {
      _timer.cancel();
    } catch (e) {
      log(e.toString());
    }
  }

  void resumeTimer() {
    startTimer();
  }

  void togglePauseResume() {
    setState(() {
      final cubit = context.read<PinealCubit>();
      _isPaused = !_isPaused;
      if (_isPaused) {
        cubit.pauseAudio(cubit.musicPlayer, cubit.music);
        cubit.pauseAudio(cubit.jerryVoicePlayer, cubit.jerryVoice);
        // cubit.pauseAudio(cubit.motivationPlayer, cubit.jerryVoice);
        cubit.pauseAudio(cubit.breathHoldPlayer, cubit.jerryVoice);

        if(context.read<PinealCubit>().holdDuration != -1 ){
          holdCountdownController.pause();
        }
        remainingCountdownController.pause();
        stopTimer();        
      } else {
        cubit.resumeAudio(cubit.musicPlayer, cubit.music);
        cubit.resumeAudio(cubit.motivationPlayer, cubit.jerryVoice);
        cubit.resumeAudio(cubit.breathHoldPlayer, cubit.jerryVoice);

        // if(cubit.motivationPlayer.state != PlayerState.playing && cubit.motivationPlayer.state != PlayerState.paused){
        //   cubit.resumeAudio(cubit.jerryVoicePlayer, cubit.jerryVoice);
        // }
              

        if(context.read<PinealCubit>().holdDuration != -1){
          holdCountdownController.resume();
        }
        remainingCountdownController.resume();
        resumeTimer();         
      }
    });
  }


  String get getScreenTiming {
    int minutes = _startTime ~/ 60;
    int seconds = _startTime % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  void storeScreenTime() {
    if(_startTime > context.read<PinealCubit>().breathingPeriod){
      context.read<PinealCubit>().calculateRemainingBreathTime(context.read<PinealCubit>().breathingPeriod);
    }
    else{
      context.read<PinealCubit>().calculateRemainingBreathTime(_startTime-1); //~ -1 is added due to starttime auto increased 1 sec more
    }

    if (kDebugMode) {
      print("pineal breathing & hold Time>>: $getScreenTiming");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    double size = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: size,
          height: height,
          decoration: BoxDecoration(
            gradient: AppTheme.colors.linearGradient,
          ),
          child: GestureDetector(
            onTap: () {
              // if(!isAlreadyTapped){
              //   isAlreadyTapped = true;

              //   if(context.read<PinealCubit>().holdDuration == -1){
              //     storeScreenTime();
              //     if(!remainingCountdownController.isCompleted!){
              //       remainingCountdownController.pause();
              //     }
              //     navigate(context.read<PinealCubit>());
              //   }
              // }              
            },
            child: Column(
              children: [
                AppBar(
                  scrolledUnderElevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: GestureDetector(
                    onTap: (){
                      if(context.read<PinealCubit>().holdDuration != -1 ){
                        holdCountdownController.pause();
                      }
                      remainingCountdownController.pause();
                      stopTimer(); 
                      
                      context.read<PinealCubit>().resetSettings();

                      context.goNamed(RoutesName.homeScreen,);
                    },
                    child: const Icon(Icons.close,color: Colors.white,),
                  ),
                  title: Text(
                    "Set ${context.read<PinealCubit>().currentSet}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                      onPressed: togglePauseResume, 
                      icon: Icon(
                        _isPaused ? Icons.play_arrow : Icons.pause, 
                        color: Colors.white,
                        size: 30,
                      ),
                    ),

                    SizedBox(width: size*0.03,)
                  ],
                ),
                SizedBox(height: size*0.02,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size*0.05),
                  color: Colors.white.withOpacity(.3),
                  height: 1,
                ),
            
                //~
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: [
                      SizedBox(height: height*0.03,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: size*0.05),
                        alignment: Alignment.center,
                        child: Text(
                          "Squeeze & Hold on Breathe in",
                          // "Squeeze & Breathe in",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size*0.05,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
            
                      SizedBox(height: height*0.03,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: size*0.12),
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: size*0.25,
                          child: Image.asset(
                            "assets/images/breath_in.png",
                          ),
                        ),
                      ),

                      // BlocConsumer<PinealCubit, PinealState>(
                      //   builder: (context, state) {
                      //     return const SizedBox();
                      //   }, 
                      //   listener: (context, state) {
                      //     print(">>$state");
                      //   },
                      // ),

                      if(context.read<PinealCubit>().holdDuration != -1)
                      BlocConsumer<PinealCubit, PinealState>(
                        listener: (context, state) {
                          if (kDebugMode) {
                            print("Current state>>: $state");
                          }
                          // if(state is ResumeHoldCounter){
                          //   if (kDebugMode) {
                          //     print("resumHold>>");
                          //   }
                          //   holdCountdownController.resume();
                          // }
                        }, 
                        builder: (context, state) { 
                          return Container(
                            margin: EdgeInsets.only(top: height*0.04),
                            width: size,
                            alignment: Alignment.center,
                            child: Center(
                              child: Text(
                                "Hold for:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size*0.045
                                ),
                              ),
                            ),
                          );
                        }, 
                      ),
                      

                      if(context.read<PinealCubit>().holdDuration != -1)
                      Container(
                        margin: EdgeInsets.only(top: height*0.001),
                        width: size,
                        alignment: Alignment.center,
                        child: Center(
                          child: Countdown(
                            controller: holdCountdownController,
                            seconds: context.read<PinealCubit>().holdDuration,
                            build: (BuildContext cnt, double time) {
                              return Text(
                                formatTimer(time, isForHold: true),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size*0.2
                                ),
                              );
                            },
                            interval: const Duration(seconds: 1),
                            onFinished: (){                              
                              if(!remainingCountdownController.isCompleted!){
                                remainingCountdownController.pause();
                              }
                              storeScreenTime();
                              context.read<PinealCubit>().stopJerry();
                              navigate(context.read<PinealCubit>());
                            },
                          ),
                        ),
                      ),


                      Container(
                        margin: EdgeInsets.only(top: context.read<PinealCubit>().holdDuration == -1?height*0.04:height*0.01,),
                        width: size,
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            "Breathwork time remaining:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size*0.045
                            ),
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: height*0.001,bottom: height*0.04),
                        width: size,
                        alignment: Alignment.center,
                        child: Center(
                          child: Countdown(
                            controller: remainingCountdownController,
                            seconds: context.read<PinealCubit>().remainingBreathTime,
                            build: (BuildContext context, double time) {
                              return Text(
                                formatTimer(time),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size*0.2
                                ),
                              );
                            },
                            interval: const Duration(seconds: 1),
                            onFinished: (){
                              storeScreenTime();
                              context.read<PinealCubit>().stopJerry();

                              if(context.read<PinealCubit>().holdDuration != -1){
                                try {
                                  if(!holdCountdownController.isCompleted!){
                                    holdCountdownController.pause();
                                  }
                                } catch (e) {
                                  log(e.toString());
                                }
                              }

                              navigate(context.read<PinealCubit>());
                            },
                          ),
                        ),
                      ),
     

                      // if(context.read<PinealCubit>().holdDuration == -1)
                      // GestureDetector(
                      //   onTap: () {
                      //     if(!isAlreadyTapped){
                      //       isAlreadyTapped = true;

                      //       if(context.read<PinealCubit>().holdDuration == -1){
                      //         storeScreenTime();
                      //         if(!remainingCountdownController.isCompleted!){
                      //           remainingCountdownController.pause();
                      //         }
                      //         navigate(context.read<PinealCubit>());
                      //       }
                      //     } 
                      //   },
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     color: Colors.transparent,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Text(
                      //           "Tap to go to recovery",
                      //           style: TextStyle(color: Colors.white, fontSize: size*0.045),
                      //         ),
                      //         const SizedBox(width: 10),
                      //         const Icon(Icons.touch_app_outlined, size: 25, color: Colors.white),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      SizedBox(height: height*0.08,),
                    ],
                  ) 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatTimer(double time, {bool isForHold = false}) {
    int minutes = (time / 60).floor(); 
    int seconds = (time % 60).floor(); 
    
    String minutesStr = minutes.toString().padLeft(2, '0'); 
    String secondsStr = seconds.toString().padLeft(2, '0'); 

    if(isForHold){
      //~ to start motivation
      if(context.read<PinealCubit>().holdDuration >= 15 && context.read<PinealCubit>().holdDuration < 30){
        if(time % 8 == 0 && time.toDouble() != context.read<PinealCubit>().holdDuration && (context.read<PinealCubit>().holdDuration - time) > 6 && int.parse(secondsStr) > 6){
          context.read<PinealCubit>().playHoldMotivation();
        }
      }

      if(context.read<PinealCubit>().holdDuration >= 30 && context.read<PinealCubit>().jerryVoicePlayer.state != PlayerState.playing){
        if(time % 12 == 0 && time.toDouble() != context.read<PinealCubit>().holdDuration && (context.read<PinealCubit>().holdDuration - time) > 6 && int.parse(secondsStr) > 6){
          context.read<PinealCubit>().playHoldMotivation();
        }
      }

      //~ to start 3_2_1 voice
      // if(secondsStr == "06" && context.read<PinealCubit>().holdDuration != 10){
      //   context.read<PinealCubit>().playHoldCountdown();
      // }
      // if(secondsStr == "03" && context.read<PinealCubit>().holdDuration == 10){
      //   context.read<PinealCubit>().playHoldCountdown(isVeryShort: true);
      // }
    }
    
    return "$minutesStr:$secondsStr";
  }
  
  
  void navigate(PinealCubit cubit) async{
    cubit.stopJerry();
    cubit.playTimeToRecover();

    if(context.mounted){
      await Future.delayed(Duration(seconds: cubit.jerryVoice?2:0), () {
        cubit.playRecovery();
        context.goNamed(RoutesName.pinealRecoveryScreen);
      },);
    }
  }

}