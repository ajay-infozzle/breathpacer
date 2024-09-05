import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.buttonColor = const Color(0xffFE60D4),
    this.textColor = Colors.white,
    required this.title ,
    required this.onPress ,
    this.width = 60 ,
    this.height = 50 ,
    this.radius = 50 ,
    this.spacing = .3 ,
    this.textsize = 14 ,
    this.loading = false ,
  });

  final bool loading;
  final String title;
  final double height,width,spacing,radius,textsize;
  final VoidCallback onPress;
  final Color textColor,buttonColor;

  @override
  Widget build(BuildContext context) {
    // final double size = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: !loading ? onPress : (){},

      child: Container(
    
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(radius),
        ),
    
        child: loading ? 
        const Center(
          child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            color: Colors.white,
            ),
        )
        ) :
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              title, 
              style: TextStyle(
                color: textColor, 
                letterSpacing: spacing,
                fontSize: textsize,
                fontWeight: FontWeight.bold
              ), 
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ) ,
    
      ),
    );
  }
}