import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer/view/breathPacer/widget/result_container_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FireBreathingRecoveryTimeWidget extends StatelessWidget {
  const FireBreathingRecoveryTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultContainerSectionWidget(
          title: 'Total recovery breath period:',
          content: getTotalTimeString(context.read<FirebreathingCubit>().recoveryTimeList),
          iconPath: "assets/images/time.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: const Color(0xffFE60D4),
          textColor: Colors.white,
          iconColor: Colors.white,
        ),


        for (int i = 0; i < context.read<FirebreathingCubit>().recoveryTimeList.length; i++) ...[
          ResultContainerSectionWidget(
            title: "Set ${i + 1} time:",
            showIcon: false,
            showContent: true,
            content: getFormattedTime(context.read<FirebreathingCubit>().recoveryTimeList[i]),
            containerColor: Colors.white,
            textColor: Colors.black.withOpacity(.7),
          ),
          divider(),
        ],
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