import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:breathpacer/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DnaInstructionScreen extends StatelessWidget {
  const DnaInstructionScreen({super.key});

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
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              leading: GestureDetector(
                onTap: () => context.pop(),
                child: const Icon(Icons.arrow_back_ios),
              ),
              title: const Text(
                "DNA Breathing",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: size,
              child: CircleAvatar(
                radius: size*0.075,
                child: Image.asset("assets/images/dna_icon.png"),
              ),
            ),
            
            SizedBox(height: size*0.04,),
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
                        "Ensure you’re in a safe and quiet space. If you’re new to this, consider having someone supervise your practice. Start in a comfortable seated position. Keep a steady pace and avoid rushing. If you have any medical conditions, are pregnant, or experience discomfort, it’s essential to consult a healthcare professional. Regular practice can lead to noticeable results, but don’t push yourself if you’re feeling unwell. The most important thing is to enjoy your practice and pay attention to how your body feels.",
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
                            RoutesName.dnaSettingScreen,
                            extra:{
                              "subTitle" : "DNA breathing"
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