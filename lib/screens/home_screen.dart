// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, avoid_print, unused_label, unused_local_variable, unnecessary_null_comparison, prefer_const_constructors
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat/model/chat_user.dart';
import 'package:wechat/utils/chatUserCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../main.dart';
import '../controller/googleAuth.dart';
import '../controller/api.dart';
import 'auth/login_screen.dart';

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    // Default values if the user is null
    String name = 'Default Name';
    String email = 'default@email.com';
    String photoUrl = 'assets/images/vustron.png';
    if (user != null) {
      // Update values if the user is not null
      name = user.displayName ?? name;
      email = user.email ?? email;
      photoUrl = user.photoURL ?? photoUrl;
    }
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text("We Chat"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      // body: Center(
      //   child: Column(
      //     children: [
      //       const SizedBox(height: 10.0),
      //       CircleAvatar(
      //         backgroundImage: user != null
      //             ? (photoUrl.startsWith('http') ||
      //                     photoUrl.startsWith('https'))
      //                 ? NetworkImage(photoUrl)
      //                 : AssetImage(photoUrl) as ImageProvider<Object>?
      //             : AssetImage(photoUrl),
      //         radius: 50.0,
      //       ),
      //       const SizedBox(height: 10.0),
      //       Text(
      //         name,
      //         style: const TextStyle(
      //           color: Colors.amberAccent,
      //           letterSpacing: 1.0,
      //           fontSize: 12.0,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //       const SizedBox(height: 10.0),
      //       Text(
      //         email,
      //         style: const TextStyle(
      //           color: Colors.amberAccent,
      //           letterSpacing: 1.0,
      //           fontSize: 12.0,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //       SizedBox(
      //         width: 121,
      //         child: ElevatedButton.icon(
      //           onPressed: () async {
      //             try {
      //               final provider = Provider.of<GoogleSignInProvider>(context,
      //                   listen: false);
      //               provider.googleLogout();
      //               Navigator.pushReplacement(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (_) => const LoginScreen(),
      //                   ));
      //             } catch (error) {
      //               print('Error during Google login: $error');
      //             }
      //           }, // Missing closing parenthesis here
      //           icon: const Icon(
      //             Icons.logout,
      //             color: Colors.white,
      //           ),
      //           label: const Text(
      //             'Logout',
      //             style: TextStyle(
      //               fontSize: 10,
      //               color: Colors.white,
      //             ),
      //           ),
      //           style: ButtonStyle(
      //             backgroundColor: MaterialStateProperty.all(
      //               Colors.red,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.add_comment_rounded,
            color: Colors.white,
          ),
          backgroundColor: const Color.fromARGB(255, 68, 255, 196),
        ),
      ),
      body: StreamBuilder(
        stream: API.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // If data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: SpinKitFadingCube(
                  color: Colors.blue,
                  size: 50.0,
                ),
              );

            // If some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                return ListView.builder(
                  itemCount: list.length,
                  padding: const EdgeInsets.only(top: 2),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    // final itemName = list[index].name;
                    // return Text('Name: $itemName');
                    return ChatUserCard(user: list[index]);
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No Connection Found!',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
