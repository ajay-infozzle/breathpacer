import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/view/breathPacer/widget/waiting_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PyramidWaitingScreen extends StatefulWidget {
  const PyramidWaitingScreen({super.key});

  @override
  State<PyramidWaitingScreen> createState() => _PyramidWaitingScreenState();
}

class _PyramidWaitingScreenState extends State<PyramidWaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return WaitingScreenWidget(
      title: "Pyramid Breathing",
      onTimerFinished: (){
        context.read<PyramidCubit>().currentRound = 1 ;
        context.read<PyramidCubit>().playChime();
        context.read<PyramidCubit>().playJerry();

        context.pushReplacementNamed(RoutesName.pyramidBreathingScreen);
      },
    );
  }
}