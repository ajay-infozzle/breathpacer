import 'package:breathpacer/bloc/dna/dna_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class DnaCountdownScreen extends StatefulWidget {
  final bool gotoHold, gotoRecover, gotoSuccess ;
  const DnaCountdownScreen({super.key, this.gotoHold = false, this.gotoRecover = false, this.gotoSuccess = false});

  @override
  State<DnaCountdownScreen> createState() => _DnaCountdownScreenState();
}

class _DnaCountdownScreenState extends State<DnaCountdownScreen> {
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
                                    navigate(context.read<DnaCubit>());
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
  
  void navigate(DnaCubit cubit) async{
    if (cubit.holdingPeriod && widget.gotoHold){
      context.goNamed(RoutesName.dnaHoldScreen); 
    } else if (cubit.recoveryBreath && widget.gotoRecover){
      await Future.delayed(const Duration(seconds: 1), () {
        cubit.playRecovery();
        context.goNamed(RoutesName.dnaRecoveryScreen);
      },);
    } else if (widget.gotoSuccess){
      cubit.stopJerry();
      cubit.stopHold();
      cubit.stopMusic();
      cubit.playChime();
      cubit.playRelax();
      context.goNamed(RoutesName.dnaSuccessScreen);
    } else{
      context.read<DnaCubit>().stopHold();
      // context.read<DnaCubit>().playTimeToNextSet();

      // await Future.delayed(const Duration(seconds: 2), () {
      //   context.read<DnaCubit>().resetJerryVoiceAndPLayAgain();
      //   cubit.currentSet = cubit.currentSet+1;
      //   context.goNamed(RoutesName.dnaBreathingScreen);
      // },);
      context.read<DnaCubit>().resetJerryVoiceAndPLayAgain();
      cubit.currentSet = cubit.currentSet+1;
      context.goNamed(RoutesName.dnaBreathingScreen);
    }
  }
}