import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/view/breathPacer/widget/result_container_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PyramidBreathWorkPreferenceWidget extends StatelessWidget {
  const PyramidBreathWorkPreferenceWidget({super.key});

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
          content: context.read<PyramidCubit>().speed,
          iconPath: "assets/images/time.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          // iconColor: const Color(0xffFE60D4),
        ),
        divider(),

        ResultContainerSectionWidget(
          title: "Jerry's voice:",
          content: context.read<PyramidCubit>().jerryVoice ?"Yes" : "No",
          iconPath: "assets/images/voice.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          // iconColor: const Color(0xffFE60D4),
        ),
        divider(),


        ResultContainerSectionWidget(
          title: "Music:",
          content: context.read<PyramidCubit>().music ?"Yes" : "No",
          iconPath: "assets/images/music.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          // iconColor: const Color(0xffFE60D4),
        ),
        divider(),


        ResultContainerSectionWidget(
          title: "Chimes at start/stop points:",
          content: context.read<PyramidCubit>().chimes ?"Yes" : "No",
          iconPath: "assets/images/chime.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          // iconColor: const Color(0xffFE60D4),
        ),
        divider(),


        ResultContainerSectionWidget(
          title: "Choice of breath hold:",
          content: context.read<PyramidCubit>().choiceOfBreathHold,
          iconPath: context.read<PyramidCubit>().breathHoldIndex == 0 ? "assets/images/hold.png" : "assets/images/hold.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          // iconColor: const Color(0xffFE60D4),
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