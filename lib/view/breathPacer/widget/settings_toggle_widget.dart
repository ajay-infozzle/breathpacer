import 'package:breathpacer/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';

class SettingsToggleButton extends StatelessWidget {
  const SettingsToggleButton({super.key, required this.onToggle, required this.title, required this.isOn, this.showPopup = false});

  final String title;
  final bool isOn;
  final bool showPopup;
  final Function() onToggle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                title, 
                style: TextStyle(
                  fontSize: size*0.047, 
                  color: Colors.white
                ),
                // overflow: TextOverflow.ellipsis,
              ),

              showPopup ?
              Container(
                margin: EdgeInsets.symmetric(horizontal: size*0.03),
                child: InfoPopupWidget(
                  contentTitle: 'This is the squeeze and hold of your buttocks and genitals, tip of the tongue on the roof of the mouth',
                  contentTheme: InfoPopupContentTheme(
                    infoContainerBackgroundColor: Colors.white,
                    infoTextStyle: TextStyle(color: AppTheme.colors.blueSlider, fontWeight: FontWeight.bold),
                    contentPadding: const EdgeInsets.all(8),
                    contentBorderRadius: const BorderRadius.all(Radius.circular(12)),
                    infoTextAlign: TextAlign.center,
                  ),
                  arrowTheme: InfoPopupArrowTheme(
                    color: AppTheme.colors.blueSlider,
                    arrowDirection: ArrowDirection.up,
                    arrowSize: const Size(15,24)
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                ),
              ) : const SizedBox(),
            ],
          ),
        ),

                
        SizedBox(width: size*0.03,),
        Container(
          width: size*0.14,
          height: height*0.033,
          alignment: Alignment.centerRight,
          child: Transform.scale(
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
          ),
        )
      ]
    );
  }
}
