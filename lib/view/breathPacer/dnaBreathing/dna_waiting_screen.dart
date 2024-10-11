import 'package:breathpacer/bloc/dna/dna_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/view/breathPacer/widget/waiting_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DnaWaitingScreen extends StatelessWidget {
  const DnaWaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WaitingScreenWidget(
      title: "DNA Breathing",
      countdownTime: context.read<DnaCubit>().waitingTime,
      onTimerFinished: (){
        context.read<DnaCubit>().currentSet = 1 ;
        context.read<DnaCubit>().stopCloseEyes();
        context.read<DnaCubit>().playChime();

        // if(context.read<DnaCubit>().isTimeBreathingApproch){
        //   context.read<DnaCubit>().playJerry();
        // }
        
        context.pushReplacementNamed(RoutesName.dnaBreathingScreen);
      },
    );
  }
}