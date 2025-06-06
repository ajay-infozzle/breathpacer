import 'package:flutter/material.dart';

class ResultContainerSectionWidget extends StatelessWidget {
  final String? title;
  final String? content;
  final String? iconPath;
  final bool showIcon;
  final bool showContent;
  final double iconSize;
  final Color containerColor;
  final Color textColor;
  final Color iconColor;

  const ResultContainerSectionWidget({
    super.key,
    this.title,
    this.content,
    this.iconPath,
    this.showIcon = true,
    this.showContent = true,
    this.iconSize = 24.0,
    this.containerColor = Colors.white,
    this.textColor = Colors.black,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.width*0.03),
      color: containerColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showIcon)
            Container(
              margin: EdgeInsets.only(right: size.width*0.02),
              child: Image.asset(
                iconPath!,
                width: iconSize,
                height: iconSize,
                // color: iconColor,
              ),
            ),
          
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: size.width * 0.043,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),

          if (showContent && content != null)
            SizedBox(height: size.width * 0.05),

          if (showContent && content != null)
            Text(
              content!,
              style: TextStyle(
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
        ],
      ),
    );
  }
}
