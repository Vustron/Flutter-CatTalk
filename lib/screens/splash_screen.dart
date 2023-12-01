// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, avoid_returning_null_for_void
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '/main.dart';
import '/utils/dialogs/dialog.dart';
import '../../controller/API.dart';
import '../../controller/googleAuth.dart';
import './home_screen.dart';
import 'auth/login_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

// Splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () async {
      // Exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        statusBarColor: Colors.transparent,
      ));
      if (API.auth.currentUser != null) {
        log('\nUser: ${API.auth.currentUser}');
        Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.size,
              alignment: Alignment.bottomCenter,
              child: const HomeScreen(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.size,
              alignment: Alignment.bottomCenter,
              child: const LoginScreen(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      // ),
      body: Stack(children: [
        // App Logo
        Positioned(
            top: mq.height * .25,
            right: mq.width * .25,
            width: mq.width * .5,
            // duration: const Duration(seconds: 1),
            child: Image.asset('assets/images/icon.png')),

        // App Text
        Positioned(
          bottom: mq.height * .28,
          width: mq.width,
          // duration: const Duration(seconds: 1),
          child: Center(
            child: Column(
              children: [
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
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                      'Made by Vustron Vustronus',
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                      speed: const Duration(milliseconds: 70),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const SpinKitThreeBounce(
                  color: Color.fromARGB(255, 68, 255, 196),
                  size: 50.0,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
