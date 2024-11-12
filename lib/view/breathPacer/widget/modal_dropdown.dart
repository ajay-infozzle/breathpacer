import 'package:breathpacer/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModalDropDown extends StatelessWidget {
  const ModalDropDown({
    super.key,
    required this.title,
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  final String title;
  final int selected;
  final List<String> options;
  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: size * 0.047,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: size * 0.03),
        
        Container(
          width: size*0.25,
          height: height*0.033,
          padding: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(5),
            color: Colors.transparent,
          ),

          child: GestureDetector(
            onTap: () {
              showOptionsBottomSheet(context: context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size*0.15,
                  child: Text(
                    options[selected],
                    style: const TextStyle(color: Colors.white,),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(3),
                      bottomRight: Radius.circular(3)
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),        
      ],
    );
  }

  void showOptionsBottomSheet({
    required BuildContext context,
  }) {
    final selectedIndex = selected;
    final FixedExtentScrollController controller = FixedExtentScrollController(initialItem: selectedIndex);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      // builder: (BuildContext context) {
      //   return SizedBox(
      //     height: MediaQuery.of(context).size.height * 0.35, 
      //     child: ListView.builder(
      //       itemCount: options.length,
      //       itemBuilder: (context, index) {
      //         final value = options[index];
      //         return Container(
      //           color: value == selected ? AppTheme.colors.blueSlider.withOpacity(0.1) : Colors.transparent,
      //           child: ListTile(
      //             title: Center(
      //               child: Text(
      //                 isTime! ? (value ==-1 ? "Infinite" :getFormattedTime(value)) :(isnumber!? '$value' : '$value set'),
      //                 style: TextStyle(
      //                   color: AppTheme.colors.blueSlider,
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: MediaQuery.of(context).size.width * 0.05
      //                 ),
      //               ),
      //             ),
      //             onTap: () {
      //               onSelected(value); 
      //               context.pop(); 
      //             },
      //           ),
      //         );
      //       },
      //     ),
      //   );
      // },

      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: ListWheelScrollView(
            controller: controller,
            itemExtent: 60, 
            diameterRatio: 1.5, 
            physics: const FixedExtentScrollPhysics(), 
            children: options.map((value) {
              return GestureDetector(
                onTap: () {
                  onSelected(value);  
                  context.pop();     
                },
                child: Container(
                  color: value == options[selected]
                      ? AppTheme.colors.blueSlider.withOpacity(0.03)
                      : Colors.transparent, 
                  alignment: Alignment.center,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: AppTheme.colors.blueSlider,
                      fontWeight: value == options[selected] ? FontWeight.bold : FontWeight.normal,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}