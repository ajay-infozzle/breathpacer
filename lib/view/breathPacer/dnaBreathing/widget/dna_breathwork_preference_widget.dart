import 'package:breathpacer/bloc/dna/dna_cubit.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer/view/breathPacer/widget/result_container_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DnaBreathWorkPreferenceWidget extends StatelessWidget {
  const DnaBreathWorkPreferenceWidget({super.key});

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
          title: 'Speed:',
          content: context.read<DnaCubit>().speed,
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
          title: 'No. of sets:',
          content: context.read<DnaCubit>().noOfSets.toString(),
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
          title: 'Breathing approach:',
          content: context.read<DnaCubit>().breathingApproachGroupValue,
          iconPath: "assets/images/breath_hold.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),

        if(context.read<DnaCubit>().isTimeBreathingApproch)
        ResultContainerSectionWidget(
          title: 'Duration of sets:',
          content: getFormattedTime(context.read<DnaCubit>().durationOfSet),
          iconPath: "assets/images/time.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        if(context.read<DnaCubit>().isTimeBreathingApproch)
        divider(),


        if(!context.read<DnaCubit>().isTimeBreathingApproch)
        ResultContainerSectionWidget(
          title: 'Breathe per set:',
          content: context.read<DnaCubit>().noOfBreath.toString(),
          iconPath: "assets/images/time.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        if(!context.read<DnaCubit>().isTimeBreathingApproch)
        divider(),

        ResultContainerSectionWidget(
          title: "Jerry's voice:",
          content: context.read<DnaCubit>().jerryVoice ?"Yes" : "No",
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
          content: context.read<DnaCubit>().music ?"Yes" : "No",
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
          content: getTotalTimeString(context.read<DnaCubit>().recoveryTimeList),
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
          content: context.read<DnaCubit>().chimes ?"Yes" : "No",
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
          title: "Pineal Gland:",
          content: context.read<DnaCubit>().pineal ?"Yes" : "No",
          iconPath: "assets/images/pineal_icon.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
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