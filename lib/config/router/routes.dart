import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/view/breathPacer/dnaBreathing/dna_instruction_screen.dart';
import 'package:breathpacer/view/breathPacer/dnaBreathing/dna_setting_screen.dart';
import 'package:breathpacer/view/breathPacer/fireBreathing/firebreathing_instruction_screen.dart';
import 'package:breathpacer/view/breathPacer/fireBreathing/firebreathing_setting_screen.dart';
import 'package:breathpacer/view/breathPacer/interactive_breathing.dart';
import 'package:breathpacer/view/breathPacer/pinealGlandActivation/pineal_instruction_screen.dart';
import 'package:breathpacer/view/breathPacer/pinealGlandActivation/pineal_setting_screen.dart';
import 'package:breathpacer/view/breathPacer/pyramidBreathing/breathing_step_guide_screen.dart';
import 'package:breathpacer/view/breathPacer/pyramidBreathing/pyramid_breath_hold_screen.dart';
import 'package:breathpacer/view/breathPacer/pyramidBreathing/pyramid_breathing_screen.dart';
import 'package:breathpacer/view/breathPacer/pyramidBreathing/pyramid_instruction_screen.dart';
import 'package:breathpacer/view/breathPacer/pyramidBreathing/pyramid_setting_screen.dart';
import 'package:breathpacer/view/breathPacer/pyramidBreathing/pyramid_success_screen.dart';
import 'package:breathpacer/view/breathPacer/pyramidBreathing/pyramid_waiting_screen.dart';
import 'package:breathpacer/view/home/home_screen.dart';
import 'package:breathpacer/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        name: RoutesName.splashScreen,
        builder: (context, state) => const SplashScreen(),
        routes: [
          
          GoRoute(
            path: RoutesName.homeScreen,
            name: RoutesName.homeScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const HomeScreen(), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.interactiveBreathingScreen,
            name: RoutesName.interactiveBreathingScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const InteractiveBreathingScreen(), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.breathingStepGuideScreen,
            name: RoutesName.breathingStepGuideScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const BreathingStepGuideScreen(), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.pyramidInstructionScreen,
            name: RoutesName.pyramidInstructionScreen,
            pageBuilder: (context, state) {
              Map<String, String> parameters = state.uri.queryParameters ;
              return customPageRouteBuilder(
                PyramidInstructionScreen(
                  description: parameters["desc"]!,
                  subTitle: parameters["subTitle"]!,
                ), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.pyramidSettingScreen,
            name: RoutesName.pyramidSettingScreen,
            pageBuilder: (context, state) {
              dynamic parameters = state.extra ;
              return customPageRouteBuilder(
                PyramidSettingScreen(
                  step: parameters["step"]!,
                ), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.pyramidWaitingScreen,
            name: RoutesName.pyramidWaitingScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const PyramidWaitingScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.pyramidBreathingScreen,
            name: RoutesName.pyramidBreathingScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const PyramidBreathingScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.pyramidBreathHoldScreen,
            name: RoutesName.pyramidBreathHoldScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const PyramidBreathHoldScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.pyramidSuccessScreen,
            name: RoutesName.pyramidSuccessScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const PyramidSuccessScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          //~ fire
          GoRoute(
            path: RoutesName.fireInstructionScreen,
            name: RoutesName.fireInstructionScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const FirebreathingInstructionScreen(), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.fireSettingScreen,
            name: RoutesName.fireSettingScreen,
            pageBuilder: (context, state) {
              dynamic parameters = state.extra ;
              return customPageRouteBuilder(
                FirebreathingSettingScreen(
                  subTitle: parameters["subTitle"]!,
                ), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),


          //~ dna
          GoRoute(
            path: RoutesName.dnaInstructionScreen,
            name: RoutesName.dnaInstructionScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const DnaInstructionScreen(), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.dnaSettingScreen,
            name: RoutesName.dnaSettingScreen,
            pageBuilder: (context, state) {
              dynamic parameters = state.extra ;
              return customPageRouteBuilder(
                DnaSettingScreen(
                  subTitle: parameters["subTitle"]!,
                ), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),


          //~ pineal
          GoRoute(
            path: RoutesName.pinealInstructionScreen,
            name: RoutesName.pinealInstructionScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const PinealInstructionScreen(), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.pinealSettingScreen,
            name: RoutesName.pinealSettingScreen,
            pageBuilder: (context, state) {
              dynamic parameters = state.extra ;
              return customPageRouteBuilder(
                PinealSettingScreen(
                  subTitle: parameters["subTitle"]!,
                ), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

        ] 
      ),
    ]
  );
}

CustomTransitionPage customPageRouteBuilder(Widget page, LocalKey pageKey, {required Duration transitionDuration}) {
  return CustomTransitionPage(
    key: pageKey,
    child: page,
    fullscreenDialog: true,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
    transitionDuration: transitionDuration,
  );
}


CustomTransitionPage customPageRouteBuilderBottomToTop(Widget page, LocalKey pageKey, {required Duration transitionDuration}) {
  return CustomTransitionPage(
    key: pageKey,
    child: page,
    fullscreenDialog: true,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
    transitionDuration: transitionDuration,
  );
}