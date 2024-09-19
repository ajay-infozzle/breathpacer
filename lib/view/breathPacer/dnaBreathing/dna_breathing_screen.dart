import 'dart:async';

import 'package:breathpacer/bloc/dna/dna_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class DnaBreathingScreen extends StatefulWidget {
  const DnaBreathingScreen({super.key});

  @override
  State<DnaBreathingScreen> createState() => _DnaBreathingScreenState();
}

class _DnaBreathingScreenState extends State<DnaBreathingScreen> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;

  late double size, height;
  int breathCount = 0;
  bool isTimeBreathingApproch = false;
  late CountdownController countdownController;  

  late Timer _timer;
  int _startTime = 0;
  String breathOption = 'Breath In' ;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    
    isTimeBreathingApproch = context.read<DnaCubit>().isTimeBreathingApproch ;
    if(!isTimeBreathingApproch){
      breathCount = context.read<DnaCubit>().noOfBreath ;
      setUpAnimation();
    }
    else{
      countdownController = CountdownController(autoStart: true);
    }
    startTimer();
  }

  void setUpAnimation() {
    final cubit = context.read<DnaCubit>();

    Duration duration;
    switch (cubit.speed) {
      case 'Fast':
        duration = const Duration(seconds: 1);
        break;
      case 'Slow':
        duration = const Duration(seconds: 3);
        break;
      case 'Standard':
      default:
        duration = const Duration(seconds: 2);
        break;
    }

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    )..repeat(reverse: true);  // Repeat the animation in both directions

    
    _animation = Tween<double>(begin: 1, end: 0.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    bool hasDecreased = false; // Flag to ensure we only decrease once per cycle
    bool hasIncreased = false;

    _controller.addListener(() {

      if(_controller.status == AnimationStatus.forward && _animation.value > 0.98  && !hasIncreased){
        if (kDebugMode) {
          setState(() {
            breathOption = 'Breath In' ;
          });
          hasIncreased = true;
        }
      }

      // Check if the animation is shrinking and has passed a threshold (close to the minimum)
      if (_controller.status == AnimationStatus.reverse && _animation.value < 0.2 && !hasDecreased) {
        if (kDebugMode) {
          print("Dna Breath count: $breathCount");
        }
        
        // Decrease the breath count only once during the shrink phase
        if (breathCount > 0) {
          setState(() {
            breathCount--;
            breathOption = 'Breath Out';
          });
          hasDecreased = true; // Set the flag to true to prevent further decrements during this cycle
        }

        // Stop the animation if the breath count reaches 0
        if (breathCount == 0) {
          _controller.stop();

          storeScreenTime();
          navigate(context.read<DnaCubit>());
        }
      }

      // Reset the flag when the animation is expanding again
      if (_controller.status == AnimationStatus.forward && hasDecreased) {
        hasDecreased = false;
      }

      if (_controller.status == AnimationStatus.reverse && hasIncreased) {
        hasIncreased = false;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
        cubit.pauseAudio(cubit.jerryVoicePlayer, cubit.jerryVoice);

        if(context.read<DnaCubit>().isTimeBreathingApproch){
          countdownController.pause();
        }
        else{
          _controller.stop();
        }
        stopTimer();        
      } else {
        cubit.resumeAudio(cubit.musicPlayer, cubit.music);
        cubit.resumeAudio(cubit.jerryVoicePlayer, cubit.jerryVoice);

        if(context.read<DnaCubit>().isTimeBreathingApproch){
          countdownController.resume();
        }
        else{
          _controller.repeat(reverse: true);
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
    context.read<DnaCubit>().breathingTimeList.add(_startTime);

    if (kDebugMode) {
      print("dna breathing Stored Screen Time: $getScreenTiming");
    }
  }

  @override
  void dispose() {
    if(!isTimeBreathingApproch){
      _controller.dispose();
    }
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              if(context.read<DnaCubit>().isTimeBreathingApproch){
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

                      context.goNamed(
                        RoutesName.dnaSettingScreen,
                        extra: {
                          "subTitle" : "DNA breathing"
                        }
                      );
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
                          context.read<DnaCubit>().isTimeBreathingApproch 
                          ?"Breathe for ${getFormattedTime(context.read<DnaCubit>().durationOfSet)}"
                          :"Take ${context.read<DnaCubit>().noOfBreath} deep breaths",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size*0.05,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
            
                      SizedBox(height: height*0.05,),
                      
                      if(!context.read<DnaCubit>().isTimeBreathingApproch)
                      breathCount == 0 ?
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: size*0.12),
                        height: size-2*(size*0.12),
                        alignment: Alignment.center,
                        child: ClipPath(
                          clipper: OctagonalClipper(),
                          child: Container(
                            height: size-2*(size*0.12),
                            color: AppTheme.colors.blueNotChosen.withOpacity(.3),
                            child: Center(
                              child: Text(
                                "0",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size*0.2
                                ),
                              ),
                            ),
                          ),
                        ),
                      ):
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animation.value,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: size * 0.12),
                              height: size - 2 * (size * 0.12),
                              alignment: Alignment.center,
                              child: ClipPath(
                                clipper: OctagonalClipper(),
                                child: Container(
                                  height: size - 2 * (size * 0.12),
                                  color: AppTheme.colors.blueNotChosen.withOpacity(.3),
                                  child: Center(
                                    child: Text(
                                      breathCount.toString(),
                                      style: TextStyle(color: Colors.white, fontSize: size * 0.2),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          );
                        }
                      ),


                      if(context.read<DnaCubit>().isTimeBreathingApproch)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size*0.12),
                          height: size-2*(size*0.12),
                          alignment: Alignment.center,
                          child: ClipPath(
                            clipper: OctagonalClipper(),
                              child: Container(
                              height: size-2*(size*0.12),
                              color: AppTheme.colors.blueNotChosen.withOpacity(.3),
                              child: Center(
                                child: Countdown(
                                  controller: countdownController,
                                  seconds: context.read<DnaCubit>().durationOfSet,
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
                                    
                                    navigate(context.read<DnaCubit>());
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

            
                      SizedBox(height: height*0.04,),
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
      )
    );
  }
  
  String formatTimer(double time) {
    int minutes = (time / 60).floor(); 
    int seconds = (time % 60).floor(); 
    
    String minutesStr = minutes.toString().padLeft(2, '0'); 
    String secondsStr = seconds.toString().padLeft(2, '0'); 
    
    return "$minutesStr:$secondsStr";
  }

  String generateTapText(DnaCubit cubit) {
    if(cubit.holdingPeriod){
      if(cubit.choiceOfBreathHold == "Both"){
        return "Tap to hold ${cubit.breathHoldList[0]}";
      }
      else{
        return "Tap to hold ${cubit.choiceOfBreathHold}";
      }
    } 
    else if(cubit.recoveryBreath){
      return "Tap to go to recovery breath";
    }
    else{
      if(cubit.noOfSets == cubit.currentSet){
        return "Tap to finish";
      }
      else{
        return "Tap to go to next set";
      }
    }
  }

  void navigate(DnaCubit cubit) {
    context.read<DnaCubit>().stopJerry();
    if(cubit.holdingPeriod){
      if(cubit.choiceOfBreathHold == "Both"){
        cubit.breathHoldIndex = 0;
        context.read<DnaCubit>().playHold();
      }
      else{
        context.read<DnaCubit>().playHold();
      }
      context.goNamed(RoutesName.dnaHoldScreen);
    } 
    else if(cubit.recoveryBreath){
      context.read<DnaCubit>().playRecovery();
      context.goNamed(RoutesName.dnaRecoveryScreen);
    }
    else{
      if(cubit.noOfSets == cubit.currentSet){
        context.read<DnaCubit>().playChime();
        context.goNamed(RoutesName.dnaSuccessScreen);
      }
      else{
        cubit.currentSet = cubit.currentSet+1;
        context.read<DnaCubit>().resetJerryVoiceAndPLayAgain();
        context.goNamed(RoutesName.dnaBreathingScreen);
      }
    }
  }
}