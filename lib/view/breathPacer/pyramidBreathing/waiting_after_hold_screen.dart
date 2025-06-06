import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class WaitingAfterHoldScreen extends StatefulWidget {
  const WaitingAfterHoldScreen({super.key});

  @override
  State<WaitingAfterHoldScreen> createState() => _WaitingAfterHoldScreenState();
}

class _WaitingAfterHoldScreenState extends State<WaitingAfterHoldScreen> {
  late CountdownController countdownController;

  @override
  void initState() {
    super.initState();

    countdownController = CountdownController(autoStart: true);
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

          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: GestureDetector(
                  onTap: (){
                    
                    context.read<PyramidCubit>().resetSettings(
                      context.read<PyramidCubit>().step ?? '', 
                      context.read<PyramidCubit>().speed ?? ''
                    );

                    countdownController.pause();

                    context.goNamed(RoutesName.homeScreen,);
                  },
                  child: const Icon(Icons.close,color: Colors.white,),
                ),
              ),

              SizedBox(height: size*0.02,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size*0.05),
                color: Colors.white.withOpacity(.3),
                height: 1,
              ),

              Expanded(
                child: SizedBox(
                  width: size,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                        Container(
                          width: size,
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
                                  seconds: 3,
                                  build: (BuildContext context, double time) {
                                    return Text(
                                      time.toString().split(".").first,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size*0.2
                                      ),
                                    );
                                  },
                                  interval: const Duration(seconds: 1),
                                  onFinished: (){
                                    navigate(context.read<PyramidCubit>());
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ) 
              ),
            ],
          ),
        ),
      ),
    );
  }
  
   void navigate(PyramidCubit cubit) async{
    if(cubit.choiceOfBreathHold == "Both" && cubit.breathHoldIndex == 0){
      cubit.breathHoldIndex = 1;
      context.read<PyramidCubit>().stopHold();
      
      // context.read<PyramidCubit>().playTimeToHoldOutBreath();
      await Future.delayed(const Duration(seconds: 0), () {
        // context.read<PyramidCubit>().playHold();
        context.read<PyramidCubit>().playTimeToHoldOutBreath();
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
          
          // context.read<PyramidCubit>().playTimeToNextSet();
          await Future.delayed(const Duration(seconds: 0), () {
            cubit.currentRound = cubit.currentRound+1;
            context.goNamed(RoutesName.pyramidBreathingScreen);
          },);
        }
      }
    }
  }
}