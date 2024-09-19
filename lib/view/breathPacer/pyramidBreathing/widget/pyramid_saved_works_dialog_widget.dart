import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer/utils/custom_button.dart';
import 'package:breathpacer/view/breathPacer/widget/result_container_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PyramidSavedWorksDialogWidget extends StatefulWidget {
  const PyramidSavedWorksDialogWidget({super.key});

  @override
  State<PyramidSavedWorksDialogWidget> createState() => _PyramidSavedWorksDialogWidgetState();
}

class _PyramidSavedWorksDialogWidgetState extends State<PyramidSavedWorksDialogWidget> {

  late double size;
  late double height;
  int expandIndex = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PyramidCubit, PyramidState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: size*0.03),
          color: Colors.white,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height * 0.8, 
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size*0.03,),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your saved breathworks",
                        style: TextStyle(
                          color: Colors.black.withOpacity(.7),
                          fontWeight: FontWeight.bold,
                          fontSize: size*0.055
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          context.pop();
                        }, 
                        icon: Icon(Icons.close,color: Colors.black.withOpacity(.5),size: 25,)
                      ),
                    ],
                  ),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: size*0.02),
                        child: CircleAvatar(
                          radius: size*0.042,
                          child: Image.asset("assets/images/pyramid_icon.png"),
                        ),
                      ),
                      Text(
                        "Pyramid Breathing",
                        style: TextStyle(
                          color: Colors.black.withOpacity(.6),
                          fontWeight: FontWeight.bold,
                          fontSize: size*0.045
                        ),
                      ),
                    ],
                  ),
              
                  SizedBox(height: size*0.03,),
              
                  for(int i=0; i<context.read<PyramidCubit>().savedBreathwork.length ; i++) ...[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            expandIndex = expandIndex == i ? -1 :i;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.read<PyramidCubit>().savedBreathwork[i].title!,
                              style: TextStyle(
                                color: Colors.black.withOpacity(.7),
                                fontWeight: FontWeight.bold,
                                fontSize: size*0.045
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  expandIndex = expandIndex == i ? -1 :i;
                                });
                              }, 
                              icon: Icon(
                                expandIndex == i
                                    ? Icons.keyboard_arrow_up_outlined
                                    : Icons.keyboard_arrow_down_outlined,
                                color: Colors.black.withOpacity(.5),size: 25,
                              )
                            ),
                          ],
                        ),
                      ),
              
              
                      if (expandIndex == i) ...[
                        ResultContainerSectionWidget(
                          title: 'Speed:',
                          content: context.read<PyramidCubit>().savedBreathwork[i].speed,
                          iconPath: "assets/images/time.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),
              
                        ResultContainerSectionWidget(
                          title: "Jerry's voice:",
                          content: context.read<PyramidCubit>().savedBreathwork[i].jerryVoice! ?"Yes" : "No",
                          iconPath: "assets/images/voice.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),
              
                        ResultContainerSectionWidget(
                          title: "Music:",
                          content: context.read<PyramidCubit>().savedBreathwork[i].music! ?"Yes" : "No",
                          iconPath: "assets/images/music.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),
              
                        ResultContainerSectionWidget(
                          title: "Chimes at start/stop points:",
                          content: context.read<PyramidCubit>().savedBreathwork[i].chimes! ?"Yes" : "No",
                          iconPath: "assets/images/chime.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),
              
                        ResultContainerSectionWidget(
                          title: "Choice of breath hold:",
                          content: context.read<PyramidCubit>().savedBreathwork[i].choiceOfBreathHold,
                          iconPath: "assets/images/breath_hold.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),
              
                        ResultContainerSectionWidget(
                          title: 'Total breathing time:',
                          content: getTotalTimeString(context.read<PyramidCubit>().savedBreathwork[i].breathingTimeList!),
                          iconPath: "assets/images/time.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),

                        if(context.read<PyramidCubit>().savedBreathwork[i].holdBreathOutTimeList!.isNotEmpty)
                        ResultContainerSectionWidget(
                          title: 'Out-Breath hold time:',
                          content: getTotalTimeString(context.read<PyramidCubit>().savedBreathwork[i].holdBreathOutTimeList!),
                          iconPath: "assets/images/time.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),

                        if(context.read<PyramidCubit>().savedBreathwork[i].holdBreathInTimeList!.isNotEmpty)
                        ResultContainerSectionWidget(
                          title: 'In-Breath hold time:',
                          content: getTotalTimeString(context.read<PyramidCubit>().savedBreathwork[i].holdBreathInTimeList!),
                          iconPath: "assets/images/time.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),
              
              
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                title: "Delete", 
                                height: 45,
                                spacing: .7,
                                radius: 10,
                                buttonColor: Colors.transparent,
                                textColor: const Color(0xffFE60D4),
                                onPress: (){
                                  context.read<PyramidCubit>().deleteSavedPyramidBreathwork(i);
                                }
                              ),
                            ),
                            SizedBox(width: size*0.03,),
                            Expanded(
                              child: CustomButton(
                                title: "Start", 
                                height: 45,
                                spacing: .7,
                                radius: 8,
                                onPress: (){
                                  context.read<PyramidCubit>().holdBreathoutTimeList.clear();
                                  context.read<PyramidCubit>().holdInbreathTimeList.clear();
                                  context.read<PyramidCubit>().breathingTimeList.clear();

                                  final savedWork = context.read<PyramidCubit>().savedBreathwork[i] ;
                                  context.read<PyramidCubit>().step = savedWork.step ;
                                  context.read<PyramidCubit>().speed = savedWork.speed ;
                                  context.read<PyramidCubit>().jerryVoice = savedWork.jerryVoice! ;
                                  context.read<PyramidCubit>().music = savedWork.music! ;
                                  context.read<PyramidCubit>().chimes = savedWork.chimes! ;
                                  context.read<PyramidCubit>().choiceOfBreathHold = savedWork.choiceOfBreathHold! ;
                                  
                                  context.pop();
                                  context.pushNamed(RoutesName.pyramidWaitingScreen);
                                }
                              ),
                            ),                    
                          ],
                        ),
              
                        SizedBox(height: size*0.03,),
                      ],
              
                      if(!(i+1 == context.read<PyramidCubit>().savedBreathwork.length))
                      Container(
                        height: 1,
                        color: Colors.grey.withOpacity(.3),
                      ),
                  ],
              
                  SizedBox(height: size*0.03,)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}