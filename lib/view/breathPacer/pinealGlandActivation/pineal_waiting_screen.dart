import 'package:breathpacer/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/view/breathPacer/widget/waiting_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PinealWaitingScreen extends StatelessWidget {
  const PinealWaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WaitingScreenWidget(
      title: "Pineal Gland Activation",
      countdownTime: context.read<PinealCubit>().waitingTime,
      onTimerFinished: (){
        context.read<PinealCubit>().currentSet = 1 ;
        context.read<PinealCubit>().stopCloseEyes();
        context.read<PinealCubit>().playChime();
        // context.read<PinealCubit>().playJerry();

        context.pushReplacementNamed(RoutesName.pinealScreen);
      },
      onSkip: (){
        context.read<PinealCubit>().currentSet = 1 ;
        context.read<PinealCubit>().stopCloseEyes();
        context.read<PinealCubit>().playChime();

        context.pushReplacementNamed(RoutesName.pinealScreen);
      },
    );
  }
}