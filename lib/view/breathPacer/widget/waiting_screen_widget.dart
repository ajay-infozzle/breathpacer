import 'dart:async';

import 'package:breathpacer/bloc/dna/dna_cubit.dart';
import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// import 'package:timer_count_down/timer_controller.dart';
// import 'package:timer_count_down/timer_count_down.dart';

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
  // CountdownController countdownController = CountdownController(autoStart: true);
  double progress = 0.0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startProgress();
  }

  void startProgress() {
    int totalMilliseconds = widget.countdownTime * 1000;
    int interval = 100;
    int elapsed = 0;

    timer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      setState(() {
        elapsed += interval;
        progress = elapsed / totalMilliseconds;
      });
      if (elapsed >= totalMilliseconds) {
        timer.cancel();

        Future.delayed(const Duration(milliseconds: 300), () => widget.onTimerFinished(),);
      }
    });
  }

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
                        "Get ready to breathe...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size*0.05,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
      
      
                    // SizedBox(height: height*0.04,),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: size*0.12),
                    //   height: size-2*(size*0.12),
                    //   alignment: Alignment.center,
                    //   child: ClipPath(
                    //     clipper: OctagonalClipper(),
                    //     child: Container(
                    //       height: size-2*(size*0.12),
                    //       color: AppTheme.colors.blueNotChosen.withOpacity(.3),
                    //       child: Center(
                    //         child: Countdown(
                    //           controller: countdownController,
                    //           seconds: widget.countdownTime,
                    //           build: (BuildContext context, double time) => Text(
                    //             formatTimer(time),
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontSize: size*0.2
                    //             ),
                    //           ),
                    //           interval: const Duration(seconds: 1),
                    //           onFinished: widget.onTimerFinished,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    
                    // SizedBox(height: height*0.04,),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: size*0.12),
                    //   child: CircularProgressIndicator(
                    //     value: progress,
                    //     strokeWidth: 8,
                    //     backgroundColor: Colors.white.withOpacity(0.3),
                    //     valueColor: AlwaysStoppedAnimation<Color>(AppTheme.colors.blueNotChosen),
                    //   ),
                    // ),
                    SizedBox(height: height*0.04,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: size*0.12),
                      height: size-2*(size*0.12),
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 100),
                        builder: (context, value, child) {
                          return CircleAvatar(
                            backgroundColor: progress >=1 ? const Color(0xFF5777D5) :Colors.white,
                            radius: size / 3.5,
                            child: CustomPaint(
                              painter: FilledCirclePainter(value, const Color(0xFF5777D5)),
                              size: Size(size, size),
                            ),
                          );
                        },
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



class FilledCirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  FilledCirclePainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill; // Fills the circle

    final double radius = size.width / 2;
    final double sweepAngle = 2 * 3.141592653589793 * progress; // Converts progress to angle
    final Offset center = Offset(size.width / 2, size.height / 2);

    Path path = Path();
    path.moveTo(center.dx, center.dy);
    path.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // Start from top (12 o’clock position)
      sweepAngle,
      false,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(FilledCirclePainter oldDelegate) => oldDelegate.progress != progress;
}
