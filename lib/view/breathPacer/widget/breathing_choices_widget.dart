import 'package:breathpacer/config/theme.dart';
import 'package:breathpacer/utils/constant/jerry_voice.dart';
import 'package:flutter/material.dart';

class BreathingChoices extends StatelessWidget {
  const BreathingChoices({
    super.key, 
    required this.chosenItem, 
    required this.onUpdateChoiceIndex, 
    required this.onUpdateVoiceOver, 
    required this.choicesList,
  });

  final int chosenItem;
  final List<String> choicesList;
  final Function(int) onUpdateChoiceIndex;
  final Function(JerryVoiceEnum audio) onUpdateVoiceOver;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choice of breath hold type:', 
          style: TextStyle(fontSize: size * 0.047, color: Colors.white),
        ),
        SizedBox(height: size * 0.03),
        Wrap(
          direction: Axis.horizontal,
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: List.generate(choicesList.length, (index) {
            return ChoiceChip(
              label: Text(
                choicesList[index],
                style: TextStyle(
                  color: chosenItem == index 
                      ? AppTheme.colors.blueNotChosen 
                      : Colors.white,
                  fontWeight: chosenItem == index ? FontWeight.bold : null
                ),
              ),
              shape: const StadiumBorder(side: BorderSide(color: Colors.white)),
              backgroundColor: AppTheme.colors.blueSlider,
              selectedColor: Colors.white,
              showCheckmark: false,
              selected: chosenItem == index,
              onSelected: (bool selected) {
                onUpdateChoiceIndex(index);
                switch (index) {
                  case 0:
                    onUpdateVoiceOver(JerryVoiceEnum.breatheIn);
                    break;
                  case 1:
                    onUpdateVoiceOver(JerryVoiceEnum.breatheOut);
                    break;
                  case 2:
                    onUpdateVoiceOver(JerryVoiceEnum.breatheBoth);
                    break;
                }
              },
            );
          }),
        ),
      ],
    );
  }
}
