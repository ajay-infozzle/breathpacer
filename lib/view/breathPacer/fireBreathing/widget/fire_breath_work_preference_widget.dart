import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer/view/breathPacer/widget/result_container_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FireBreathWorkPreferenceWidget extends StatelessWidget {
  const FireBreathWorkPreferenceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ResultContainerSectionWidget(
          title: "Breathwork Preference",
          showIcon: false,
          showContent: false,
          containerColor: Color(0xffFE60D4),
          textColor: Colors.white,
        ),

        ResultContainerSectionWidget(
          title: 'No. of sets:',
          content: context.read<FirebreathingCubit>().noOfSets.toString(),
          iconPath: "assets/images/time.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),

        ResultContainerSectionWidget(
          title: 'Duration of sets:',
          content: getFormattedTime(context.read<FirebreathingCubit>().durationOfSets),
          iconPath: "assets/images/time.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),

        ResultContainerSectionWidget(
          title: "Jerry's voice:",
          content: context.read<FirebreathingCubit>().jerryVoice ?"Yes" : "No",
          iconPath: "assets/images/voice.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),


        ResultContainerSectionWidget(
          title: "Music:",
          content: context.read<FirebreathingCubit>().music ?"Yes" : "No",
          iconPath: "assets/images/music.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),

        ResultContainerSectionWidget(
          title: 'Recovery breath duration:',
          content: getTotalTimeString(context.read<FirebreathingCubit>().recoveryTimeList),
          iconPath: "assets/images/recovery.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),

        ResultContainerSectionWidget(
          title: "Chimes at start/stop points:",
          content: context.read<FirebreathingCubit>().chimes ?"Yes" : "No",
          iconPath: "assets/images/chime.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),


        ResultContainerSectionWidget(
          title: "Holding period after each set:",
          content: context.read<FirebreathingCubit>().holdingPeriod ?"Yes" : "No",
          iconPath: "assets/images/time.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),

        if(context.read<FirebreathingCubit>().holdingPeriod)
        ResultContainerSectionWidget(
          title: "Choice of breath hold:",
          content: context.read<FirebreathingCubit>().breathHoldList[context.read<FirebreathingCubit>().breathHoldIndex],
          iconPath: context.read<FirebreathingCubit>().breathHoldIndex == 0 ? "assets/images/breath_hold.png" : "assets/images/breath_hold.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        if(context.read<FirebreathingCubit>().holdingPeriod)
        divider(),
      ],
    );
  }
  
  divider() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(.5),
    );
  }
}