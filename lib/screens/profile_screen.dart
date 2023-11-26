// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, avoid_print, unused_label, unused_local_variable, unnecessary_null_comparison, prefer_const_constructors, use_build_context_synchronously
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat/model/chat_user.dart';
import 'package:wechat/utils/chatUserCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../main.dart';
import '../controller/googleAuth.dart';
import '../controller/api.dart';
import '../utils/dialog.dart';
import 'auth/login_screen.dart';

// Home Screen
class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      // Logout Button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          onPressed: () async {
            // showing progress
            Dialogs.showProgressBar(context);
            // Google provider and listener
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            await provider.googleLogout().then((value) async {
              // for hiding progress dialog
              Navigator.pop(context);
              // for moving to home screen
              Navigator.pop(context);
              // Replacing home screen with login screen
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ));
            });
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          label: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
        child: Column(
          children: [
            // Space
            SizedBox(width: mq.width, height: mq.height * .03),
            // User Profile Picture
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .1),
                  child: CachedNetworkImage(
                    width: mq.height * .2,
                    height: mq.height * .2,
                    fit: BoxFit.fill,
                    imageUrl: widget.user.image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: MaterialButton(
                    elevation: 1,
                    onPressed: () {},
                    shape: const CircleBorder(),
                    color: Colors.white,
                    child: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            // Space
            SizedBox(height: mq.height * .03),
            // User Email
            Text(
              widget.user.email,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            // Space
            SizedBox(height: mq.height * .05),
            // User Name
            TextFormField(
              initialValue: widget.user.name,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.purple,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'eg. John Doe',
                labelText: 'Name',
              ),
            ),
            // Space
            SizedBox(height: mq.height * .02),
            // User about
            TextFormField(
              initialValue: widget.user.about,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.info_outline,
                  color: Colors.purple,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'eg. Feeling Happy',
                labelText: 'About',
              ),
            ),
            // Space
            SizedBox(height: mq.height * .04),
            // Update Button
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                size: 28,
              ),
              label: const Text(
                'Update',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                minimumSize: Size(mq.width * .5, mq.height * .06),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
