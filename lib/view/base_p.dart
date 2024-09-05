// return Scaffold(
//       // appBar: AppBar(
//       //   iconTheme: const IconThemeData(color: Colors.white),
//       //   backgroundColor: AppTheme.colors.appBarColor,
//       //   centerTitle: true,
//       //   title: const Text(
//       //     "Interactive Breathing",
//       //     style: TextStyle(color: Colors.white),
//       //   ),
//       // ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: AppTheme.colors.linearGradient
//         ),
//         child: Column(
//           children: [
//             AppBar(
//               iconTheme: const IconThemeData(color: Colors.white),
//               backgroundColor: Colors.transparent,
//               centerTitle: true,
//                 leading: GestureDetector(
//                   onTap: () => context.pop(),
//                   child: const Icon(Icons.arrow_back_ios),
//                 ),
//               title: const Text(
//                 "Interactive Breathing",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             SizedBox(height: size*0.02,),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: size*0.05),
//               color: Colors.white.withOpacity(.3),
//               height: 1,
//             ),

//             //~
//             Expanded(
//               child: ListView(
                
//               ) 
//             ),
//           ],
//         ),
//       ),
//     );