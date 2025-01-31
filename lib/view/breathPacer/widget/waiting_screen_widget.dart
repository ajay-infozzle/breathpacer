import 'package:breathpacer/bloc/dna/dna_cubit.dart';
import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class WaitingScreenWidget extends StatefulWidget {
  const WaitingScreenWidget({super.key, required this.title, required this.onTimerFinished, this.countdownTime = 10, required this.onSkip});

  final int countdownTime;
  final String title;
  final Function onTimerFinished ;
  final Function onSkip ;

  @override
  State<WaitingScreenWidget> createState() => _WaitingScreenWidgetState();
}

class _WaitingScreenWidgetState extends State<WaitingScreenWidget> {
  CountdownController countdownController = CountdownController(autoStart: true);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return PopScope(
      onPopInvoked: (didPop) {
        context.read<PyramidCubit>().resetSettings(
          context.read<PyramidCubit>().step ?? '', 
          context.read<PyramidCubit>().speed ?? ''
        );
        context.read<FirebreathingCubit>().resetSettings();
        context.read<DnaCubit>().resetSettings();
        context.read<PinealCubit>().resetSettings();
        
        // context.pop();
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.colors.linearGradient
          ),
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                leading: GestureDetector(
                  onTap: () {
                    context.read<PyramidCubit>().resetSettings(
                      context.read<PyramidCubit>().step ?? '', 
                      context.read<PyramidCubit>().speed ?? ''
                    );
                    context.read<FirebreathingCubit>().resetSettings();
                    context.read<DnaCubit>().resetSettings();
                    context.read<PinealCubit>().resetSettings();
                    
                    context.pop();
                  },
                  child: const Icon(Icons.arrow_back_ios),
                ),
                title: Text(
                  widget.title,
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
                    SizedBox(height: height*0.13,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      alignment: Alignment.center,
                      child: Text(
                        "Breathwork starts in...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size*0.05,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
      
      
                    SizedBox(height: height*0.04,),
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
                              seconds: widget.countdownTime,
                              build: (BuildContext context, double time) => Text(
                                formatTimer(time),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size*0.2
                                ),
                              ),
                              interval: const Duration(seconds: 1),
                              onFinished: widget.onTimerFinished,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // const Spacer(),
                    // CustomButton(
                    //   title: "Skip",
                    //   textsize: size * 0.043,
                    //   height: height * 0.062,
                    //   width: size,
                    //   spacing: .7,
                    //   radius: 0,
                    //   onPress: () {
                    //     countdownController.pause();
                    //     widget.onSkip();
                    //   }
                    // )
                  ],
                ) 
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTimer(double time) {
    if(time < 10){
      return "00:0${time.toString().split(".").first}" ;
    }
    return "00:${time.toString().split(".").first}" ;
  }
}