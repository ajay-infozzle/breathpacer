
import 'package:breathpacer/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class PinealRecoveryScreen extends StatefulWidget {
  const PinealRecoveryScreen({super.key});

  @override
  State<PinealRecoveryScreen> createState() => _PinealRecoveryScreenState();
}

class _PinealRecoveryScreenState extends State<PinealRecoveryScreen> {

  late CountdownController recoverCountdownController;  
    
  // late Timer _timer;
  int _startTime = 0;
  bool _isPaused = false;
  // bool isAlreadyTapped = false;

  @override
  void initState() {
    super.initState();
    startTimer();

    recoverCountdownController = CountdownController(autoStart: true);
  }

  void startTimer() {
    // _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {    
    //   setState(() {
    //     _startTime++;
    //   });
    // });
  }

  String get getScreenTiming {
    int minutes = _startTime ~/ 60;
    int seconds = _startTime % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  // void stopTimer() {
  //   _timer.cancel();
  // }

  // void resumeTimer() {
  //   startTimer();
  // }

  void togglePauseResume() {
    setState(() {
      final cubit = context.read<PinealCubit>();
      _isPaused = !_isPaused;
      if (_isPaused) {
        cubit.pauseAudio(cubit.musicPlayer, cubit.music);
        cubit.pauseAudio(cubit.recoveryPlayer, cubit.jerryVoice);
        cubit.pauseAudio(cubit.jerryVoicePlayer, cubit.jerryVoice);

        recoverCountdownController.pause();        
      } else {
        cubit.resumeAudio(cubit.musicPlayer, cubit.music);
        cubit.resumeAudio(cubit.recoveryPlayer, cubit.jerryVoice);
        cubit.resumeAudio(cubit.jerryVoicePlayer, cubit.jerryVoice);

        recoverCountdownController.resume();         
      }
    });
  }

  void storeScreenTime() {
    if (kDebugMode) {
      print("pineal breathing & hold Time: $getScreenTiming");
    }
  }

  @override
  void dispose() {
    // _timer.cancel();
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
              //   recoverCountdownController.pause();
              //   storeScreenTime();
              //   navigate(context.read<PinealCubit>());
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
                      // togglePauseResume();
                      recoverCountdownController.pause();   
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
                          "Recovery breath",
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
                            "assets/images/recovery_breath.png",
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: height*0.04),
                        width: size,
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            "Recover for:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size*0.045
                            ),
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: height*0.001),
                        width: size,
                        alignment: Alignment.center,
                        child: Center(
                          child: Countdown(
                            controller: recoverCountdownController,
                            seconds: context.read<PinealCubit>().recoveryBreathDuration,
                            build: (BuildContext context, double time) {
                              // if(formatTimer(time) == "00:00"){
                              //   storeScreenTime();
                              //   context.read<PinealCubit>().stopRecovery();
                              // }
                              
                              return Text(
                                formatTimer(time, isForRecover: true),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size*0.2
                                ),
                              );
                            }
                            ,
                            interval: const Duration(seconds: 1),
                            onFinished: (){
                              storeScreenTime();
                              context.read<PinealCubit>().stopRecovery();
                              
                              navigate(context.read<PinealCubit>());
                            },
                          ),
                        ),
                      ),


                      // Container(
                      //   margin: EdgeInsets.only(top: context.read<PinealCubit>().holdDuration == -1?height*0.04:height*0.01,),
                      //   width: size,
                      //   alignment: Alignment.center,
                      //   child: Center(
                      //     child: Text(
                      //       "Breathwork time remaining:",
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: size*0.045
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      Container(
                        margin: EdgeInsets.only(top: height*0.001,bottom: height*0.04),
                        width: size,
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            formatTimer(double.parse(context.read<PinealCubit>().remainingBreathTime.toString())),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size*0.2
                            ),
                          ),
                        ),
                      ),
     

                      // if(context.read<PinealCubit>().holdDuration == -1)
                      // Container(
                      //   alignment: Alignment.center,
                      //   color: Colors.transparent,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         generateTapText(context.read<PinealCubit>()),
                      //         style: TextStyle(color: Colors.white, fontSize: size*0.045),
                      //       ),
                      //       const SizedBox(width: 10),
                      //       const Icon(Icons.touch_app_outlined, size: 25, color: Colors.white),
                      //     ],
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

  String formatTimer(double time, {bool isForRecover = false}) {
    int minutes = (time / 60).floor(); 
    int seconds = (time % 60).floor(); 
    
    String minutesStr = minutes.toString().padLeft(2, '0'); 
    String secondsStr = seconds.toString().padLeft(2, '0'); 
    
    return isForRecover ?  "$minutesStr:$secondsStr" : "";
  }
  

  String generateTapText(PinealCubit cubit) {
    if(cubit.remainingBreathTime > 0){
      return "Tap to go to next set";
    }else{
      return "Tap to finish";
    }
  }
  
  void navigate(PinealCubit cubit) async{
    context.read<PinealCubit>().stopRecovery();
    // if(cubit.remainingBreathTime > 0){
    if(cubit.remainingBreathTime >= cubit.holdDuration){
      context.read<PinealCubit>().playTimeToNextSet();

      if(context.mounted){
        // await Future.delayed(Duration(seconds: cubit.jerryVoice?9:0), () {
        await Future.delayed(Duration(seconds: cubit.jerryVoice?2:0), () {
          // context.read<PinealCubit>().resetJerryVoiceAndPLayAgain();
          cubit.currentSet = cubit.currentSet+1;
          context.goNamed(RoutesName.pinealScreen);
        },);
      }
    }else{
      cubit.stopMusic();
      cubit.stopJerry();
      cubit.playRelax();
      cubit.playChime();
      context.goNamed(RoutesName.pinealSuccessScreen);
    }
  }
  
}