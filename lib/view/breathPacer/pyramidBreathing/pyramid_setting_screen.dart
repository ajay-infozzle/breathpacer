import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:breathpacer/utils/constant/jerry_voice.dart';
import 'package:breathpacer/utils/custom_button.dart';
import 'package:breathpacer/view/breathPacer/widget/breathing_choices_widget.dart';
import 'package:breathpacer/view/breathPacer/widget/settings_toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PyramidSettingScreen extends StatefulWidget {
  const PyramidSettingScreen({super.key, required this.step});
  
  final String step;

  @override
  State<PyramidSettingScreen> createState() => _PyramidSettingScreenState();
}

class _PyramidSettingScreenState extends State<PyramidSettingScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late double size;
  late double height;


  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(_handleTabSelection);

    context.read<PyramidCubit>().initialSettings(widget.step, "Standard");
  }

  void _handleTabSelection() {
    setState(() {});  
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size.width ;
    height = MediaQuery.of(context).size.height ;
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if(context.read<PyramidCubit>().isReatartEnable){
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
                scrolledUnderElevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                leading: GestureDetector(
                  onTap: (){
                    if(context.read<PyramidCubit>().isReatartEnable){
                      context.goNamed(RoutesName.homeScreen);
                    }
                    else{
                      context.pop();
                    }
                  },
                  child: const Icon(Icons.arrow_back_ios),
                ),
                title: const Text(
                  "Pyramid Breathing",
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
                        child: Image.asset("assets/images/pyramid_icon.png"),
                      ),
                    ),
      
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: size*0.04),
                      width: size,
                      child: Text(
                        "${widget.step} step",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: size*0.04,
                        ),
                      ),
                    ),
      
                    SizedBox(height: size*0.05,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      child: customTabBar(),
                    ),
                    
      
                    SizedBox(height: size*0.06,),
                    Container(
                      width: size,
                      margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      child: BlocBuilder<PyramidCubit, PyramidState>(
                        buildWhen: (previous, current) => current is PyramidToggleJerryVoice || current is PyramidInitial,
                        builder: (context, state) {
                          return SettingsToggleButton(
                            onToggle: () {
                              context.read<PyramidCubit>().toggleJerryVoice();
                            }, 
                            title: "Jerry's voice :", 
                            isOn: context.read<PyramidCubit>().jerryVoice
                          );
                        }, 
                      ),
                    ),
      
                    SizedBox(height: size*0.03,),
                    Container(
                      width: size,
                      margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      child: BlocBuilder<PyramidCubit, PyramidState>(
                        buildWhen: (previous, current) => current is PyramidInitial || current is PyramidToggleMusic,
                        builder:  (context, state) => SettingsToggleButton(
                          onToggle: () {
                            context.read<PyramidCubit>().toggleMusic();
                          }, 
                          title: "Music :", 
                          isOn: context.read<PyramidCubit>().music
                        ),
                      ),
                    ),
      
                    SizedBox(height: size*0.03,),
                    Container(
                      width: size,
                      margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      child: BlocBuilder<PyramidCubit, PyramidState>(
                          buildWhen: (previous, current) => current is PyramidInitial || current is PyramidToggleChimes,
                          builder: (context, state) => SettingsToggleButton(
                          onToggle: () {
                            context.read<PyramidCubit>().toggleChimes();
                          }, 
                          title: "Chimes at start / stop points :", 
                          isOn: context.read<PyramidCubit>().chimes
                        ), 
                      ),
                    ),
      
                    SizedBox(height: size*0.03,),
                    Container(
                      width: size,
                      margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      child: BlocBuilder<PyramidCubit, PyramidState>(
                        buildWhen: (previous, current) => current is PyramidInitial || current is PyramidToggleBreathHold,
                        builder: (context, state) {
                          return BreathingChoices(
                            chosenItem: context.read<PyramidCubit>().breathHoldIndex, 
                            choicesList: context.read<PyramidCubit>().breathHoldList,
                            onUpdateChoiceIndex: (int index) {
                              context.read<PyramidCubit>().toggleBreathHold(index);
                            }, 
                            onUpdateVoiceOver: (JerryVoiceEnum audio) {
                              context.read<PyramidCubit>().changeJerryVoiceAudio(jerryVoiceOver(audio));
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
                          context.read<PyramidCubit>().playMusic();
                          context.read<PyramidCubit>().playCloseEyes();

                          context.pushNamed(
                            RoutesName.pyramidWaitingScreen,
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

  customTabBar() {
    return Container(
      margin: EdgeInsets.only(top: size*0.03),
      padding: EdgeInsets.symmetric(horizontal: size*0.01,vertical: size*0.01),
      height: size*0.13,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size*0.02)
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                _tabController.index = 0 ;
                context.read<PyramidCubit>().speed = "Slow" ;
              },
              child: Container(
                alignment: Alignment.center,
                width: size,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  color: _tabController.index == 0 ?AppTheme.colors.blueSlider: Colors.transparent,
                  borderRadius: BorderRadius.circular(size*0.015)
                ),
                child: Text(
                  "Slow",
                  style: TextStyle(
                    color: _tabController.index == 0 ?Colors.white: AppTheme.colors.blueSlider,
                    fontWeight: FontWeight.bold,
                    fontSize: size*0.039
                  ),
                ),
              )
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _tabController.index = 1 ;
                context.read<PyramidCubit>().speed = "Standard" ;
              },
              child: Container(
                alignment: Alignment.center,
                width: size,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  color: _tabController.index == 1 ? AppTheme.colors.blueSlider: Colors.transparent,
                  borderRadius: BorderRadius.circular(size*0.015)
                ),
                child: Text(
                  "Standard",
                  style: TextStyle(
                    color: _tabController.index == 1 ?Colors.white: AppTheme.colors.blueSlider,
                    fontWeight: FontWeight.bold,
                    fontSize: size*0.039
                  ),
                ),
              )
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _tabController.index = 2 ;
                context.read<PyramidCubit>().speed = "Fast" ;
              },
              child: Container(
                alignment: Alignment.center,
                width: size,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  color: _tabController.index == 2 ? AppTheme.colors.blueSlider: Colors.transparent,
                  borderRadius: BorderRadius.circular(size*0.015)
                ),
                child: Text(
                  "Fast",
                  style: TextStyle(
                    color: _tabController.index == 2 ?Colors.white: AppTheme.colors.blueSlider,
                    fontWeight: FontWeight.bold,
                    fontSize: size*0.039
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}