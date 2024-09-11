import 'package:breathpacer/bloc/dna/dna_cubit.dart';
import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/utils/custom_button.dart';
import 'package:breathpacer/view/breathPacer/dnaBreathing/widget/dna_saved_work_dialog_widget.dart';
import 'package:breathpacer/view/breathPacer/fireBreathing/widget/fire_saved_works_dialog_widget.dart';
import 'package:breathpacer/view/breathPacer/pyramidBreathing/widget/pyramid_saved_works_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InteractiveContainerWidget extends StatefulWidget {
  const InteractiveContainerWidget({super.key, required this.title, required this.image, required this.onTap, required this.description, required this.index});

  final int index;
  final String title;
  final String description;
  final String image;
  final VoidCallback onTap;


  @override
  State<InteractiveContainerWidget> createState() => _InteractiveContainerWidgetState();
}

class _InteractiveContainerWidgetState extends State<InteractiveContainerWidget> {
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
          
          //~ saved works drops
          _buildBlocBuilderForIndex(),
        ],
      ),
    );
  }
  
  
  titleSection(BuildContext context) {
    return SizedBox(
      width: size,
      child: Row(
        children: [
          CircleAvatar(
            radius: size*0.05,
            backgroundImage: AssetImage(widget.image)
          ),
          SizedBox(width: size*0.03,),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(.7),
                fontSize: size*0.05
              ),
              overflow: TextOverflow.ellipsis,
            )
          ),
        ],
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
  
  savedWorks(BuildContext context) {
    int total = 0;

    switch (widget.index) {
      case 0:
        total = context.read<PyramidCubit>().savedBreathwork.length;
        break;
      case 1:
        total = context.read<FirebreathingCubit>().savedBreathwork.length; 
        break;
      case 2:
        total = context.read<DnaCubit>().savedBreathwork.length; 
        break;
      case 3:
        // total = context.read<DnaCubit>().savedBreathwork.length;
        break;
    }

    return total < 1
    ? const SizedBox()
    : Container(
        margin: EdgeInsets.only(top: size * 0.04),
        child: GestureDetector(
          onTap: (){
            viewAllSavedBreathwork(context);
          },
          child: Text(
            "View all saved breathworks($total)",
            style: const TextStyle(
                color: Color(0xffFE60D4), 
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
  }
  
  viewAllSavedBreathwork(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          alignment: Alignment.center,
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: size*0.05),
          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: getDialogContent(),
        );
      },
    );
  }
  
  getDialogContent() {
    switch (widget.index) {
      case 0:
        return const PyramidSavedWorksDialogWidget();
      case 1:
        return const FirebreathingSavedWorksDialogWidget();
      case 2:
        return const DnaSavedWorkDialogWidget();
      case 3:
        return const SizedBox();
    }
  }


  Widget _buildBlocBuilderForIndex() {
    switch (widget.index) {
      case 0:
        return BlocBuilder<PyramidCubit, PyramidState>(
          builder: (context, state) => savedWorks(context),
        );
      case 1:
        return BlocBuilder<FirebreathingCubit, FirebreathingState>(
          builder: (context, state) => savedWorks(context),
        );
      case 2:
        return BlocBuilder<DnaCubit, DnaState>(
          builder: (context, state) => savedWorks(context),
        );
      case 3:
        return BlocBuilder<PinealCubit, PinealState>(
          builder: (context, state) => savedWorks(context),
        );
      default:
        return const SizedBox();
    }
  }
  
}
