// import 'package:breathpacer/config/theme.dart';
// import 'package:breathpacer/utils/constant/interaction_breathing_constant.dart';
// import 'package:flutter/material.dart';

// class SettingsDropdownButton extends StatelessWidget {
//   const SettingsDropdownButton({
//     super.key,
//     required this.onSelected,
//     required this.title,
//     required this.selected,
//     required this.options,
//     this.isTime = false,
//     this.isnumber = false
//   });

//   final bool? isTime ;
//   final bool? isnumber ;
//   final String title;
//   final int selected;
//   final List<int> options;
//   final Function(int) onSelected;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;


//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             title,
//             style: TextStyle(
//               fontSize: size * 0.047,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         SizedBox(width: size * 0.03),
        
//         Container(
//           padding: const EdgeInsets.only(left: 5),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.white),
//             borderRadius: BorderRadius.circular(5),
//             color: Colors.transparent,
//           ),
//           child: DropdownButton<int>(
//             underline: const SizedBox(),
//             padding: const EdgeInsets.all(0),
//             isDense: true,
//             value: selected,
//             selectedItemBuilder: (BuildContext context) {
//               return options.map<Widget>((int value) {
//                 return Text(
//                   isTime! ? (value==-1 ? "Infinite" :getFormattedTime(value)) :(isnumber!? '$value' : '$value set'),
//                   style: const TextStyle(color: Colors.white, ),
//                 );
//               }).toList();
//             },
//             items: options.map<DropdownMenuItem<int>>((int value) {
//               return DropdownMenuItem<int>(
//                 value: value,
//                 child: Text(
//                   isTime! ? (value==-1 ? "Infinite" :getFormattedTime(value)) : (isnumber!? '$value' : '$value set'),
//                   style: const TextStyle(
//                     color: Colors.black, 
//                   ),
//                 ),
//               );
//             }).toList(),
//             onChanged: (int? newValue) {
//               if (newValue != null) {
//                 onSelected(newValue);
//               }
//             },
//             icon: Container(
//               margin: const EdgeInsets.only(left: 5),
//               alignment: Alignment.center,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(3),
//                   bottomRight: Radius.circular(3)
//                 ),
//               ),
//               child: const Icon(
//                 Icons.arrow_drop_down,
//                 color: Colors.black,
//               ),
//             ),
//             dropdownColor: Colors.white,
//             menuMaxHeight: height*0.35,
//           ),
//         ),        
//       ],
//     );
//   }
// }



// // SizedBox(
//         //   child: DropdownMenu<int>(
//         //     menuHeight: height * 0.35,
//         //     menuStyle: MenuStyle(
//         //       backgroundColor: const WidgetStatePropertyAll(Colors.white),
//         //       side: WidgetStatePropertyAll(BorderSide(color: AppTheme.colors.blueSlider)),
//         //       padding: const WidgetStatePropertyAll(EdgeInsets.zero),
//         //     ),
//         //     initialSelection: selected,
//         //     textStyle: const TextStyle(color: Colors.white,),
//         //     onSelected: (int? newValue) {
//         //       if (newValue != null) {
//         //         onSelected(newValue);
//         //       }
//         //     },
//         //     width: size*0.3,
//         //     // trailingIcon: Icon(Icons.abc_rounded),
//         //     // selectedTrailingIcon: ,
//         //     inputDecorationTheme: const InputDecorationTheme(
//         //       suffixIconColor: Colors.white,
//         //       enabledBorder: OutlineInputBorder(
//         //         borderSide: BorderSide(color: Colors.white),
//         //       ), 
//         //       // constraints: BoxConstraints(
//         //       //   minHeight: 30,
//         //       //   maxHeight: 30,
//         //       // ),
//         //       contentPadding: EdgeInsets.symmetric(horizontal: 8),
//         //     ),
//         //     dropdownMenuEntries: options.map<DropdownMenuEntry<int>>((int value) {
//         //       return DropdownMenuEntry<int>(
//         //         value: value,
//         //         label: isTime!
//         //               ? (value == -1 ? "Infinite" : getFormattedTime(value))
//         //               : (isnumber! ? '$value' : '$value set'),
//         //       );
//         //     }).toList(),
            
//         //   ),
//         // ),