import 'package:breathpacer/config/theme.dart';
import 'package:breathpacer/utils/drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width ;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        // exit(0);
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppTheme.colors.appBarColor,
        ),
        drawer: const AppDrawerWidget(),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
            child: Container(color: AppTheme.colors.thumbColor,),
            // child: buildTabBar(context, 0, state.isGuest, state.isActive),
          ),
        ),
        body: Container(
          width: size,
          height: double.maxFinite,
          decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
          child: 
          // !state.isLoading ?
          ListView(
            children: [
              SizedBox(height: size*0.06),
              SizedBox(
                width: size,
                child: Text(
                  "Welcome to Infinity",
                  style: TextStyle(
                    fontSize: size*0.085,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          
              SizedBox(
                width: size,
                child: Text(
                  "The Ultimate Consciousness \nExpanding Toolbox",
                  style: TextStyle(
                    fontSize: size*0.06,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          
              SizedBox(height: size*0.06),
      
              Container(
                margin: EdgeInsets.symmetric(horizontal: size*0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Expanded(
                        flex: 1,
                        child: buildIcons(
                          context, true, false, "Light\nLanguage",
                          'assets/images/icon_home_light_language.png', 
                          () {}
                        ),
                      ),
                      
                      Expanded(
                        flex: 1,
                        child: buildIcons(
                          context, true, false, "Meditation", 
                          'assets/images/icon_home_meditation.png', 
                          () {}
                        ),
                      ),
                      
                      Expanded(
                        flex: 1,
                        child: buildIcons(
                          context, true, false, "Free\nHealing",
                          'assets/images/icon_home_distance_healing.png', () {
                            
                          }
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: size*0.03,),
      
              Container(
                  margin: EdgeInsets.symmetric(horizontal: size*0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Expanded(
                        flex: 1,
                        child: buildIcons(context, true, false, "High\nVibration",
                            'assets/images/icon_home_recipes.png', () {
                          
                        }),
                      ),
                      
                      Expanded(
                        flex: 1,
                        child: buildIcons(context, true, false, "Yoga", 'assets/images/icon_home_yoga.png', () {
                          
                        }),
                      ),
                      
                      Expanded(
                        flex: 1,
                        child: buildIcons(context, false, false, "Blogs", 'assets/images/icon_home_blog.png', () {
                          
                        }),
                      ),
                  ],
                ),
              ),
              SizedBox(height: size*0.03,),
      
              Container(
                margin: EdgeInsets.symmetric(horizontal: size*0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Expanded(
                        flex: 1,
                        child: buildIcons(context, true, false, "Curated\nPlaylists",
                            'assets/images/icon_home_playlist.png', () {
                         
                        }),
                      ),
                      
                      Expanded(
                        flex: 1,
                        child: buildIcons(context, true, false, "Mystery\nSchool",
                            'assets/images/icon_home_mystery_school.png', () {
                          
                        }),
                      ),
                      
                      Expanded(
                        flex: 1,
                        child: buildIcons(context, true, false, "Resources\nSection",
                            'assets/images/icon_infinite_wisdom.png', () {
                          
                        }),
                      ),
                  ],
                ),
              ),
        
              SizedBox(height: size*0.03,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size*0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Expanded(
                        flex: 1,
                        child: buildIcons(context, false, false, "Cart", 'assets/images/icon_home_cart.png', () {
                          
                        }),
                      ),
                      const Expanded(flex: 1,child: SizedBox()),
                      const Expanded(flex: 1,child: SizedBox())
                  ],
                ),
              ),
            ],
          )
          // :Container(
          //     color: Colors.transparent,
          //     child: Center(
          //       child: Padding(
          //         padding: const EdgeInsets.only(top: 20),
          //         child: Container(
          //           width: 100,
          //           height: 100,
          //           decoration: BoxDecoration(
          //             borderRadius: const BorderRadius.all(Radius.circular(10)),
          //             color: AppTheme.colors.transparentGrey.withOpacity(.1),
          //           ),
          //           child: const Center(
          //             child: CircularProgressIndicator(color: Colors.white),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
        ),
      ),
    );
  }


    Widget buildIcons(
      BuildContext context, bool isGuest, bool isActive, String text, String image, Function() onPressed) {
      return GestureDetector(
        onTap: (isGuest || !isActive) && text != "Meditation" && text != "Blogs" && text != "Cart"
            ? () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      content: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7.0),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0)),
                              padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Some sections are only accessible to Infinity Members. Please update your membership from the website.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Image.asset('assets/images/x_button.png', width: 25, height: 25)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            : onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Opacity(
                  opacity:
                      (isGuest || !isActive) && text != "Meditation" && text != "Blogs" && text != "Cart" ? 1 : 1.0,
                  child: Image.asset(image, width: 50),
                ),

                if((isGuest || !isActive) && text != "Meditation" && text != "Blogs" && text != "Cart")
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.4),
                        borderRadius: BorderRadiusDirectional.circular(25)
                      ),
                    ),
                  ),

                if ((isGuest || !isActive) && text != "Meditation" && text != "Blogs" && text != "Cart")
                  const Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 14,height: 1.2),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
  }


  // Widget buildTabBar(BuildContext context, int index, bool isGuest, bool isActive) {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
  //     color: AppTheme.colors.thumbColor,
  //     child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
  //       IconButton(
  //         icon: Image.asset(Images.leaderboardIcon, height: 40, color: index == 1 ? Colors.white : null),
  //         onPressed: (isGuest || !isActive)
  //             ? () {
  //                 showDialog(
  //                   context: context,
  //                   builder: (context) {
  //                     return AlertDialog(
  //                       surfaceTintColor: Colors.transparent,
  //                       backgroundColor: Colors.transparent,
  //                       content: Stack(
  //                         children: [
  //                           Container(
  //                             padding: const EdgeInsets.all(7.0),
  //                             child: Container(
  //                               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0)),
  //                               padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
  //                               child: const Padding(
  //                                 padding: EdgeInsets.only(top: 20.0),
  //                                 child: Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: [
  //                                     Text(
  //                                       "Some sections are only accessible to Infinity Members. Please update your membership from the website.",
  //                                       textAlign: TextAlign.center,
  //                                       style: TextStyle(fontSize: 18),
  //                                     ),
  //                                     SizedBox(height: 20),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Positioned(
  //                             right: 0.0,
  //                             top: 0.0,
  //                             child: GestureDetector(
  //                               onTap: () {
  //                                 Navigator.of(context).pop();
  //                               },
  //                               child: Align(
  //                                   alignment: Alignment.topRight,
  //                                   child: Image.asset(Images.xButton, width: 25, height: 25)),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     );
  //                   },
  //                 );
  //               }
  //             : () {
  //                 viewModel.setTabIndex(1);
  //                 GoRouter.of(context).push("/leaderboard");
  //               },
  //       ),
  //       IconButton(
  //         icon: Image.asset(Images.calIcon, height: 40, color: index == 2 ? Colors.white : null),
  //         onPressed: () {
  //           viewModel.setTabIndex(2);
  //           GoRouter.of(context).push("/events");
  //         },
  //       ),
  //       IconButton(
  //         icon: Image.asset(Images.faqIcon, height: 40, color: index == 3 ? Colors.white : null),
  //         onPressed: () {
  //           viewModel.setTabIndex(3);
  //           GoRouter.of(context).push("/faq");
  //         },
  //       ),
  //       IconButton(
  //         icon: Image.asset(Images.mailIcon, height: 40, color: index == 4 ? Colors.white : null),
  //         onPressed: () {
  //           viewModel.setTabIndex(4);
  //           GoRouter.of(context).push("/contact_us");
  //         },
  //       ),
  //     ]),
  //   );
  // }
}