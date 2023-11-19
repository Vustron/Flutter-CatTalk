// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, avoid_returning_null_for_void
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat/main.dart';
import 'package:wechat/utils/dialog.dart';
import '../../controller/googleAuth.dart';
import '../home_screen.dart';

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
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Welcome to We Chat"),
      ),
      body: Stack(children: [
        // App Logo
        AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            duration: const Duration(seconds: 1),
            child: Image.asset('assets/images/icon.png')),

        // google login
        Positioned(
          bottom: mq.height * 0.2,
          left: mq.width * 0.17,
          height: mq.height * 0.09,
          child: Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                Dialogs.showProgressBar(context);
                try {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  await provider.googleLogin();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ));
                } catch (error) {
                  print('Error during Google login: $error');
                  Dialogs.showSnackBar(
                      context, 'Something went wrong (Check Internet)');
                }
              },
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
                    TextSpan(text: 'Login with '),
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
