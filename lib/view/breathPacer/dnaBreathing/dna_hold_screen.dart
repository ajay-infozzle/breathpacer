import 'dart:async';
import 'package:breathpacer/bloc/dna/dna_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class DnaHoldScreen extends StatefulWidget {
  const DnaHoldScreen({super.key});

  @override
  State<DnaHoldScreen> createState() => _DnaHoldScreenState();
}

class _DnaHoldScreenState extends State<DnaHoldScreen> {
  
  late Timer _timer;
  late CountdownController countdownController;
  int _startTime = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    startTimer();

    if(context.read<DnaCubit>().holdDuration != -1){
      countdownController = CountdownController(autoStart: true);
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _startTime++;
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  void resumeTimer() {
    startTimer();
  }

  void togglePauseResume() {
    setState(() {
      final cubit = context.read<DnaCubit>();
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
    if(context.read<DnaCubit>().breathHoldIndex == 0 || context.read<DnaCubit>().breathHoldIndex == 2){
      context.read<DnaCubit>().holdInbreathTimeList.add(_startTime-1); //~ -1 is added due to starttime auto increased 1 sec more
    }
    else{
      context.read<DnaCubit>().holdBreathoutTimeList.add(_startTime-1); //~ -1 is added due to starttime auto increased 1 sec more
    }

    if (kDebugMode) {
      print("Dna breath hold Time: $getScreenTiming");
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
              storeScreenTime();

              if(context.read<DnaCubit>().holdDuration != -1){
                countdownController.pause();
              }
              navigate(context.read<DnaCubit>());
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
                      context.read<DnaCubit>().resetSettings();

                      context.goNamed(RoutesName.homeScreen,);
                    },
                    child: const Icon(Icons.close,color: Colors.white,),
                  ),
                  title: Text(
                    "Set ${context.read<DnaCubit>().currentSet}",
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
                          "${context.read<DnaCubit>().pineal?"Squeeze & ":""}Hold on ${checkBreathChoice(context)}",
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

                      if(context.read<DnaCubit>().holdDuration == -1)
                      Container(
                        margin: EdgeInsets.only(top: height*0.04,bottom: height*0.04),
                        width: size,
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            getScreenTiming,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size*0.2
                            ),
                          ),
                        ),
                      ),


                      if(context.read<DnaCubit>().holdDuration != -1)
                      Container(
                        margin: EdgeInsets.only(top: height*0.04,bottom: height*0.04),
                        width: size,
                        alignment: Alignment.center,
                        child: Center(
                          child: Countdown(
                            controller: countdownController,
                            seconds: context.read<DnaCubit>().holdDuration,
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
                              context.read<DnaCubit>().stopJerry();

                              navigate(context.read<DnaCubit>());
                            },
                          ),
                        ),
                      ),
     

                      const Spacer(),
                      Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              generateTapText(context.read<DnaCubit>()),
                              style: TextStyle(color: Colors.white, fontSize: size*0.045),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.touch_app_outlined, size: 25, color: Colors.white),
                          ],
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
    if(context.read<DnaCubit>().breathHoldIndex == 0){
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
    if(context.read<DnaCubit>().holdDuration >= 30){
      if(time % 15 == 0 && time.toDouble() != context.read<DnaCubit>().holdDuration && (context.read<DnaCubit>().holdDuration - time) > 10 && int.parse(secondsStr) > 6){
        context.read<DnaCubit>().playHoldMotivation();
      }
    }

    //~ to start 3_2_1 voice
    if(secondsStr == "06"){
      context.read<DnaCubit>().playHoldCountdown();
    }
    
    return "$minutesStr:$secondsStr";
  }
  
  String generateTapText(DnaCubit cubit) {
    if(cubit.choiceOfBreathHold == "Both" && cubit.breathHoldIndex == 0){
      return "Tap to hold ${cubit.breathHoldList[1]}";
    } 
    else{
      if(cubit.recoveryBreath){
        return "Tap to go to recovery breath";
      }else{
        if(cubit.noOfSets == cubit.currentSet ){
          return "Tap to finish";
        }else{
          return "Tap to go to next set";
        }
      }
    }
  }

  void navigate(DnaCubit cubit) async{
    if(cubit.choiceOfBreathHold == "Both" && cubit.breathHoldIndex == 0){
      cubit.breathHoldIndex = 1;
      context.read<DnaCubit>().stopHold();
      context.read<DnaCubit>().playHold();
      
      context.pushReplacementNamed(RoutesName.dnaHoldScreen);
    } 
    else{
      context.read<DnaCubit>().stopHold();
      if(cubit.recoveryBreath){
        context.read<DnaCubit>().playTimeToRecover();
      
        await Future.delayed(const Duration(seconds: 2),() {
          context.read<DnaCubit>().playRecovery();
          context.goNamed(RoutesName.dnaRecoveryScreen);
        },);
      }else{
        if(cubit.noOfSets == cubit.currentSet ){
          context.read<DnaCubit>().playRelax();
          context.goNamed(RoutesName.dnaSuccessScreen);
        }else{
          context.read<DnaCubit>().playTimeToNextSet();
      
          await Future.delayed(const Duration(seconds: 2),() {
            cubit.currentSet = cubit.currentSet+1;
            // if(context.read<DnaCubit>().isTimeBreathingApproch){
            //   context.read<DnaCubit>().resetJerryVoiceAndPLayAgain();
            // }
            context.goNamed(RoutesName.dnaBreathingScreen);
          },);
        }
      }
    }
  }
}