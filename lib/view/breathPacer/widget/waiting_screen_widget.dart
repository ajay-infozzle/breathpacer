import 'package:breathpacer/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:timer_count_down/timer_count_down.dart';

class WaitingScreenWidget extends StatelessWidget {
  const WaitingScreenWidget({super.key, required this.title, required this.onTimerFinished});

  final String title;
  final Function onTimerFinished ;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return Scaffold(
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
                  onTap: () => context.pop(),
                  child: const Icon(Icons.arrow_back_ios),
                ),
              title: Text(
                title,
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
                            seconds: 3,
                            build: (BuildContext context, double time) => Text(
                              formatTimer(time),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size*0.2
                              ),
                            ),
                            interval: const Duration(seconds: 1),
                            onFinished: onTimerFinished,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ) 
            ),
          ],
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