import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:breathpacer/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PyramidInstructionScreen extends StatelessWidget {
  const PyramidInstructionScreen({super.key, required this.subTitle, required this.description});

  final String subTitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width ;
    final height = MediaQuery.of(context).size.height ;
    
    return Scaffold(
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
                onTap: () => context.pop(),
                child: const Icon(Icons.arrow_back_ios),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Pyramid Breathing",
                    style: TextStyle(color: Colors.white, fontSize: size*0.05,fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(color: Colors.white, fontSize: size*0.04),
                  ),
                ],
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
                child: ListView(
                  children: [
                    SizedBox(height: size*0.04,),
                
                    SizedBox(
                      child: Text(
                        "Before your session",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size*0.05,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: size*0.05,bottom: size*0.08),
                      child: Text(
                        description,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size*0.04,
                        ),
                      ),
                    ),


                    Container(
                      height: height*0.2,
                      width: size,
                      margin: EdgeInsets.symmetric(horizontal: size*0.07),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white
                        )
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset("assets/images/instruction_dummy.png",fit: BoxFit.cover,)
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: size*0.09,bottom: size*0.09, right: size*0.04, left: size*0.04),
                      child: CustomButton(
                        title: "Ok, start now !", 
                        height: 48,
                        spacing: .7,
                        radius: 10,
                        onPress: (){
                          context.pushReplacementNamed(
                            RoutesName.pyramidSettingScreen,
                            extra:{
                              "step" : subTitle.split(" ").first
                            }
                          );
                        }
                      )
                    ),

                  ],
                ),
              ) 
            ),
          ],
        ),
      ),
    );
  }
}