import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer/utils/custom_button.dart';
import 'package:breathpacer/view/breathPacer/widget/result_container_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FirebreathingSavedWorksDialogWidget extends StatefulWidget {
  const FirebreathingSavedWorksDialogWidget({super.key});

  @override
  State<FirebreathingSavedWorksDialogWidget> createState() => _FirebreathingSavedWorksDialogWidgetState();
}

class _FirebreathingSavedWorksDialogWidgetState extends State<FirebreathingSavedWorksDialogWidget> {

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
    return BlocBuilder<FirebreathingCubit, FirebreathingState>(
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
                          child: Image.asset("assets/images/fire_icon.png"),
                        ),
                      ),
                      Text(
                        "Fire Breathing",
                        style: TextStyle(
                          color: Colors.black.withOpacity(.6),
                          fontWeight: FontWeight.bold,
                          fontSize: size*0.045
                        ),
                      ),
                    ],
                  ),
              
                  SizedBox(height: size*0.03,),
              
                  for(int i=0; i<context.read<FirebreathingCubit>().savedBreathwork.length ; i++) ...[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            expandIndex = expandIndex == i ? -1 :i;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                context.read<FirebreathingCubit>().savedBreathwork[i].title!,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(.7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: size*0.045
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            
                            SizedBox(width: size*0.02,),

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
                          content: context.read<FirebreathingCubit>().savedBreathwork[i].numberOfSets,
                          iconPath: "assets/images/time.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),


                        ResultContainerSectionWidget(
                          title: 'Duration of sets:',
                          content: getFormattedTime(context.read<FirebreathingCubit>().savedBreathwork[i].durationOfEachSet!),
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
                          content: context.read<FirebreathingCubit>().savedBreathwork[i].jerryVoice! ?"Yes" : "No",
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
                          content: context.read<FirebreathingCubit>().savedBreathwork[i].music! ?"Yes" : "No",
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
                          content: context.read<FirebreathingCubit>().savedBreathwork[i].chimes! ?"Yes" : "No",
                          iconPath: "assets/images/chime.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),
                        
                        if(context.read<FirebreathingCubit>().savedBreathwork[i].holdPeriodEnabled!)
                        ResultContainerSectionWidget(
                          title: "Choice of breath hold:",
                          content: context.read<FirebreathingCubit>().savedBreathwork[i].choiceOfBreathHold,
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
                          content: getTotalTimeString(context.read<FirebreathingCubit>().savedBreathwork[i].breathingTimeList!),
                          iconPath: "assets/images/time.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),
              
                        if(context.read<FirebreathingCubit>().savedBreathwork[i].holdPeriodEnabled!)
                        ResultContainerSectionWidget(
                          title: 'Total Holding time:',
                          content: getTotalTimeString(context.read<FirebreathingCubit>().savedBreathwork[i].holdTimeList!),
                          iconPath: "assets/images/time.png",
                          iconSize: 25.0,
                          showIcon: true,
                          showContent: true,
                          containerColor: Colors.white,
                          textColor: Colors.black.withOpacity(.7),
                          iconColor: const Color(0xffFE60D4),
                        ),

                        if(context.read<FirebreathingCubit>().savedBreathwork[i].recoveryEnabled!)
                        ResultContainerSectionWidget(
                          title: 'Recovery breath time:',
                          content: getTotalTimeString(context.read<FirebreathingCubit>().savedBreathwork[i].recoveryTimeList!),
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
                                  context.read<FirebreathingCubit>().deleteSavedFireBreathwork(i);
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
                                  context.read<FirebreathingCubit>().holdTimeList.clear();
                                  context.read<FirebreathingCubit>().breathingTimeList.clear();
                                  context.read<FirebreathingCubit>().recoveryTimeList.clear();

                                  final savedWork = context.read<FirebreathingCubit>().savedBreathwork[i] ;
                                  context.read<FirebreathingCubit>().noOfSets = int.parse(savedWork.numberOfSets!) ;
                                  context.read<FirebreathingCubit>().durationOfSets = savedWork.durationOfEachSet! ;
                                  context.read<FirebreathingCubit>().holdingPeriod = savedWork.holdPeriodEnabled! ;
                                  context.read<FirebreathingCubit>().recoveryBreath = savedWork.recoveryEnabled! ;
                                  context.read<FirebreathingCubit>().pineal = savedWork.pineal! ;
                                  context.read<FirebreathingCubit>().jerryVoice = savedWork.jerryVoice! ;
                                  context.read<FirebreathingCubit>().music = savedWork.music! ;
                                  context.read<FirebreathingCubit>().chimes = savedWork.chimes! ;
                                  context.read<FirebreathingCubit>().choiceOfBreathHold = savedWork.choiceOfBreathHold! ;
                                  
                                  context.pop();
                                  context.pushNamed(
                                    RoutesName.fireSettingScreen, 
                                    extra:{
                                      "subTitle" : "TYPE 2: Fire breathing"
                                    }
                                  );
                                }
                              ),
                            ),                    
                          ],
                        ),
              
                        SizedBox(height: size*0.03,),
                      ],
              
                      if(!(i+1 == context.read<FirebreathingCubit>().savedBreathwork.length))
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