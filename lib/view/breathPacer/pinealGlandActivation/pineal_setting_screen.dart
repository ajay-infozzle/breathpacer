import 'package:breathpacer/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PinealSettingScreen extends StatelessWidget {
  const PinealSettingScreen({super.key, required this.subTitle});
  
  final String subTitle;

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
                "Pineal Gland Activation",
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
                      child: Image.asset("assets/images/pineal_icon.png"),
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
                ],
              ) 
            ),
          ],
        ),
      ),
    );
  }
}