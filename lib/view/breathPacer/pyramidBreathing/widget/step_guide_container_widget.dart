import 'package:breathpacer/utils/custom_button.dart';
import 'package:flutter/material.dart';

class StepGuideContainerWidget extends StatefulWidget {
  const StepGuideContainerWidget({super.key, required this.title, required this.onTap, required this.description});

  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  State<StepGuideContainerWidget> createState() => _StepGuideContainerWidgetState();
}

class _StepGuideContainerWidgetState extends State<StepGuideContainerWidget> {
  late double size;
  late double height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size*0.03,vertical: size*0.04),
      margin: EdgeInsets.only(top: size*0.06),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        children: [
          titleSection(context),
          SizedBox(height: size*0.03,),

          descriptionSection(context),
          SizedBox(height: size*0.03,),

          startButtonSection(context),
        ],
      ),
    );
  }
  
  titleSection(BuildContext context) {
    return SizedBox(
      width: size,
      child: SizedBox(
        child: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(.7),
            fontSize: size*0.045
          ),
          overflow: TextOverflow.ellipsis,
        )
      ),
    );
  }
  
  descriptionSection(BuildContext context) {
    return Text(
      widget.description,
      style: TextStyle(
        color: Colors.black.withOpacity(.4),
        fontSize: size*0.035,
        fontWeight: FontWeight.bold
      ),
    );
  }
  
  startButtonSection(BuildContext context) {
    return SizedBox(
      width: size,
      child: CustomButton(
        title: "Start", 
        radius: 5,
        height: 43,
        spacing: 0.3,
        onPress: widget.onTap
      ),
    );
  }
}