// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, avoid_returning_null_for_void
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:wechat/main.dart';
import 'package:wechat/utils/dialog.dart';
import '../../controller/API.dart';
import '../../controller/googleAuth.dart';
import './home_screen.dart';
import 'auth/login_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    Future.delayed(const Duration(milliseconds: 2000), () async {
      // Exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        statusBarColor: Colors.white,
      ));
      if (API.auth.currentUser != null) {
        log('\nUser: ${API.auth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
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
          child: const Center(
            child: Column(
              children: [
                Text(
                  'WeChat',
                  style: TextStyle(
                      fontSize: 50,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  'Made by Vustron Vustronus',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                SpinKitThreeBounce(
                  color: Colors.black,
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