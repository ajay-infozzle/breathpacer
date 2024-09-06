import 'dart:async';

import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FirebreathingRecoveryScreen extends StatefulWidget {
  const FirebreathingRecoveryScreen({super.key});

  @override
  State<FirebreathingRecoveryScreen> createState() => _FirebreathingRecoveryScreenState();
}

class _FirebreathingRecoveryScreenState extends State<FirebreathingRecoveryScreen> {

  late Timer _timer;
  int _startTime = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
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

  void storeScreenTime() {
    context.read<FirebreathingCubit>().recoveryTimeList.add(_startTime);

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
              storeScreenTime();

              // if(context.read<FirebreathingCubit>().currentRound.toString() == context.read<FirebreathingCubit>().step){
              //   context.read<FirebreathingCubit>().stopMusic();
              //   // context.read<PyramidCubit>().resetMusic();
              //   context.read<FirebreathingCubit>().playChime();
              //   context.read<FirebreathingCubit>().stopJerry();

              //   if (kDebugMode) {
              //     print("fire breathing sets finished");
              //   }
              // }else{
              //   context.read<PyramidCubit>().resetJerryVoiceAndPLayAgain();
              // }

              navigate(context.read<FirebreathingCubit>());
            },
            child: Column(
              children: [
                AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Text(
                    "Set ${context.read<FirebreathingCubit>().currentSet}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
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
                          child: Text(
                            getScreenTiming,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size*0.2
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

  String checkBreathChoice(BuildContext context) {
    if(context.read<FirebreathingCubit>().breathHoldIndex == 0){
      return 'in-breath';
    }else{
      return 'out-breath';
    }
  }

  String generateTapText(FirebreathingCubit cubit) {
    if (cubit.currentSet == cubit.noOfSets) {
      return "Tap to finish";
    } else {
      return "Tap to go to next set";
    }
  }

  void navigate(FirebreathingCubit cubit) {
    if (cubit.currentSet == cubit.noOfSets) {
      context.goNamed(RoutesName.fireBreathingSuccessScreen);
    }else {
      cubit.currentSet = cubit.currentSet+1;
      context.goNamed(RoutesName.fireBreathingScreen);
    }
  }

}