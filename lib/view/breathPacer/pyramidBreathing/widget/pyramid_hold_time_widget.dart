import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer/view/breathPacer/widget/result_container_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PyramidHoldTimeWidget extends StatelessWidget {
  const PyramidHoldTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultContainerSectionWidget(
          title: 'Total Holding time:',
          content: getTotalTimeString(context.read<PyramidCubit>().holdTimeList),
          iconPath: "assets/images/time.png",
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: const Color(0xffFE60D4),
          textColor: Colors.white,
          iconColor: Colors.white,
        ),

        
        for (int i = 0; i < context.read<PyramidCubit>().holdTimeList.length; i++) ...[
          ResultContainerSectionWidget(
            title: "Round ${i + 1} hold time:",
            showIcon: false,
            showContent: true,
            content: getFormattedTime(context.read<PyramidCubit>().holdTimeList[i]),
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