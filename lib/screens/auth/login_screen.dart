// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, avoid_returning_null_for_void, depend_on_referenced_packages
import 'dart:developer';

import 'package:WeChat/controller/facebookAuth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '/main.dart';
import '/utils/dialogs/dialog.dart';
import '../../controller/API.dart';
import '../../controller/googleAuth.dart';
import '../home_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // mq = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: const Text("Welcome to WeChat"),
        // ),
        body: Stack(children: [
          // app logo
          AnimatedPositioned(
              top: _isAnimate ? mq.height * .15 : -mq.width * .5,
              right: mq.width * .25,
              width: mq.width * .5,
              duration: const Duration(seconds: 1),
              child: Image.asset('assets/images/icon.png')),

          // app name
          Positioned(
            bottom: mq.height * .38,
            width: mq.width,
            // duration: const Duration(seconds: 1),
            child: Center(
              child: Column(
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText(
                        'Welcome to',
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                        speed: const Duration(milliseconds: 70),
                      ),
                    ],
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'WeChat',
                        textStyle: const TextStyle(
                            fontSize: 50, fontWeight: FontWeight.w900),
                        colors: [
                          Colors.black,
                          const Color.fromARGB(255, 68, 255, 196),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // google login
          AnimatedPositioned(
            bottom: _isAnimate ? mq.height * 0.2 : -mq.width * .5,
            left: mq.width * 0.14,
            height: mq.height * 0.2,
            duration: const Duration(seconds: 1),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  Dialogs.showProgressBar(context);
                  try {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);

                    await provider.googleLogin();

                    await Future.delayed(const Duration(seconds: 1));

                    if (await API.userExists()) {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: const HomeScreen(),
                          ));
                    } else {
                      await API.createUser().then((value) {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: const HomeScreen(),
                            ));
                      });
                    }
                  } catch (error) {
                    log('Error during Google login: $error');
                    Dialogs.showSnackBar(
                        context, 'Something went wrong (Check Internet)');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 68, 68),
                  shape: const StadiumBorder(),
                  elevation: 1,
                ),
                icon: SizedBox(
                  width: mq.height * 0.05,
                  height: mq.height * 0.07,
                  child: Image.asset('assets/images/google.png'),
                ),
                label: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                    children: [
                      TextSpan(text: 'Login with '),
                      TextSpan(
                        text: 'Google    ',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          // // facebook login
          // AnimatedPositioned(
          //   bottom: _isAnimate ? mq.height * 0.1 : -mq.width * .5,
          //   left: mq.width * 0.14,
          //   height: mq.height * 0.2,
          //   duration: const Duration(seconds: 1),
          //   child: Center(
          //     child: ElevatedButton.icon(
          //       onPressed: () async {
          //         Dialogs.showProgressBar(context);
          //         try {
          //           final provider = Provider.of<FacebookSignInProvider>(
          //               context,
          //               listen: false);
          //           await provider.facebookLogin();
          //           if (await API.userExists()) {
          //             Navigator.pushReplacement(
          //                 context,
          //                 PageTransition(
          //                   type: PageTransitionType.bottomToTop,
          //                   child: const HomeScreen(),
          //                 ));
          //           } else {
          //             await API.createUser().then((value) {
          //               Navigator.pushReplacement(
          //                   context,
          //                   PageTransition(
          //                     type: PageTransitionType.bottomToTop,
          //                     child: const HomeScreen(),
          //                   ));
          //             });
          //           }
          //         } catch (error) {
          //           log('Error during Facebook login: $error');
          //           Dialogs.showSnackBar(
          //               context, 'Something went wrong (Check Internet)');
          //         }
          //       },
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: const Color.fromARGB(255, 68, 140, 255),
          //         shape: const StadiumBorder(),
          //         elevation: 1,
          //       ),
          //       icon: SizedBox(
          //         width: mq.height * 0.05,
          //         height: mq.height * 0.07,
          //         child: Image.asset('assets/images/facebook.png'),
          //       ),
          //       label: RichText(
          //         text: const TextSpan(
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 19,
          //           ),
          //           children: [
          //             TextSpan(text: 'Login with '),
          //             TextSpan(
          //               text: 'Facebook',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w900,
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ]),
      ),
    );
  }
}
