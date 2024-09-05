import 'package:breathpacer/config/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RestartBreathingWidget extends StatelessWidget {
  const RestartBreathingWidget({super.key, required this.onTap});

  final VoidCallback onTap ;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: size*0.03, vertical: size*0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppTheme.colors.restartChallengeBg,
          border: Border.all(color: Colors.white38),
        ),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_circle, 
              color: Colors.white, 
              size: 40
            ),
            const SizedBox(width: 16.0),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You can restart this breathwork',
                    style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: size*0.046, color: Colors.white
                    ),
                  ),
      
                  Text(
                    'Start over and get better results',
                    style: TextStyle(
                      fontSize: size*0.04, color: Colors.white
                    ),
                  ),
      
                  Text(
                    'Start over',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: size*0.046,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}