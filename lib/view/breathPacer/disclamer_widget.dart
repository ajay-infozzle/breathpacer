import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DisclamerScreen extends StatefulWidget {
  const DisclamerScreen({super.key});

  @override
  State<DisclamerScreen> createState() => _DisclamerScreenState();
}

class _DisclamerScreenState extends State<DisclamerScreen> {
  String appVersion = '';

  @override
  void initState() {
    loadVersion() ;
    super.initState();
  }
  
  Future<void> loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = '${info.version}+${info.buildNumber}'; // Example: 1.0.0+1
    });
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width ; 

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        // exit(0);
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
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: const Text(
                  "Read Before You Begin",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: size*0.02,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size*0.05),
                color: Colors.white.withOpacity(.3),
                height: 1,
              ),
      
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: size*0.05, left: size*0.05),
                  child: ListView(
                    padding: EdgeInsetsDirectional.only(top: size*0.05),
                    children: [
      
                      //~ jerry image
                      Container(
                        width: size,
                        alignment: Alignment.center,
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          // backgroundImage: AssetImage("assets/images/instruction_dummy.png"),
                          backgroundImage: AssetImage("assets/images/healing_jerry.png"),
                          radius: 100,
                        ),
                      ),
                      SizedBox(height: size*0.05,),
      
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: size*0.03,vertical: size*0.04),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(
                          children: [
                            Text(
                              "A Note From Jerry",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.colors.pinkButton,
                                // color: Colors.black.withValues(alpha:.7),
                                fontSize: size*0.05
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: size*0.03,),
                            descriptionSection(size, noteFromJerry)
                          ],
                        )
                      ),
      
      
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: size*0.03,vertical: size*0.04),
                        margin: EdgeInsets.only(top: size*0.06),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Do you really want to activate your superhuman potential ?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.colors.pinkButton,
                                // color: Colors.black.withValues(alpha:.7),
                                fontSize: size*0.05
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: size*0.03,),
                            descriptionSection(size, doYouReallyWantToActivateYourSuperhumanPotential)
                          ],
                        )
                      ),
      
                      SizedBox(height: size*0.04,),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: size*0.03,vertical: size*0.04),
                        margin: EdgeInsets.only(top: size*0.06),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(
                          children: [
                            Text(
                              "App Version - $appVersion",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.colors.pinkButton,
                                // color: Colors.black.withValues(alpha:.7),
                                fontSize: size*0.05
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      ),

                      SizedBox(height: size*0.04,),
                    ],
                  ),
                ) 
              ),
      
              GestureDetector(
                onTap: () {
                  context.goNamed(RoutesName.homeScreen);
                },
                child: Container(
                  width: size,
                  height: 50,
                  color: AppTheme.colors.pinkButton,
                  child: Center(
                    child: Text(
                      "Let's Begin",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size*0.05,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  descriptionSection(double size, String desc) {
    return Text(
      desc,
      style: TextStyle(
        color: Colors.black.withOpacity(.5),
        // color: Colors.black.withValues(alpha:.4),
        fontSize: size*0.038,
        fontWeight: FontWeight.bold
      ),
    );
  }
}