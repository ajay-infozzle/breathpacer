import 'package:breathpacer/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer/utils/custom_button.dart';
import 'package:breathpacer/view/breathPacer/widget/result_container_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PinealSavedWorkDialogWidget extends StatefulWidget {
  const PinealSavedWorkDialogWidget({super.key});

  @override
  State<PinealSavedWorkDialogWidget> createState() => _PinealSavedWorkDialogWidgetState();
}

class _PinealSavedWorkDialogWidgetState extends State<PinealSavedWorkDialogWidget> {
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

    return BlocBuilder<PinealCubit, PinealState>(
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
                          child: Image.asset("assets/images/pineal_icon.png"),
                        ),
                      ),
                      Text(
                        "Pineal Gland Activation",
                        style: TextStyle(
                          color: Colors.black.withOpacity(.6),
                          fontWeight: FontWeight.bold,
                          fontSize: size*0.045
                        ),
                      ),
                    ],
                  ),
              
                  SizedBox(height: size*0.03,),
              
                  for(int i=0; i<context.read<PinealCubit>().savedBreathwork.length ; i++) ...[
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
                              context.read<PinealCubit>().savedBreathwork[i].title!,
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
                          title: 'No. of sets:',
                          content: context.read<PinealCubit>().savedBreathwork[i].numberOfSets,
                          iconPath: "assets/images/time.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),


                        ResultContainerSectionWidget(
                          title: 'Breathing period:',
                          content: getFormattedTime(context.read<PinealCubit>().savedBreathwork[i].breathingPeriod!),
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
                          content: context.read<PinealCubit>().savedBreathwork[i].jerryVoice! ?"Yes" : "No",
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
                          content: context.read<PinealCubit>().savedBreathwork[i].music! ?"Yes" : "No",
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
                          content: context.read<PinealCubit>().savedBreathwork[i].chimes! ?"Yes" : "No",
                          iconPath: "assets/images/chime.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),
                        
                      
                        // ResultContainerSectionWidget(
                        //   title: 'Total breathing time:',
                        //   content: getTotalTimeString(context.read<PinealCubit>().savedBreathwork[i].breathingTimeList!),
                        //   iconPath: "assets/images/time.png",
                        //   iconSize: 25.0,
                        //   showIcon: true,
                        //   showContent: true,
                        //   containerColor: Colors.white,
                        //   textColor: Colors.black.withOpacity(.7),
                        //   iconColor: const Color(0xffFE60D4),
                        // ),

                        
                        ResultContainerSectionWidget(
                          title: 'Hold time per set:',
                          content: context.read<PinealCubit>().savedBreathwork[i].holdTimePerSet ==-1 ?"Infineite" : context.read<PinealCubit>().savedBreathwork[i].holdTimePerSet.toString(),
                          iconPath: "assets/images/time.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),

                        ResultContainerSectionWidget(
                          title: 'Recovery breath per set:',
                          content: context.read<PinealCubit>().savedBreathwork[i].recoveryTimePerSet.toString(),
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
                                  context.read<PinealCubit>().deleteSavedPyramidBreathwork(i);
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
                                  context.read<PinealCubit>().breathingTimeList.clear();
                                  context.read<PinealCubit>().recoveryTimeList.clear();

                                  final savedWork = context.read<PinealCubit>().savedBreathwork[i] ;
                                  context.read<PinealCubit>().noOfSets = int.parse(savedWork.numberOfSets!) ;
                                  context.read<PinealCubit>().currentSet = 0 ;
                                  context.read<PinealCubit>().breathingPeriod = savedWork.breathingPeriod! ;
                                  // context.read<PinealCubit>().holdDuration = savedWork.! ; //todo: also in model
                                  context.read<PinealCubit>().jerryVoice = savedWork.jerryVoice! ;
                                  context.read<PinealCubit>().music = savedWork.music! ;
                                  context.read<PinealCubit>().chimes = savedWork.chimes! ;
                                  
                                  
                                  context.pop();
                                  context.pushNamed(RoutesName.pinealWaitingScreen);
                                }
                              ),
                            ),                    
                          ],
                        ),
              
                        SizedBox(height: size*0.03,),
                      ],
              
                      if(!(i+1 == context.read<PinealCubit>().savedBreathwork.length))
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