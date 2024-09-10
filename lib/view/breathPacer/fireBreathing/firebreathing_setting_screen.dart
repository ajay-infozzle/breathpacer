import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:breathpacer/utils/constant/jerry_voice.dart';
import 'package:breathpacer/utils/custom_button.dart';
import 'package:breathpacer/view/breathPacer/widget/breathing_choices_widget.dart';
import 'package:breathpacer/view/breathPacer/widget/settings_dropdown_widget.dart';
import 'package:breathpacer/view/breathPacer/widget/settings_toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FirebreathingSettingScreen extends StatelessWidget {
  const FirebreathingSettingScreen({super.key, required this.subTitle});
  
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width ;
    final height = MediaQuery.of(context).size.height ;
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if(context.read<FirebreathingCubit>().isReatartEnable){
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
                scrolledUnderElevation: 0,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.arrow_back_ios),
                ),
                title: const Text(
                  "Fire Breathing",
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
                child: ListView(
                  children: [
                    SizedBox(
                      width: size,
                      child: CircleAvatar(
                        radius: size*0.12,
                        child: Image.asset("assets/images/fire_icon.png"),
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

                    SizedBox(height: size*0.06,),
                    Container(
                      width: size,
                      margin: EdgeInsets.only(left: size*0.05, right: size*0.07),
                      child: BlocBuilder<FirebreathingCubit, FirebreathingState>(
                        buildWhen: (previous, current) => current is FirebreathingInitial || current is FirebreathingUpdateSetDuration,
                        builder: (context, state) {
                          return SettingsDropdownButton(
                            onSelected: (int selectedDuration) {
                              context.read<FirebreathingCubit>().updateSetsDuration(selectedDuration);
                            },
                            title: "Duration of set:",
                            selected: context.read<FirebreathingCubit>().durationOfSets, 
                            options: context.read<FirebreathingCubit>().durationsList, 
                            isTime: true,
                          );
                        }, 
                      ),
                    ),


                    SizedBox(height: size*0.05,),
                    Container(
                      width: size,
                      margin: EdgeInsets.only(left: size*0.05, right: size*0.07),
                      child: BlocBuilder<FirebreathingCubit, FirebreathingState>(
                        buildWhen: (previous, current) => current is FirebreathingInitial || current is FirebreathingUpdateSetNumber,
                        builder: (context, state) {
                          return SettingsDropdownButton(
                            onSelected: (int selectedSet) {
                              context.read<FirebreathingCubit>().updateSetsNumber(selectedSet);
                            },
                            title: "Number of sets:",
                            selected: context.read<FirebreathingCubit>().noOfSets, 
                            options: context.read<FirebreathingCubit>().setsList, 
                          );
                        }, 
                      ),
                    ),


                    SizedBox(height: size*0.03,),
                    Container(
                      width: size,
                      margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      child: BlocBuilder<FirebreathingCubit, FirebreathingState>(
                        buildWhen: (previous, current) => current is FirebreathingInitial || current is FirebreathingToggleRecoveryBreath,
                        builder: (context, state) {
                          return SettingsToggleButton(
                            onToggle: () {
                              context.read<FirebreathingCubit>().toggleRecoveryBreath();
                            }, 
                            title: "Recovery breath after each set :", 
                            isOn: context.read<FirebreathingCubit>().recoveryBreath
                          );
                        }, 
                      ),
                    ),


                    SizedBox(height: size*0.03,),
                    Container(
                      width: size,
                      margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      child: BlocBuilder<FirebreathingCubit, FirebreathingState>(
                        buildWhen: (previous, current) => current is FirebreathingInitial || current is FirebreathingToggleHolding,
                        builder: (context, state) {
                          return SettingsToggleButton(
                            onToggle: () {
                              context.read<FirebreathingCubit>().toggleHolding();
                            }, 
                            title: "Holding period after each set :", 
                            isOn: context.read<FirebreathingCubit>().holdingPeriod
                          );
                        }, 
                      ),
                    ),


                    SizedBox(height: size*0.03,),
                    Container(
                      width: size,
                      margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      child: BlocBuilder<FirebreathingCubit, FirebreathingState>(
                        buildWhen: (previous, current) => current is FirebreathingInitial || current is FirebreathingToggleJerryVoice,
                        builder: (context, state) {
                          return SettingsToggleButton(
                            onToggle: () {
                              context.read<FirebreathingCubit>().toggleJerryVoice();
                            }, 
                            title: "Jerry's voice :", 
                            isOn: context.read<FirebreathingCubit>().jerryVoice
                          );
                        }, 
                      ),
                    ),


                    SizedBox(height: size*0.03,),
                    Container(
                      width: size,
                      margin: EdgeInsets.only(left: size*0.1, right: size*0.05),
                      child: BlocBuilder<FirebreathingCubit, FirebreathingState>(
                        buildWhen: (previous, current) => current is FirebreathingInitial || current is FirebreathingTogglePineal,
                        builder: (context, state) {
                          return SettingsToggleButton(
                            onToggle: () {
                              context.read<FirebreathingCubit>().togglePineal();
                            }, 
                            title: "Pineal Gland :", 
                            isOn: context.read<FirebreathingCubit>().pineal
                          );
                        }, 
                      ),
                    ),


                    SizedBox(height: size*0.03,),
                    Container(
                      width: size,
                      margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      child: BlocBuilder<FirebreathingCubit, FirebreathingState>(
                        buildWhen: (previous, current) => current is FirebreathingInitial || current is FirebreathingToggleMusic,
                        builder: (context, state) {
                          return SettingsToggleButton(
                            onToggle: () {
                              context.read<FirebreathingCubit>().toggleMusic();
                            }, 
                            title: "Music :", 
                            isOn: context.read<FirebreathingCubit>().music
                          );
                        }, 
                      ),
                    ),


                    SizedBox(height: size*0.03,),
                    Container(
                      width: size,
                      margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      child: BlocBuilder<FirebreathingCubit, FirebreathingState>(
                        buildWhen: (previous, current) => current is FirebreathingInitial || current is FirebreathingToggleChimes,
                        builder: (context, state) {
                          return SettingsToggleButton(
                            onToggle: () {
                              context.read<FirebreathingCubit>().toggleChimes();
                            }, 
                            title: "Chimes at start / stop points :", 
                            isOn: context.read<FirebreathingCubit>().chimes
                          );
                        }, 
                      ),
                    ),

                    SizedBox(height: size*0.03,),
                    Container(
                      width: size,
                      margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      child: BlocBuilder<FirebreathingCubit, FirebreathingState>(
                        buildWhen: (previous, current) => current is FirebreathingInitial || current is FirebreathingToggleBreathHoldChoice,
                        builder: (context, state) {
                          return BreathingChoices(
                            chosenItem: context.read<FirebreathingCubit>().breathHoldIndex, 
                            choicesList: context.read<FirebreathingCubit>().breathHoldList,
                            onUpdateChoiceIndex: (int index) {
                              context.read<FirebreathingCubit>().toggleBreathHold(index);
                            }, 
                            onUpdateVoiceOver: (JerryVoiceEnum audio) {
                              context.read<FirebreathingCubit>().changeJerryVoiceAudio(jerryVoiceOver(audio));
                            },
                          );
                        }, 
                      ),
                    ),
                    
                    Container(
                      margin: EdgeInsets.only(top: size*0.09,bottom: size*0.09, right: size*0.05, left: size*0.05),
                      child: CustomButton(
                        title: "Start", 
                        height: 48,
                        spacing: .7,
                        radius: 10,
                        onPress: (){
                          context.read<FirebreathingCubit>().playMusic();
                          
                          context.pushNamed(
                            RoutesName.fireBreathingWaitingScreen,
                          );
                        }
                      )
                    ),
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