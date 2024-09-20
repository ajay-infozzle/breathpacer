import 'package:breathpacer/bloc/dna/dna_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:breathpacer/utils/constant/jerry_voice.dart';
import 'package:breathpacer/utils/custom_button.dart';
import 'package:breathpacer/view/breathPacer/widget/breathing_choices_widget.dart';
import 'package:breathpacer/view/breathPacer/widget/custom_radio_buttom.dart';
import 'package:breathpacer/view/breathPacer/widget/settings_dropdown_widget.dart';
import 'package:breathpacer/view/breathPacer/widget/settings_toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DnaSettingScreen extends StatefulWidget {
  const DnaSettingScreen({super.key, required this.subTitle});

  final String subTitle;

  @override
  State<DnaSettingScreen> createState() => _DnaSettingScreenState();
}

class _DnaSettingScreenState extends State<DnaSettingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late double size;
  late double height;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(_handleTabSelection);

    // context.read<DnaCubit>().
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
        if (context.read<DnaCubit>().isReatartEnable) {
          context.goNamed(RoutesName.homeScreen);
        }
        // else{
        //   context.pop();
        // }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
          child: Column(
            children: [
              AppBar(
                scrolledUnderElevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                leading: GestureDetector(
                  onTap: () {
                    if (context.read<DnaCubit>().isReatartEnable) {
                      context.goNamed(RoutesName.homeScreen);
                    } else {
                      context.pop();
                    }
                  },
                  child: const Icon(Icons.arrow_back_ios),
                ),
                title: const Text(
                  "DNA Breathing",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: size * 0.02,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size * 0.05),
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
                          radius: size * 0.12,
                          child: Image.asset("assets/images/dna_icon.png"),
                        ),
                      ),

                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: size * 0.04),
                        width: size,
                        child: Text(
                          widget.subTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: size * 0.04,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: size * 0.05,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: size * 0.05),
                        child: customTabBar(),
                      ),

                      SizedBox(
                        height: size * 0.05,
                      ),
                      Container(
                        width: size,
                        margin: EdgeInsets.only(
                            left: size * 0.05, right: size * 0.07),
                        child: BlocBuilder<DnaCubit, DnaState>(
                          buildWhen: (previous, current) =>
                              current is DnaInitial ||
                              current is DnaUpdateSetNumber,
                          builder: (context, state) {
                            return SettingsDropdownButton(
                              onSelected: (int selectedSet) {
                                context
                                    .read<DnaCubit>()
                                    .updateSetsNumber(selectedSet);
                              },
                              title: "Number of sets:",
                              selected: context.read<DnaCubit>().noOfSets,
                              options: context.read<DnaCubit>().setsList,
                            );
                          },
                        ),
                      ),

                      SizedBox(
                        height: size * 0.05,
                      ),
                      Container(
                        width: size,
                        margin: EdgeInsets.only(
                            left: size * 0.05, right: size * 0.07),
                        child: Text("Breathing approach:",
                            style: TextStyle(
                                fontSize: size * 0.047, color: Colors.white)),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: size * 0.05,
                            right: size * 0.07,
                            top: size * 0.02),
                        child: BlocBuilder<DnaCubit, DnaState>(
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RadioBoxButton(
                                  text: "No. of Breaths",
                                  groupValue: context
                                      .read<DnaCubit>()
                                      .breathingApproachGroupValue,
                                  value: "No. of Breaths",
                                  onChanged: (value) {
                                    context
                                        .read<DnaCubit>()
                                        .isTimeBreathingApproch = false;
                                    context
                                        .read<DnaCubit>()
                                        .updateBreathingApproach(value!);
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: size * 0.03),
                                  child: Text("or",
                                      style: TextStyle(
                                          fontSize: size * 0.047,
                                          color: Colors.white)),
                                ),
                                RadioBoxButton(
                                  text: "Time per set",
                                  groupValue: context
                                      .read<DnaCubit>()
                                      .breathingApproachGroupValue,
                                  value: "Time per set",
                                  onChanged: (value) {
                                    context
                                        .read<DnaCubit>()
                                        .isTimeBreathingApproch = true;
                                    context
                                        .read<DnaCubit>()
                                        .updateBreathingApproach(value!);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      SizedBox(
                        height: size * 0.05,
                      ),
                      BlocBuilder<DnaCubit, DnaState>(
                        builder: (context, state) {
                          if (context.read<DnaCubit>().isTimeBreathingApproch) {
                            return Container(
                              width: size,
                              margin: EdgeInsets.only(
                                  left: size * 0.05, right: size * 0.07),
                              child: BlocBuilder<DnaCubit, DnaState>(
                                buildWhen: (previous, current) =>
                                    current is DnaInitial ||
                                    current is DnaUpdateBreathTime,
                                builder: (context, state) {
                                  return SettingsDropdownButton(
                                    onSelected: (int selectedBreath) {
                                      context
                                          .read<DnaCubit>()
                                          .updateBreathTime(selectedBreath);
                                    },
                                    title: "Time per set:",
                                    selected:
                                        context.read<DnaCubit>().durationOfSet,
                                    options:
                                        context.read<DnaCubit>().durationsList,
                                    isTime: true,
                                  );
                                },
                              ),
                            );
                          }

                          return Container(
                            width: size,
                            margin: EdgeInsets.only(
                                left: size * 0.05, right: size * 0.07),
                            child: BlocBuilder<DnaCubit, DnaState>(
                              buildWhen: (previous, current) =>
                                  current is DnaInitial ||
                                  current is DnaUpdateBreathNumber,
                              builder: (context, state) {
                                return SettingsDropdownButton(
                                  onSelected: (int selectedBreath) {
                                    context
                                        .read<DnaCubit>()
                                        .updateBreathNumber(selectedBreath);
                                  },
                                  title: "Number of breaths per set:",
                                  selected: context.read<DnaCubit>().noOfBreath,
                                  options: context.read<DnaCubit>().breathList,
                                  isnumber: true,
                                );
                              },
                            ),
                          );
                        },
                      ),

                      Container(
                        width: size,
                        margin: EdgeInsets.only(
                            left: size * 0.05,
                            right: size * 0.05,
                            top: size * 0.05),
                        child: BlocBuilder<DnaCubit, DnaState>(
                          buildWhen: (previous, current) =>
                              current is DnaInitial ||
                              current is DnaToggleHolding,
                          builder: (context, state) {
                            return SettingsToggleButton(
                                onToggle: () {
                                  context.read<DnaCubit>().toggleHolding();
                                },
                                title: "Holding period after each set :",
                                isOn: context.read<DnaCubit>().holdingPeriod);
                          },
                        ),
                      ),

                      BlocBuilder<DnaCubit, DnaState>(
                        buildWhen: (previous, current) =>
                            current is DnaInitial ||
                            current is DnaToggleBreathHoldChoice ||
                            current is DnaToggleHolding,
                        builder: (context, state) {
                          if (!context.read<DnaCubit>().holdingPeriod) {
                            return const SizedBox();
                          }
                          return Container(
                            width: size,
                            margin: EdgeInsets.only(
                                left: size * 0.05,
                                right: size * 0.07,
                                top: size * 0.05),
                            child: SettingsDropdownButton(
                              onSelected: (int selected) {
                                context.read<DnaCubit>().updateHold(selected);
                              },
                              title: "Breath hold duration:",
                              selected: context.read<DnaCubit>().holdDuration,
                              options:
                                  context.read<DnaCubit>().holdDurationList,
                              isTime: true,
                            ),
                          );
                        },
                      ),

                      BlocBuilder<DnaCubit, DnaState>(
                        buildWhen: (previous, current) =>
                            current is DnaInitial ||
                            current is DnaToggleBreathHoldChoice ||
                            current is DnaToggleHolding,
                        builder: (context, state) {
                          if (!context.read<DnaCubit>().holdingPeriod) {
                            return const SizedBox();
                          }
                          return Container(
                            width: size,
                            margin: EdgeInsets.only(
                                left: size * 0.05,
                                right: size * 0.05,
                                top: size * 0.03),
                            child: BreathingChoices(
                              chosenItem:
                                  context.read<DnaCubit>().breathHoldIndex,
                              choicesList:
                                  context.read<DnaCubit>().breathHoldList,
                              onUpdateChoiceIndex: (int index) {
                                context
                                    .read<DnaCubit>()
                                    .toggleBreathHold(index);
                              },
                              onUpdateVoiceOver: (JerryVoiceEnum audio) {
                                context.read<DnaCubit>().changeJerryVoiceAudio(
                                    jerryVoiceOver(audio));
                              },
                            ),
                          );
                        },
                      ),

                      // Container(
                      //   width: size,
                      //   margin: EdgeInsets.only(left: size*0.05, right: size*0.07, top: size*0.05),
                      //   child: BlocBuilder<DnaCubit, DnaState>(
                      //     buildWhen: (previous, current) => current is DnaInitial || current is DnaHoldDurationUpdate,
                      //     builder: (context, state) {
                      //       return SettingsDropdownButton(
                      //         onSelected: (int selected) {
                      //           context.read<DnaCubit>().updateHold(selected);
                      //         },
                      //         title: "Hold time:",
                      //         selected: context.read<DnaCubit>().holdDuration,
                      //         options: context.read<DnaCubit>().holdDurationList,
                      //         isTime: true,
                      //       );
                      //     },
                      //   ),
                      // ),

                      SizedBox(
                        height: size * 0.03,
                      ),
                      Container(
                        width: size,
                        margin: EdgeInsets.symmetric(horizontal: size * 0.05),
                        child: BlocBuilder<DnaCubit, DnaState>(
                          buildWhen: (previous, current) =>
                              current is DnaInitial ||
                              current is DnaToggleRecoveryBreath,
                          builder: (context, state) {
                            return SettingsToggleButton(
                                onToggle: () {
                                  context
                                      .read<DnaCubit>()
                                      .toggleRecoveryBreath();
                                },
                                title: "Recovery breath after each set :",
                                isOn: context.read<DnaCubit>().recoveryBreath);
                          },
                        ),
                      ),

                      BlocBuilder<DnaCubit, DnaState>(
                        builder: (context, state) {
                          if (context.read<DnaCubit>().recoveryBreath) {
                            return Container(
                              width: size,
                              margin: EdgeInsets.only(
                                  left: size * 0.05,
                                  right: size * 0.07,
                                  top: size * 0.05),
                              child: SettingsDropdownButton(
                                onSelected: (int selected) {
                                  context
                                      .read<DnaCubit>()
                                      .updateRecoveryDuration(selected);
                                },
                                title: "Recovery breath duration:",
                                selected: context
                                    .read<DnaCubit>()
                                    .recoveryBreathDuration,
                                options: context
                                    .read<DnaCubit>()
                                    .recoveryDurationList,
                                isTime: true,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),

                      SizedBox(
                        height: size * 0.03,
                      ),
                      Container(
                        width: size,
                        margin: EdgeInsets.symmetric(horizontal: size * 0.05),
                        child: BlocBuilder<DnaCubit, DnaState>(
                          buildWhen: (previous, current) =>
                              current is DnaInitial ||
                              current is DnaToggleJerryVoice,
                          builder: (context, state) {
                            return SettingsToggleButton(
                                onToggle: () {
                                  context.read<DnaCubit>().toggleJerryVoice();
                                },
                                title: "Jerry's voice :",
                                isOn: context.read<DnaCubit>().jerryVoice);
                          },
                        ),
                      ),

                      // SizedBox(height: size*0.03,),
                      // Container(
                      //   width: size,
                      //   margin: EdgeInsets.only(left: size*0.1, right: size*0.05),
                      //   child: BlocBuilder<DnaCubit, DnaState>(
                      //     buildWhen: (previous, current) => current is DnaInitial || current is DnaTogglePineal,
                      //     builder: (context, state) {
                      //       return SettingsToggleButton(
                      //         onToggle: () {
                      //           context.read<DnaCubit>().togglePineal();
                      //         },
                      //         title: "Pineal Gland :",
                      //         isOn: context.read<DnaCubit>().pineal
                      //       );
                      //     },
                      //   ),
                      // ),

                      SizedBox(
                        height: size * 0.03,
                      ),
                      Container(
                        width: size,
                        margin: EdgeInsets.symmetric(horizontal: size * 0.05),
                        child: BlocBuilder<DnaCubit, DnaState>(
                          buildWhen: (previous, current) =>
                              current is DnaInitial ||
                              current is DnaToggleMusic,
                          builder: (context, state) {
                            return SettingsToggleButton(
                                onToggle: () {
                                  context.read<DnaCubit>().toggleMusic();
                                },
                                title: "Music :",
                                isOn: context.read<DnaCubit>().music);
                          },
                        ),
                      ),

                      SizedBox(
                        height: size * 0.03,
                      ),
                      Container(
                        width: size,
                        margin: EdgeInsets.symmetric(horizontal: size * 0.05),
                        child: BlocBuilder<DnaCubit, DnaState>(
                          buildWhen: (previous, current) =>
                              current is DnaInitial ||
                              current is DnaToggleChimes,
                          builder: (context, state) {
                            return SettingsToggleButton(
                                onToggle: () {
                                  context.read<DnaCubit>().toggleChimes();
                                },
                                title: "Chimes at start / stop points :",
                                isOn: context.read<DnaCubit>().chimes);
                          },
                        ),
                      ),

                      // SizedBox(height: size*0.03,),
                      // Container(
                      //   width: size,
                      //   margin: EdgeInsets.symmetric(horizontal: size*0.05),
                      //   child: BlocBuilder<DnaCubit, DnaState>(
                      //     buildWhen: (previous, current) => current is DnaInitial || current is DnaToggleBreathHoldChoice,
                      //     builder: (context, state) {
                      //       return BreathingChoices(
                      //         chosenItem: context.read<DnaCubit>().breathHoldIndex,
                      //         choicesList: context.read<DnaCubit>().breathHoldList,
                      //         onUpdateChoiceIndex: (int index) {
                      //           context.read<DnaCubit>().toggleBreathHold(index);
                      //         },
                      //         onUpdateVoiceOver: (JerryVoiceEnum audio) {
                      //           context.read<DnaCubit>().changeJerryVoiceAudio(jerryVoiceOver(audio));
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),

                      Container(
                        margin: EdgeInsets.only(
                            top: size * 0.09,
                            bottom: size * 0.06,
                            right: size * 0.05,
                            left: size * 0.05),
                        height: 48,
                        // child: CustomButton(
                        //   title: "Start",
                        //   height: 48,
                        //   spacing: .7,
                        //   radius: 10,
                        //   onPress: (){
                        //     // context.read<DnaCubit>().playMusic();

                        //     // context.pushNamed(
                        //     //   RoutesName.DnaWaitingScreen,
                        //     // );
                        //   }
                        // )
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: size * 0.09,
                      ),
                      child: BlocConsumer<DnaCubit, DnaState>(
                        listener: (context, state) {
                          if(state is NavigateToWaitingScreen){
                            context.pushNamed(
                              RoutesName.dnaWaitingScreen,
                            );
                          }
                        },
                        builder: (context, state) {
                          return CustomButton(
                              title: "Start",
                              textsize: size * 0.043,
                              height: height * 0.062,
                              spacing: .7,
                              radius: 0,
                              onPress: () {
                                context.read<DnaCubit>().playMusic();
                                context.read<DnaCubit>().playCloseEyes();
                              }
                          );
                        },
                      )
                    ),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  customTabBar() {
    return Container(
      margin: EdgeInsets.only(top: size * 0.03),
      padding:
          EdgeInsets.symmetric(horizontal: size * 0.01, vertical: size * 0.01),
      height: size * 0.13,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size * 0.02)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
                onTap: () {
                  _tabController.index = 0;
                  context.read<DnaCubit>().speed = "Slow";
                },
                child: Container(
                  alignment: Alignment.center,
                  width: size,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                      color: _tabController.index == 0
                          ? AppTheme.colors.blueSlider
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(size * 0.015)),
                  child: Text(
                    "Slow",
                    style: TextStyle(
                        color: _tabController.index == 0
                            ? Colors.white
                            : AppTheme.colors.blueSlider,
                        fontWeight: FontWeight.bold,
                        fontSize: size * 0.039),
                  ),
                )),
          ),
          Expanded(
            child: GestureDetector(
                onTap: () {
                  _tabController.index = 1;
                  context.read<DnaCubit>().speed = "Standard";
                },
                child: Container(
                  alignment: Alignment.center,
                  width: size,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                      color: _tabController.index == 1
                          ? AppTheme.colors.blueSlider
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(size * 0.015)),
                  child: Text(
                    "Standard",
                    style: TextStyle(
                        color: _tabController.index == 1
                            ? Colors.white
                            : AppTheme.colors.blueSlider,
                        fontWeight: FontWeight.bold,
                        fontSize: size * 0.039),
                  ),
                )),
          ),
          Expanded(
            child: GestureDetector(
                onTap: () {
                  _tabController.index = 2;
                  context.read<DnaCubit>().speed = "Fast";
                },
                child: Container(
                  alignment: Alignment.center,
                  width: size,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                      color: _tabController.index == 2
                          ? AppTheme.colors.blueSlider
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(size * 0.015)),
                  child: Text(
                    "Fast",
                    style: TextStyle(
                        color: _tabController.index == 2
                            ? Colors.white
                            : AppTheme.colors.blueSlider,
                        fontWeight: FontWeight.bold,
                        fontSize: size * 0.039),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
