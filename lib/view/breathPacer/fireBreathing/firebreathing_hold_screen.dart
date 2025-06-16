import 'dart:async';
import 'dart:developer';

import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class FirebreathingHoldScreen extends StatefulWidget {
  const FirebreathingHoldScreen({super.key});

  @override
  State<FirebreathingHoldScreen> createState() => _FirebreathingHoldScreenState();
}

class _FirebreathingHoldScreenState extends State<FirebreathingHoldScreen> {

  late CountdownController countdownController;
  late Timer _timer;
  int _startTime = 0;
  bool _isPaused = false;
  bool isAlreadyTapped = false;

  @override
  void initState() {
    super.initState();
    startTimer();

    if(context.read<FirebreathingCubit>().holdDuration != -1){
      countdownController = CountdownController(autoStart: true);
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _startTime++;

        //~ to start motivation
        if(context.read<FirebreathingCubit>().holdDuration == -1){
          if(_startTime % 10 == 0 && _startTime > 10){
            context.read<FirebreathingCubit>().playHoldMotivation();
          }
        }
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
      final cubit = context.read<FirebreathingCubit>();
      _isPaused = !_isPaused;
      if (_isPaused) {
        cubit.pauseAudio(cubit.musicPlayer, cubit.music);
        cubit.pauseAudio(cubit.breathHoldPlayer, cubit.jerryVoice);

        countdownController.pause();
        stopTimer();        
      } else {
        cubit.resumeAudio(cubit.musicPlayer, cubit.music);
        cubit.resumeAudio(cubit.breathHoldPlayer, cubit.jerryVoice);

        countdownController.resume();
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
    context.read<FirebreathingCubit>().holdTimeList.add(_startTime-1 < 0 ? 0 : _startTime-1); //~ -1 is added due to starttime auto increased 1 sec more

    if (kDebugMode) {
      print("breath hold Time: $getScreenTiming");
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
              // if(!isAlreadyTapped) {
              //   isAlreadyTapped = true;
              //   storeScreenTime();
              //   navigate(context.read<FirebreathingCubit>());
              // }
            },
            child: Column(
              children: [
                AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: GestureDetector(
                    onTap: (){
                      // togglePauseResume();

                      countdownController.pause();
                      stopTimer();
                      context.read<FirebreathingCubit>().resetSettings();

                      context.goNamed(RoutesName.homeScreen,);
                    },
                    child: const Icon(Icons.close,color: Colors.white,),
                  ),
                  title: Text(
                    "Set ${context.read<FirebreathingCubit>().currentSet}",
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
                  child: Column(
                    children: [
                      SizedBox(height: height*0.1,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: size*0.05),
                        alignment: Alignment.center,
                        child: Text(
                          "Holding period",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size*0.05,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
            
                      SizedBox(height: height*0.05,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: size*0.12),
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: size*0.3,
                          child: Image.asset(
                            checkBreathChoice(context) == 'in-breath' 
                            ?"assets/images/breath_in.png"
                            :"assets/images/breath_out.png",
                          ),
                        ),
                      ),
            
                      // SizedBox(height: height*0.04,),
                      // Container(
                      //   width: size,
                      //   alignment: Alignment.center,
                      //   child: Center(
                      //     child: Text(
                      //       getScreenTiming,
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: size*0.2
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: height*0.04,),

                      if(context.read<FirebreathingCubit>().holdDuration != -1)
                      Container(
                        margin: EdgeInsets.only(top: height*0.04,bottom: height*0.04),
                        width: size,
                        alignment: Alignment.center,
                        child: Center(
                          child: Countdown(
                            controller: countdownController,
                            seconds: context.read<FirebreathingCubit>().holdDuration,
                            build: (BuildContext context, double time) => Text(
                              formatTimer(time),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size*0.2
                              ),
                            ),
                            interval: const Duration(seconds: 1),
                            onFinished: (){
                              storeScreenTime();
                              navigate(context.read<FirebreathingCubit>());
                            },
                          ),
                        ),
                      ),

                      const Spacer(),

                      // GestureDetector(
                      //   onTap: () {
                      //     if(!isAlreadyTapped) {
                      //       isAlreadyTapped = true;
                      //       if(context.read<FirebreathingCubit>().holdDuration != -1){
                      //         countdownController.pause();
                      //       }
                            
                      //       storeScreenTime();
                      //       navigate(context.read<FirebreathingCubit>());
                      //     }
                      //   },
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     color: Colors.transparent,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Text(
                      //           generateTapText(context.read<FirebreathingCubit>()),
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

  String checkBreathChoice(BuildContext context) {
    if(context.read<FirebreathingCubit>().breathHoldIndex == 0){
      return 'in-breath';
    }else{
      return 'out-breath';
    }
  }

  String generateTapText(FirebreathingCubit cubit) {
    if (cubit.currentSet == cubit.noOfSets) {
      if (cubit.recoveryBreath){
        return "Tap to go in recovery breath";
      }
      else{
        return "Tap to finish";
      }
    } else if (cubit.recoveryBreath) {
      return "Tap to go in recovery breath";
    } else {
      return "Tap to go to next set";
    }
  }

  void navigate(FirebreathingCubit cubit) async{
    if (cubit.currentSet == cubit.noOfSets) {
      if (cubit.recoveryBreath){
        // context.read<FirebreathingCubit>().stopJerry();
        // context.read<FirebreathingCubit>().stopHold();
        
        // await Future.delayed(const Duration(seconds: 2), () {
        //   context.read<FirebreathingCubit>().playRecovery();
        //   context.goNamed(RoutesName.fireBreathingRecoveryScreen);
        // },);
        context.goNamed(RoutesName.fireBreathingCountdownScreen, extra: {'recover' : true});
      }
      else{
        // context.read<FirebreathingCubit>().stopJerry();
        // context.read<FirebreathingCubit>().stopHold();
        // context.read<FirebreathingCubit>().stopMusic();
        // context.read<FirebreathingCubit>().playChime();
        // context.read<FirebreathingCubit>().playRelax();
        // context.goNamed(RoutesName.fireBreathingSuccessScreen);
        context.goNamed(RoutesName.fireBreathingCountdownScreen, extra: {'success' : true});
      }
    }else if (cubit.recoveryBreath) {
      // context.read<FirebreathingCubit>().stopHold();
      // context.read<FirebreathingCubit>().playTimeToRecover();

      // await Future.delayed(const Duration(seconds: 2), () {
      //   context.read<FirebreathingCubit>().playRecovery();
      //   context.goNamed(RoutesName.fireBreathingRecoveryScreen);
      // },);
      context.goNamed(RoutesName.fireBreathingCountdownScreen, extra: {'recover' : true});
    } else {
      // context.read<FirebreathingCubit>().stopHold();
      // context.read<FirebreathingCubit>().playTimeToNextSet();

      // await Future.delayed(const Duration(seconds: 2), () {
      //   context.read<FirebreathingCubit>().resetJerryVoiceAndPLayAgain();
      //   cubit.currentSet = cubit.currentSet+1;
      //   context.goNamed(RoutesName.fireBreathingScreen);
      // },);
      context.goNamed(RoutesName.fireBreathingCountdownScreen, extra: {});
    }
  }
  
  String formatTimer(double time) {
    int minutes = (time / 60).floor(); 
    int seconds = (time % 60).floor(); 
    
    String minutesStr = minutes.toString().padLeft(2, '0'); 
    String secondsStr = seconds.toString().padLeft(2, '0'); 

    //~ to start motivation
    if(context.read<FirebreathingCubit>().holdDuration >= 30){
      if(time % 15 == 0 && time.toDouble() != context.read<FirebreathingCubit>().holdDuration && (context.read<FirebreathingCubit>().holdDuration - time) > 10 && int.parse(secondsStr) > 6){
        context.read<FirebreathingCubit>().playHoldMotivation();
      }
    }

    //~ to start 3_2_1 voice
    bool isLastRound = false;
    if(context.read<FirebreathingCubit>().currentSet == context.read<FirebreathingCubit>().noOfSets){
      isLastRound = true;
    }

    if(isLastRound){
      if(secondsStr == "02"){
        context.read<FirebreathingCubit>().playHoldCountdown(isLastRound: isLastRound);
      }
    }else{
      if(secondsStr == "03"){
        context.read<FirebreathingCubit>().playHoldCountdown(isLastRound: isLastRound);
      }
      // if(secondsStr == "03" && context.read<FirebreathingCubit>().holdDuration != 10){
      //   context.read<FirebreathingCubit>().playHoldCountdown();
      // }
      // if(secondsStr == "03" && context.read<FirebreathingCubit>().holdDuration == 10){
      //   context.read<FirebreathingCubit>().playHoldCountdown();
      // }
    }

    return "$minutesStr:$secondsStr";
  }

}