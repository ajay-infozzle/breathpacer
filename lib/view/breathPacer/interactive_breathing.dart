import 'package:breathpacer/bloc/dna/dna_cubit.dart';
import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer/view/breathPacer/widget/interactive_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_faq/flutter_easy_faq.dart';
import 'package:go_router/go_router.dart';

class InteractiveBreathingScreen extends StatefulWidget {
  const InteractiveBreathingScreen({super.key});

  @override
  State<InteractiveBreathingScreen> createState() => _InteractiveBreathingScreenState();
}

class _InteractiveBreathingScreenState extends State<InteractiveBreathingScreen> {

  @override
  void initState() {
    super.initState();

    context.read<PyramidCubit>().getAllSavedPyramidBreathwork();
    context.read<FirebreathingCubit>().getAllSavedFireBreathwork();
    context.read<DnaCubit>().getAllSavedDnaBreathwork();
    context.read<PinealCubit>().getAllSavedPinealBreathwork();
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width ;    

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.goNamed(RoutesName.disclamerScreen);
      },
      child: Scaffold(
        // appBar: AppBar(
        //   iconTheme: const IconThemeData(color: Colors.white),
        //   backgroundColor: AppTheme.colors.appBarColor,
        //   centerTitle: true,
        //   title: const Text(
        //     "Interactive Breathing",
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
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
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: const Text(
                  "Interactive Breathing",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                leading: GestureDetector(
                  onTap: (){ 
                    context.goNamed(RoutesName.disclamerScreen);
                  },
                  child: const Icon(Icons.arrow_back_ios_rounded,color: Colors.white,),
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
                  padding: const EdgeInsets.all(0),
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: size*0.05, left: size*0.05),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsetsDirectional.all(0),
                        itemCount: interactionOptions.length+1,
                        itemBuilder: (context, index) {
                          if(index == interactionOptions.length){
                            return SizedBox(height: size*0.06,);
                          }
                          return InteractiveContainerWidget(
                            index: index,
                            title: interactionOptions[index]["title"]!, 
                            image: interactionOptions[index]["image"]!, 
                            description: interactionOptions[index]["description"]!,
                            onTap: (){
                              if(index == 0){
                                context.pushNamed(RoutesName.breathingStepGuideScreen);
                              }
                              if(index == 1){
                                context.pushNamed(RoutesName.fireInstructionScreen);
                              }
                              if(index == 2){
                                context.pushNamed(RoutesName.dnaInstructionScreen);
                              }
                              if(index == 3){
                                context.pushNamed(RoutesName.pinealInstructionScreen);
                              }
                            }, 
                          );
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(right: size*0.05, left: size*0.05, top: size*0.03),
                      child: Column(
                        children: [
                          SizedBox(
                            width: size,
                            child: Text(
                              "Frequently Asked Questions",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: size*0.05
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),

                          SizedBox(height: size*0.03,),
                          ListView.builder(
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: faq.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: size*0.03),
                                child: EasyFaq(
                                  backgroundColor: Colors.white,
                                  collapsedIcon: const Icon(Icons.arrow_drop_down_rounded),
                                  expandedIcon: const Icon(Icons.arrow_drop_up_rounded),
                                  questionTextStyle: TextStyle(
                                    color: Colors.black.withOpacity(.7),
                                    fontWeight: FontWeight.bold,
                                    fontSize: size*0.042
                                  ),
                                  anserTextStyle: TextStyle(
                                    color: Colors.black.withOpacity(.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: size*0.038
                                  ),
                                  question: faq[index]["ques"]!, 
                                  answer: faq[index]["ans"]!
                                ),
                              );
                            }, 
                          ),
                          SizedBox(height: size*0.03,),
                        ],
                      ),
                    ),
                  ],
                ), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}