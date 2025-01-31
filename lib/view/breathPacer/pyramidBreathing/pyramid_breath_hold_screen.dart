import 'dart:async';
import 'dart:developer';

import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class PyramidBreathHoldScreen extends StatefulWidget {
  const PyramidBreathHoldScreen({super.key});

  @override
  State<PyramidBreathHoldScreen> createState() => _PyramidBreathHoldScreenState();
}

class _PyramidBreathHoldScreenState extends State<PyramidBreathHoldScreen> {

  late CountdownController countdownController;
  late Timer _timer;
  int _startTime = 0; // Time in seconds
  bool _isPaused = false;
  bool isAlreadyTapped = false;
  
  @override
  void initState() {
    super.initState();
    startTimer();

    if(context.read<PyramidCubit>().holdDuration != -1){
      countdownController = CountdownController(autoStart: true);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _startTime++;

        //~ to start motivation
        if(context.read<PyramidCubit>().holdDuration == -1){
          if(_startTime % 10 == 0 && _startTime > 10){
            context.read<PyramidCubit>().playHoldMotivation();
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
      final cubit = context.read<PyramidCubit>();
      _isPaused = !_isPaused;
      if (_isPaused) {
        cubit.pauseAudio(cubit.musicPlayer, cubit.music);
        cubit.pauseAudio(cubit.breathHoldPlayer, cubit.jerryVoice);
         
        if(context.read<PyramidCubit>().holdDuration != -1){
          countdownController.pause();
        } 
        stopTimer();        
      } else {
        cubit.resumeAudio(cubit.musicPlayer, cubit.music);
        cubit.resumeAudio(cubit.breathHoldPlayer, cubit.jerryVoice);

        if(context.read<PyramidCubit>().holdDuration != -1){
          countdownController.resume();
        } 
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
    if(context.read<PyramidCubit>().breathHoldIndex == 0 || context.read<PyramidCubit>().breathHoldIndex == 2){
      context.read<PyramidCubit>().holdInbreathTimeList.add(_startTime-1 < 0 ? 0 : _startTime-1); //~ -1 is added due to starttime auto increased 1 sec more
    }
    else{
      context.read<PyramidCubit>().holdBreathoutTimeList.add(_startTime-1 < 0 ? 0 : _startTime-1); //~ -1 is added due to starttime auto increased 1 sec more
    }

    if (kDebugMode) {
      print("breath hold Time: $getScreenTiming");
    }
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
              //   storeScreenTime();
              //   navigate(context.read<PyramidCubit>());
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

                      if(context.read<PyramidCubit>().holdDuration != -1){
                        countdownController.pause();
                      } 
                      stopTimer();
                      
                      context.read<PyramidCubit>().resetSettings(
                        context.read<PyramidCubit>().step ?? '', 
                        context.read<PyramidCubit>().speed ?? ''
                      );

                      context.goNamed(RoutesName.homeScreen,);
                    },
                    child: const Icon(Icons.close,color: Colors.white,),
                  ),
                  title: Text(
                    "Round ${context.read<PyramidCubit>().currentRound}",
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
                          "Let go and hold on ${checkBreathChoice(context)}",
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
                      
                      if(context.read<PyramidCubit>().holdDuration != -1)
                      Container(
                        margin: EdgeInsets.only(top: height*0.04,bottom: height*0.04),
                        width: size,
                        alignment: Alignment.center,
                        child: Center(
                          child: Countdown(
                            controller: countdownController,
                            seconds: context.read<PyramidCubit>().holdDuration,
                            build: (BuildContext context, double time) => Text(
                              formatTimer(time),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size*0.2
                              ),
                            ),
                            interval: const Duration(seconds: 1),
                            onFinished: (){
                              // if(context.read<PyramidCubit>().currentRound.toString() == context.read<PyramidCubit>().step){
                              //   storeScreenTime();
                              //   context.read<PyramidCubit>().stopMusic();
                              //   context.read<PyramidCubit>().stopHold();
                              //   context.read<PyramidCubit>().playChime();
                              //   context.read<PyramidCubit>().stopJerry();

                              //   if (kDebugMode) {
                              //     print("pyramid rounds finished");
                              //   }
                              //   context.goNamed(RoutesName.pyramidSuccessScreen);
                              // }else{
                              //   storeScreenTime();
                              //   context.read<PyramidCubit>().stopHold();
                              //   context.read<PyramidCubit>().currentRound = context.read<PyramidCubit>().currentRound+1;
                              //   context.read<PyramidCubit>().resetJerryVoiceAndPLayAgain();
                                
                              //   context.goNamed(RoutesName.pyramidBreathingScreen);
                              // }

                              storeScreenTime();
                              navigate(context.read<PyramidCubit>());
                            },
                          ),
                        ),
                      ),
                      

                      const Spacer(),
                      
                      GestureDetector(
                        onTap: () {
                          if(!isAlreadyTapped){
                            isAlreadyTapped = true;
                            if(context.read<PyramidCubit>().holdDuration != -1){
                              countdownController.pause();
                            }
                            
                            storeScreenTime();
                            navigate(context.read<PyramidCubit>());
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                generateTapText(context.read<PyramidCubit>()),
                                style: TextStyle(color: Colors.white, fontSize: size*0.045),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.touch_app_outlined, size: 25, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
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
    if(context.read<PyramidCubit>().breathHoldIndex == 0){
      return 'in-breath';
    }else{
      return 'out-breath';
    }
  }
  
  String formatTimer(double time) {
    int minutes = (time / 60).floor(); 
    int seconds = (time % 60).floor(); 
    
    String minutesStr = minutes.toString().padLeft(2, '0'); 
    String secondsStr = seconds.toString().padLeft(2, '0'); 

    //~ to start motivation
    if(context.read<PyramidCubit>().holdDuration >= 30){
      if(time % 15 == 0 && time.toDouble() != context.read<PyramidCubit>().holdDuration && (context.read<PyramidCubit>().holdDuration - time) > 10 && int.parse(secondsStr) > 6){
        context.read<PyramidCubit>().playHoldMotivation();
      }
    }

    //~ to start 3_2_1 voice
    if(secondsStr == "06" && context.read<PyramidCubit>().holdDuration != 10){
      context.read<PyramidCubit>().playHoldCountdown();
    }
    if(secondsStr == "06" && context.read<PyramidCubit>().holdDuration == 10){
      context.read<PyramidCubit>().playHoldCountdown();
    }
    
    return "$minutesStr:$secondsStr";
  }

  String generateTapText(PyramidCubit cubit) {
    if(cubit.choiceOfBreathHold == "Both" && cubit.breathHoldIndex == 0){
      return "Tap to hold ${cubit.breathHoldList[1]}";
    } 
    else{
      // if(cubit.recoveryBreath){
      if(1 > 2){
        return "Tap to go to recovery breath";
      }else{
        if(cubit.step == cubit.currentRound.toString() ){
          return "Tap to finish";
        }else{
          return "Tap to go to next set";
        }
      }
    }
  }

  void navigate(PyramidCubit cubit) async{
    if(cubit.choiceOfBreathHold == "Both" && cubit.breathHoldIndex == 0){
      cubit.breathHoldIndex = 1;
      context.read<PyramidCubit>().stopHold();
      
      await Future.delayed(const Duration(seconds: 1), () {
        context.read<PyramidCubit>().playHold();
        context.pushReplacementNamed(RoutesName.pyramidBreathHoldScreen);
      },);
    } 
    else{
      cubit.stopHold();
      if(1 > 2){
        // context.read<PyramidCubit>().playRecovery();
        // context.goNamed(RoutesName.dnaRecoveryScreen);
      }else{
        if(cubit.step == cubit.currentRound.toString()){
          cubit.stopMusic();
          cubit.stopJerry();
          cubit.playChime();

          if (kDebugMode) {
            print("pyramid rounds finished");
          }
          context.goNamed(RoutesName.pyramidSuccessScreen);
        }else{
          // cubit.currentRound = cubit.currentRound+1;
          // cubit.resetJerryVoiceAndPLayAgain();
          
          context.read<PyramidCubit>().playTimeToNextSet();
          await Future.delayed(const Duration(seconds: 2), () {
            cubit.currentRound = cubit.currentRound+1;
            context.goNamed(RoutesName.pyramidBreathingScreen);
          },);
        }
      }
    }
  }
 
}
