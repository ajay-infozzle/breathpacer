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

    return Scaffold(
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
              centerTitle: true,
              title: const Text(
                "Interactive Breathing",
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
              child: Container(
                margin: EdgeInsets.only(right: size*0.05, left: size*0.05),
                child: ListView.builder(
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
            ),
          ],
        ),
      ),
    );
  }
}