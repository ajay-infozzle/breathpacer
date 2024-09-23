import 'dart:async';

import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class FirebreathingScreen extends StatefulWidget {
  const FirebreathingScreen({super.key});

  @override
  State<FirebreathingScreen> createState() => _FirebreathingScreenState();
}

class _FirebreathingScreenState extends State<FirebreathingScreen> with SingleTickerProviderStateMixin{

  late CountdownController countdownController;
  late AnimationController _controller;
  // late Animation<double> _animation;
  late Timer _timer;
  int _startTime = 0;

  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    
    startTimer();
    setUpAnimation();

    countdownController = CountdownController(autoStart: true);
  }

  void setUpAnimation() {
    // final cubit = context.read<FirebreathingCubit>();  

    Duration duration = const Duration(seconds: 1);
    
    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    )..repeat(reverse: true);  // Repeat the animation in both directions

    
    // _animation = Tween<double>(begin: 0.1, end: 1).animate(CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.easeInOut,
    // ));

    // bool hasDecreased = false; // Flag to ensure we only decrease once per cycle
    // _controller.addListener(() {
    //   // Check if the animation is shrinking and has passed a threshold (close to the minimum)
    //   if (_controller.status == AnimationStatus.reverse && _animation.value < 0.3 && !hasDecreased) {
    //     if (kDebugMode) {
    //       print("Breath count: $breathCount");
    //     }
        
    //     // Decrease the breath count only once during the shrink phase
    //     if (breathCount > 0) {
    //       setState(() {
    //         breathCount--;
    //       });
    //       hasDecreased = true; // Set the flag to true to prevent further decrements during this cycle
    //     }

    //     // Stop the animation if the breath count reaches 0
    //     if (breathCount == 0) {
    //       _controller.stop();

    //       storeScreenTime();
    //       context.read<PyramidCubit>().stopJerry();
    //       context.goNamed(RoutesName.pyramidBreathHoldScreen);
    //     }
    //   }

      // Reset the flag when the animation is expanding again
    //   if (_controller.status == AnimationStatus.forward && hasDecreased) {
    //     hasDecreased = false;
    //   }
    // });
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
      final cubit = context.read<FirebreathingCubit>();
      _isPaused = !_isPaused;
      if (_isPaused) {
        cubit.pauseAudio(cubit.musicPlayer, cubit.music);
        cubit.pauseAudio(cubit.jerryVoicePlayer, cubit.jerryVoice);

        countdownController.pause();
        stopTimer();        
      } else {
        cubit.resumeAudio(cubit.musicPlayer, cubit.music);
        cubit.resumeAudio(cubit.jerryVoicePlayer, cubit.jerryVoice);

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
    context.read<FirebreathingCubit>().breathingTimeList.add(_startTime);

    if (kDebugMode) {
      print("Stored breathing Screen Time: $getScreenTiming");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
              countdownController.pause();
              context.read<FirebreathingCubit>().stopJerry();

              storeScreenTime();

              navigate(context.read<FirebreathingCubit>());
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
                          "Fire Breathing",
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
                                seconds: context.read<FirebreathingCubit>().durationOfSets,
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
                                  context.read<FirebreathingCubit>().stopJerry();

                                  navigate(context.read<FirebreathingCubit>());
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      // AnimatedBuilder(
                      //   animation: _controller,
                      //   builder: (context, child) {
                      //     return Transform.scale(
                      //       scale: _animation.value,
                      //       child: Container(
                      //         margin: EdgeInsets.symmetric(horizontal: size * 0.12),
                      //         height: size - 2 * (size * 0.12),
                      //         alignment: Alignment.center,
                      //         child: ClipPath(
                      //           clipper: OctagonalClipper(),
                      //           child: Container(
                      //             height: size - 2 * (size * 0.12),
                      //             color: AppTheme.colors.blueNotChosen.withOpacity(.3),
                      //             child: Center(
                      //               child: Text(
                      //                 breathCount.toString(),
                      //                 style: TextStyle(color: Colors.white, fontSize: size * 0.2),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //     );
                      //   }
                      // ),
            
                      SizedBox(height: height*0.04,),
                      const Spacer(),
                      Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              generateTapText(context.read<FirebreathingCubit>()),
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
  
  String formatTimer(double time) {
    int minutes = (time / 60).floor(); 
    int seconds = (time % 60).floor(); 
    
    String minutesStr = minutes.toString().padLeft(2, '0'); 
    String secondsStr = seconds.toString().padLeft(2, '0'); 
    
    return "$minutesStr:$secondsStr";
  }

  String generateTapText(FirebreathingCubit cubit) {
    if (cubit.currentSet == cubit.noOfSets) {
      if(cubit.holdingPeriod){
        return "Tap to hold ${cubit.choiceOfBreathHold}";
      }
      else if (cubit.recoveryBreath){
        return "Tap to go in recovery breath";
      }
      else{
        return "Tap to finish";
      }
    } else if (cubit.holdingPeriod) {
      return "Tap to hold ${cubit.choiceOfBreathHold}";
    } else if (cubit.recoveryBreath) {
      return "Tap to go in recovery breath";
    } else {
      return "Tap to go to next set";
    }
  }

  void navigate(FirebreathingCubit cubit) {
    if (cubit.currentSet == cubit.noOfSets) {
      if(cubit.holdingPeriod){
        context.read<FirebreathingCubit>().playHold();
        context.goNamed(RoutesName.fireBreathingHoldScreen);
      }
      else if (cubit.recoveryBreath){
        context.read<FirebreathingCubit>().playRecovery();
        context.goNamed(RoutesName.fireBreathingRecoveryScreen);
      }
      else{
        context.read<FirebreathingCubit>().playChime();
        context.read<FirebreathingCubit>().playRelax();
        context.goNamed(RoutesName.fireBreathingSuccessScreen);
      }
    } else if (cubit.holdingPeriod) {
      context.read<FirebreathingCubit>().playHold();
      context.goNamed(RoutesName.fireBreathingHoldScreen);
    } else if (cubit.recoveryBreath) {
      context.read<FirebreathingCubit>().playRecovery();
      context.goNamed(RoutesName.fireBreathingRecoveryScreen);
    } else {
      context.read<FirebreathingCubit>().playJerry();
      cubit.currentSet = cubit.currentSet+1;
      context.pushReplacementNamed(RoutesName.fireBreathingScreen);
    }
  }
}