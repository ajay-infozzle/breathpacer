import 'package:breathpacer/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:breathpacer/utils/custom_button.dart';
import 'package:breathpacer/view/breathPacer/widget/settings_dropdown_widget.dart';
import 'package:breathpacer/view/breathPacer/widget/settings_toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PinealSettingScreen extends StatelessWidget {
  const PinealSettingScreen({super.key, required this.subTitle});
  
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width ;
    final height = MediaQuery.of(context).size.height ;
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if(context.read<PinealCubit>().isReatartEnable){
          context.goNamed(RoutesName.homeScreen);
        }
        // else{
        //   context.pop();
        // }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.colors.linearGradient
          ),
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                leading: GestureDetector(
                   onTap: (){
                    if(context.read<PinealCubit>().isReatartEnable){
                      context.goNamed(RoutesName.homeScreen);
                    }
                    else{
                      context.pop();
                    }
                  },
                  child: const Icon(Icons.arrow_back_ios),
                ),
                title: const Text(
                  "Pineal Gland Activation",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: size*0.02,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size*0.05),
                color: Colors.white.withOpacity(.3),
                height: 1,
              ),
      
              //~
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ListView(
                      children: [
                        SizedBox(
                          width: size,
                          child: CircleAvatar(
                            radius: size*0.12,
                            child: Image.asset("assets/images/pineal_icon.png"),
                          ),
                        ),
                          
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: size*0.04),
                          width: size,
                          child: Text(
                            subTitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: size*0.04,
                            ),
                          ),
                        ),

                        SizedBox(height: size*0.05,),
                        Container(
                          width: size,
                          margin: EdgeInsets.only(left: size*0.05, right: size*0.07),
                          child: BlocBuilder<PinealCubit, PinealState>(
                            buildWhen: (previous, current) => current is PinealInitial || current is PinealBreathingUpdate,
                            builder: (context, state) {
                              return SettingsDropdownButton(
                                onSelected: (int selected) {
                                  context.read<PinealCubit>().updateBreathing(selected);
                                },
                                title: "Breathing Period:",
                                selected: context.read<PinealCubit>().breathingPeriod, 
                                options: context.read<PinealCubit>().breathingDurationList, 
                                isTime: true,
                              );
                            }, 
                          ),
                        ),


                        SizedBox(height: size*0.05,),
                        Container(
                          width: size,
                          margin: EdgeInsets.only(left: size*0.05, right: size*0.07),
                          child: BlocBuilder<PinealCubit, PinealState>(
                            buildWhen: (previous, current) => current is PinealInitial || current is PinealHoldUpdate,
                            builder: (context, state) {
                              return SettingsDropdownButton(
                                onSelected: (int selected) {
                                  context.read<PinealCubit>().updateHold(selected);
                                },
                                title: "Hold time:",
                                selected: context.read<PinealCubit>().holdDuration, 
                                options: context.read<PinealCubit>().holdDurationList, 
                                isTime: true,
                              );
                            }, 
                          ),
                        ),


                        SizedBox(height: size*0.05,),
                        Container(
                          width: size,
                          margin: EdgeInsets.only(left: size*0.05, right: size*0.07),
                          child: BlocBuilder<PinealCubit, PinealState>(
                            buildWhen: (previous, current) => current is PinealInitial || current is PinealRecoveryUpdate,
                            builder: (context, state) {
                              return SettingsDropdownButton(
                                onSelected: (int selected) {
                                  context.read<PinealCubit>().updateRecovery(selected);
                                },
                                title: "Recovery breath duration:",
                                selected: context.read<PinealCubit>().recoveryBreathDuration, 
                                options: context.read<PinealCubit>().recoveryDurationList, 
                                isTime: true,
                              );
                            }, 
                          ),
                        ),


                        SizedBox(height: size*0.03,),
                        Container(
                          width: size,
                          margin: EdgeInsets.symmetric(horizontal: size*0.05),
                          child: BlocBuilder<PinealCubit, PinealState>(
                            buildWhen: (previous, current) => current is PinealInitial || current is PinealToggleJerryVoice,
                            builder: (context, state) {
                              return SettingsToggleButton(
                                onToggle: () {
                                  context.read<PinealCubit>().toggleJerryVoice();
                                }, 
                                title: "Jerry's voice :", 
                                isOn: context.read<PinealCubit>().jerryVoice
                              );
                            }, 
                          ),
                        ),


                        SizedBox(height: size*0.03,),
                        Container(
                          width: size,
                          margin: EdgeInsets.symmetric(horizontal: size*0.05),
                          child: BlocBuilder<PinealCubit, PinealState>(
                            buildWhen: (previous, current) => current is PinealInitial || current is PinealToggleMusic,
                            builder: (context, state) {
                              return SettingsToggleButton(
                                onToggle: () {
                                  context.read<PinealCubit>().toggleMusic();
                                }, 
                                title: "Music :", 
                                isOn: context.read<PinealCubit>().music
                              );
                            }, 
                          ),
                        ),
                    
                        SizedBox(height: size*0.03,),
                        Container(
                          width: size,
                          margin: EdgeInsets.symmetric(horizontal: size*0.05),
                          child: BlocBuilder<PinealCubit, PinealState>(
                            buildWhen: (previous, current) => current is PinealInitial || current is PinealToggleChimes,
                            builder: (context, state) {
                              return SettingsToggleButton(
                                onToggle: () {
                                  context.read<PinealCubit>().toggleChimes();
                                }, 
                                title: "Chimes at start / stop points :", 
                                isOn: context.read<PinealCubit>().chimes
                              );
                            }, 
                          ),
                        ),

                      ],
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.only(top: size*0.09,),
                        child: CustomButton(
                          title: "Start", 
                          textsize: size*0.043,
                          height: height*0.062,
                          spacing: .7,
                          radius: 0,
                          onPress: (){
                            context.read<PinealCubit>().playMusic();
                            context.read<PinealCubit>().playCloseEyes();
                            
                            context.pushNamed(
                              RoutesName.pinealWaitingScreen,
                            );
                          }
                        )
                      ),
                    )
                  ],
                ) 
              ),
            ],
          ),
        ),
      ),
    );
  }
}