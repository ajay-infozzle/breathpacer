import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:breathpacer/utils/custom_button.dart';
import 'package:breathpacer/view/breathPacer/fireBreathing/widget/fire_breath_work_preference_widget.dart';
import 'package:breathpacer/view/breathPacer/fireBreathing/widget/fire_breathing_holding_time_widget.dart';
import 'package:breathpacer/view/breathPacer/fireBreathing/widget/fire_breathing_recovery_time_widget.dart';
import 'package:breathpacer/view/breathPacer/fireBreathing/widget/fire_breathing_time_widget.dart';
import 'package:breathpacer/view/breathPacer/widget/restart_breathing_widget.dart';
import 'package:breathpacer/view/breathPacer/widget/save_custom_dialog_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FirebreathingSuccessScreen extends StatefulWidget {
  const FirebreathingSuccessScreen({super.key});

  @override
  State<FirebreathingSuccessScreen> createState() => _FirebreathingSuccessScreenState();
}

class _FirebreathingSuccessScreenState extends State<FirebreathingSuccessScreen> {

  @override
  void initState() {
    super.initState();

    context.read<FirebreathingCubit>().playRelax();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if(!context.read<FirebreathingCubit>().isSaveDialogOn){
          context.goNamed(RoutesName.homeScreen);
        }
      },
      child: Scaffold(
        body: Container(
          width: size,
          height: height,
          decoration: BoxDecoration(
            gradient: AppTheme.colors.linearGradient,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  AppBar(
                    scrolledUnderElevation: 0,
                    iconTheme: const IconThemeData(color: Colors.white),
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    leading: GestureDetector(
                      onTap: (){
                        context.goNamed(RoutesName.homeScreen);
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    title: Column(
                      children: [
                        Text(
                          "Fire Breathing",
                          style: TextStyle(color: Colors.white, fontSize: size*0.05,fontWeight: FontWeight.bold),
                        ),
                        // Text(
                        //   context.read<PyramidCubit>().step == "2" ? "2 step (12-6 breathing)" : "4 step (12-9-6-3 breathing)",
                        //   style: TextStyle(color: Colors.white, fontSize: size*0.04),
                        // ),
                      ],
                    ),
                  ),
              
                  Expanded(
                    child: ListView(
                      children: [
                        // SizedBox(height: height*0.07,),
                        // Container(
                        //   margin: EdgeInsets.symmetric(horizontal: size*0.06),
                        //   alignment: Alignment.center,
                        //   child: Column(
                        //     children: [
                        //       Text(
                        //         "Pyramid Breathing",
                        //         style: TextStyle(color: Colors.white, fontSize: size*0.05,fontWeight: FontWeight.bold),
                        //       ),
                        //       Text(
                        //         context.read<PyramidCubit>().step == "2" ? "2 step (12-6 breathing)" : "4 step (12-9-6-3 breathing)",
                        //         style: TextStyle(color: Colors.white, fontSize: size*0.04),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                    
                        // SizedBox(height: height*0.04,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size*0.06),
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: size*0.12,
                            child: Image.asset("assets/images/completion_icon.png"),
                          ),
                        ),
                    
                    
                        SizedBox(height: height*0.03,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size*0.06),
                          alignment: Alignment.center,
                          child: Text(
                            "Well Done!",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: size*0.06),
                          ),
                        ),
                    
                    
                        SizedBox(height: height*0.03,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size*0.06),
                          alignment: Alignment.center,
                          child: Text(
                            "Take a deep breath and relax, regain your normal breathing speed. Here are your results",
                            style: TextStyle(color: Colors.white, fontSize: size*0.04),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    
                        SizedBox(height: height*0.02,),
                        //~ breathwork preference
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size*0.05),
                          color: Colors.white,
                          child: const FireBreathWorkPreferenceWidget(),
                        ),
                        
                    
                        SizedBox(height: height*0.03,),
                        //~ total breathing time
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size*0.05),
                          color: Colors.white,
                          child: const  FireBreathingTimeWidget(),
                        ),

                        if(context.read<FirebreathingCubit>().holdingPeriod)
                        SizedBox(height: height*0.03,),
                        //~ total holding time
                        if(context.read<FirebreathingCubit>().holdingPeriod)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size*0.05),
                          color: Colors.white,
                          child: const  FireBreathingHoldTimeWidget(),
                        ),

                        if(context.read<FirebreathingCubit>().recoveryBreath)
                        SizedBox(height: height*0.03,),
                        //~ total recovery time
                        if(context.read<FirebreathingCubit>().recoveryBreath)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size*0.05),
                          color: Colors.white,
                          child: const  FireBreathingRecoveryTimeWidget(),
                        ),
                    
                    
                        SizedBox(height: height*0.03,),
                        //~ restart breathing work
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size*0.05),
                          child: RestartBreathingWidget(
                            onTap: () {
                              context.read<FirebreathingCubit>().isReatartEnable = true ;
                              context.read<FirebreathingCubit>().resetSettings();
                    
                              context.goNamed(
                                RoutesName.fireSettingScreen,
                                extra:{
                                  "subTitle" : "TYPE 2: Fire breathing"
                                }
                              );
                            },
                          ),
                        ),
                    
                    
                        SizedBox(height: height*0.03,),
                        //~ save breath work
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size*0.05),
                          child: CustomButton(
                            title: "Save breathwork", 
                            textsize: size*0.043,
                            height: 48,
                            spacing: .7,
                            radius: 10,
                            onPress: (){
                              context.read<FirebreathingCubit>().setToogleSaveDialog();
                            }
                          )
                        ),
                    
                        SizedBox(height: height*0.03,),
                      ],
                    ),
                  ),
                ],
              ),

              //~ open dialog for save
              BlocBuilder<FirebreathingCubit, FirebreathingState>(
                buildWhen: (previous, current) => current is FirebreathingInitial || current is FirebreathingToggleSave,
                builder: (context, state) {
                  if(context.read<FirebreathingCubit>().isSaveDialogOn){
                    return Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.black.withOpacity(.3),
                        child: SaveCustomDialogBoxWidget(
                          controller: context.read<FirebreathingCubit>().saveInputCont,
                          onClose: (){
                            context.read<FirebreathingCubit>().onCloseDialogClick();
                          },
                          onSave: () {
                            context.read<FirebreathingCubit>().onSaveClick();
                          },
                        ),
                      ) 
                    );
                  }

                  return const SizedBox();
                }, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}