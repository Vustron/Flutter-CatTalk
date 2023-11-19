// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:wechat/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Welcome to We Chat"),
      ),
      body: Stack(children: [
        Positioned(
            top: mq.height * .15,
            left: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('assets/images/icon.png')),
        Positioned(
          bottom: mq.height * 0.2,
          left: mq.width * 0.17,
          height: mq.height * 0.09,
          child: Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 68, 255, 196),
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
                    TextSpan(text: 'Sign in with '),
                    TextSpan(
                      text: 'Google',
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
      ]),
    );
  }
}
