import 'package:breathpacer/config/router/routes_name.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.colors.appBarColor,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Test User",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        buildListTile(context, 'Home',() => (){}),
                        const Divider(height: 0),

                        buildListTile(
                            context,
                            'Blogs',
                            () => (){}
                        ),
                        
                        const Divider(height: 0),
                        buildListTile(
                            context,
                            'Breathwork Pacer',
                            () {
                              context.pushNamed(RoutesName.interactiveBreathingScreen);
                            },
                        ),
                        const Divider(height: 0),

                        buildListTile(
                            context,
                            'Contact Us',
                            () => (){}
                        ),
                        const Divider(height: 0),


                        buildListTile(
                            context,
                            'About Star Magic',
                            () => (){}
                        ),
                        const Divider(height: 0),

                        buildListTile(
                            context,
                            'Terms & Conditions',
                            () => (){}
                        ),
                        const Divider(height: 0),

                        ListTile(
                          title: const Text('Sign in'),
                          onTap: () {
                          },
                        ),
                        // ListTile(
                        //   title: Text(globalLoggedIn
                        //       ? 'Sign out'
                        //       : 'Sign in'),
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //     if (globalLoggedIn) {
                        //       viewModel.logOut();
                        //       context.go("/onboarding");
                        //     } else {
                        //       GoRouter.of(context).push("/login");
                        //     }
                        //   },
                        // ),
                        const Divider(height: 0),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListTile(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }
}