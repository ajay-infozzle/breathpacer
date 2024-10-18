import 'dart:async';

import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';

class PyramidBreathingScreen extends StatefulWidget {
  const PyramidBreathingScreen({super.key});

  @override
  State<PyramidBreathingScreen> createState() => _PyramidBreathingScreenState();
}

class _PyramidBreathingScreenState extends State<PyramidBreathingScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  int _startTime = 0; // Time in seconds

  int breathCount = 0;
  String breathOption = 'Breathe In' ;
  bool _isPaused = false;
  bool isAlreadyTapped = false;
  
  @override
  void initState() {
    super.initState();
    
    breathCount = checkBreathnumber(context);
    startTimer();
    setUpAnimation();

    if(context.read<PyramidCubit>().choiceOfBreathHold == "Both" && context.read<PyramidCubit>().breathHoldIndex == 2){
      context.read<PyramidCubit>().breathHoldIndex = 0;
    } 
  }


  void setUpAnimation() {
    final cubit = context.read<PyramidCubit>();

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
    bool hasIncreased = false; // Flag to ensure we only decrease once per cycle

    _controller.addListener(() async{
      if(_controller.status == AnimationStatus.forward && _animation.value > 0.98  && !hasIncreased){
        setState(() {
          if(breathCount != 0 && breathCount != -1){
            breathOption = 'Breathe In' ;
            context.read<PyramidCubit>().playBreathing("audio/single_breath_in_standard.mp3");
          }
        });
        hasIncreased = true;
      }

      // Check if the animation is shrinking and has passed a threshold (close to the minimum)
      if (_controller.status == AnimationStatus.reverse && _animation.value < 0.2 && !hasDecreased) {
        if (kDebugMode) {
          print("Breath count: $breathCount");
        }
        
        // Decrease the breath count only once during the shrink phase
        if (breathCount > -1) {
          setState(() {
            breathCount--;
            breathOption = 'Breathe Out';
            if(breathCount != -1){
              context.read<PyramidCubit>().playBreathing("audio/single_breath_out_standard.mp3");
            }
          });
          hasDecreased = true; 
        }

        // Stop the animation if the breath count reaches 0
        if (breathCount == -1) {
          _controller.stop();

          storeScreenTime();
          context.read<PyramidCubit>().stopJerry();

          if(context.read<PyramidCubit>().choiceOfBreathHold == "Both"){
            context.read<PyramidCubit>().breathHoldIndex = 0;
          }

          context.read<PyramidCubit>().playTimeToHold();
          await Future.delayed(const Duration(seconds: 2), () {
            context.read<PyramidCubit>().playHold();
            context.goNamed(RoutesName.pyramidBreathHoldScreen);
          },);
        }
      }

      // Reset the flag when the animation is expanding again
      if (_controller.status == AnimationStatus.forward && hasDecreased) {
        hasDecreased = false;
      }

      // Reset the flag when the animation is shrinking again
      if (_controller.status == AnimationStatus.reverse && hasIncreased) {
        hasIncreased = false;
      }
    });
  }


  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _startTime++;
        if(_startTime % 15 == 0 && _startTime != checkBreathnumber(context) && breathCount!=3 && breathCount!=2 && breathCount!=1 && _startTime!=0 && _startTime!=1){
          // if(context.read<PyramidCubit>().speed == "Slow"){
          //   context.read<PyramidCubit>().playHoldMotivation();
          // }
        }
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
      final cubit = context.read<PyramidCubit>();
      _isPaused = !_isPaused;
      if (_isPaused) {
        cubit.pauseAudio(cubit.musicPlayer, cubit.music);
        cubit.pauseAudio(cubit.jerryVoicePlayer, cubit.jerryVoice);
        cubit.pauseAudio(cubit.breathHoldPlayer, cubit.jerryVoice);

        _controller.stop(); 
        stopTimer();        
      } else {
        cubit.resumeAudio(cubit.musicPlayer, cubit.music);
        cubit.resumeAudio(cubit.jerryVoicePlayer, cubit.jerryVoice);
        cubit.resumeAudio(cubit.breathHoldPlayer, cubit.jerryVoice);

        _controller.repeat(reverse: true); 
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
    context.read<PyramidCubit>().breathingTimeList.add(_startTime-1); //~ -1 is added due to starttime auto increased 1 sec more
    if (kDebugMode) {
      print("Stored Screen Time: $getScreenTiming");
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
            onTap: () async{
              if(!isAlreadyTapped){
                isAlreadyTapped = true;
                storeScreenTime();
              
                if(context.read<PyramidCubit>().choiceOfBreathHold == "Both"){
                  context.read<PyramidCubit>().breathHoldIndex = 0;
                } 

                context.read<PyramidCubit>().stopJerry();

                context.read<PyramidCubit>().playTimeToHold();
                await Future.delayed(const Duration(seconds: 2), () {
                  context.read<PyramidCubit>().playHold();
                  context.goNamed(RoutesName.pyramidBreathHoldScreen);
                },);
              }
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
                      togglePauseResume();
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
                          "Take ${checkBreathnumber(context)} deep breaths",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size*0.05,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),


                      Container(
                        width: size*0.4,
                        margin: EdgeInsets.symmetric(horizontal: size*0.05, vertical: size*0.05),
                        padding: EdgeInsets.symmetric(vertical: size*0.03,horizontal: size*0.03),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          breathOption,
                          style: TextStyle(
                            color: AppTheme.colors.primaryColor,
                            fontSize: size*0.05,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
            
                      SizedBox(height: height*0.05,),
                      
                      breathCount == -1 ?
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
            
                      SizedBox(height: height*0.04,),
                      const Spacer(),
                      Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Tap to hold ${context.read<PyramidCubit>().breathHoldList[context.read<PyramidCubit>().breathHoldIndex]}",
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
  
  int checkBreathnumber(BuildContext context) {
    final cubit = context.read<PyramidCubit>();
    switch (cubit.currentRound) {
      case 1:
        return 12;
      case 2:
        return cubit.step == "4" ? 9 : 6;
      case 3:
        return 6;
      default:
        return 3;
    }
  }
}
