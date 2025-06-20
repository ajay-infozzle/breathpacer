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

class FirebreathingRecoveryScreen extends StatefulWidget {
  const FirebreathingRecoveryScreen({super.key});

  @override
  State<FirebreathingRecoveryScreen> createState() => _FirebreathingRecoveryScreenState();
}

class _FirebreathingRecoveryScreenState extends State<FirebreathingRecoveryScreen> {

  late CountdownController countdownController;
  late Timer _timer;
  int _startTime = 0;
  bool _isPaused = false;
  bool isAlreadyTapped = false;

  @override
  void initState() {
    super.initState();
    startTimer();

    countdownController = CountdownController(autoStart: true);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _startTime++;
      });
    });
  }

  String get getScreenTiming {
    int minutes = _startTime ~/ 60;
    int seconds = _startTime % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
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
        cubit.pauseAudio(cubit.recoveryPlayer, cubit.jerryVoice);

        countdownController.pause();
        stopTimer();        
      } else {
        cubit.resumeAudio(cubit.musicPlayer, cubit.music);
        cubit.resumeAudio(cubit.recoveryPlayer, cubit.jerryVoice);

        countdownController.resume();
        resumeTimer();         
      }
    });
  }

  void storeScreenTime() {
    context.read<FirebreathingCubit>().recoveryTimeList.add(_startTime-1 < 0 ? 0 : _startTime-1); //~ -1 is added due to starttime auto increased 1 sec more

    if (kDebugMode) {
      print("breath recovery Time: $getScreenTiming");
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
                          "Recovery breath",
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
                            "assets/images/recovery_breath.png",
                          ),
                        ),
                      ),
            
                      SizedBox(height: height*0.04,),
                      Container(
                        width: size,
                        alignment: Alignment.center,
                        child: Center(
                          child: Countdown(
                            controller: countdownController,
                            seconds: context.read<FirebreathingCubit>().recoveryBreathDuration,
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
                      SizedBox(height: height*0.04,),

                      const Spacer(),

                      // GestureDetector(
                      //   onTap: () {
                      //     if(!isAlreadyTapped) {
                      //       isAlreadyTapped = true;
                      //       countdownController.pause();
                            
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

  String generateTapText(FirebreathingCubit cubit) {
    if (cubit.currentSet == cubit.noOfSets) {
      return "Tap to finish";
    } else {
      return "Tap to go to next set";
    }
  }

  void navigate(FirebreathingCubit cubit) async{
    if (cubit.currentSet == cubit.noOfSets) {
      cubit.stopJerry();
      cubit.stopRecovery();
      cubit.stopMusic();
      cubit.playChime();
      cubit.playRelax();
      context.goNamed(RoutesName.fireBreathingSuccessScreen);
    }else {
      cubit.stopJerry();
      cubit.stopRecovery();
      cubit.playTimeToNextSet();

      await Future.delayed(const Duration(seconds: 2), () {
        cubit.resetJerryVoiceAndPLayAgain();
        cubit.currentSet = cubit.currentSet+1;
        context.goNamed(RoutesName.fireBreathingScreen);
      },);
    }
  }

  String formatTimer(double time) {
    int minutes = (time / 60).floor(); 
    int seconds = (time % 60).floor(); 
    
    String minutesStr = minutes.toString().padLeft(2, '0'); 
    String secondsStr = seconds.toString().padLeft(2, '0'); 
    
    return "$minutesStr:$secondsStr";
  }

}