import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    navigateToHome(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            body: SafeArea(
          top: true,
          bottom: true,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/splash_icon.png',
                  height: 190,
                  width: 190,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Text(
                  "Jerry Sargeant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        )),
      ),
    );
  }


  void navigateToHome(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1),() {
      // context.goNamed(RoutesName.homeScreen);
      context.goNamed(RoutesName.disclamerScreen);
    },);
  }
}