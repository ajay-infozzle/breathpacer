import 'package:breathpacer/config/theme.dart';
import 'package:flutter/material.dart';

class SettingsToggleButton extends StatelessWidget {
  const SettingsToggleButton({super.key, required this.onToggle, required this.title, required this.isOn});

  final String title;
  final bool isOn;
  final Function() onToggle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Expanded(
          child: Text(
            title, 
            style: TextStyle(
              fontSize: size*0.047, 
              color: Colors.white
            )
          ),
        ),
        
        SizedBox(width: size*0.03,),
        Transform.scale(
          scale: 0.9,
          child: Switch( 
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            trackColor: isOn ? WidgetStateProperty.all(Colors.white) : WidgetStateProperty.all(Colors.transparent),
            trackOutlineColor: WidgetStateProperty.all(Colors.white),
            thumbColor:
                isOn ? WidgetStateProperty.all(AppTheme.colors.thumbColor) : WidgetStateProperty.all(Colors.white),
            value: isOn,
            onChanged: (_) {
              onToggle();
            }
          ),
        )
      ]
    );
  }
}
