// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, avoid_print, unused_label, unused_local_variable, unnecessary_null_comparison, prefer_const_constructors, use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:WeChat/controller/facebookAuth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '/model/chat_user.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../main.dart';
import '../controller/googleAuth.dart';
import '../controller/api.dart';
import '../utils/dialogs/dialog.dart';
import 'auth/login_screen.dart';

// Profile Screen
class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 68, 255, 196),
          resizeToAvoidBottomInset: false,

          //title
          appBar: AppBar(
            title: const Text("Profile"),
          ),

          // Logout Button
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              onPressed: () async {
                // for showing progress
                EasyLoading.show(status: 'loading...');

                API.updateActiveStatus(false);
                // Add a delay of 2 seconds using Future.delayed
                await Future.delayed(const Duration(seconds: 2));

                // Google provider and listener
                final googleprovider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);

                await googleprovider.googleLogout().then((value) async {
                  // for moving to home screen
                  Navigator.pop(context);

                  API.auth = FirebaseAuth.instance;

                  // Replacing home screen with login screen
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.topToBottom,
                        child: const LoginScreen(),
                      ));
                  EasyLoading.dismiss();
                });

                // Facebook provider and Listener
                // final facebookprovider =
                //     Provider.of<FacebookSignInProvider>(context, listen: false);

                // await facebookprovider.facebookLogout().then((value) async {
                //   // for hiding progress dialog
                //   Navigator.pop(context);
                //   // for moving to home screen
                //   Navigator.pop(context);

                //   API.auth = FirebaseAuth.instance;

                //   // Replacing home screen with login screen
                //   Navigator.pushReplacement(
                //       context,
                //       PageTransition(
                //         type: PageTransitionType.topToBottom,
                //         child: const LoginScreen(),
                //       ));
                // });
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

          body: Container(
            height: 800,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Space
                      SizedBox(width: mq.width, height: mq.height * .03),

                      Stack(
                        children: [
                          // User Profile Picture
                          _image != null
                              ?
                              // local image
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mq.height * .1),
                                  child: Image.file(
                                    File(_image!),
                                    width: mq.height * .2,
                                    height: mq.height * .2,
                                    fit: BoxFit.cover,
                                  ))
                              :
                              // image from server
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mq.height * .1),
                                  child: CachedNetworkImage(
                                    width: mq.height * .2,
                                    height: mq.height * .2,
                                    fit: BoxFit.fill,
                                    imageUrl: widget.user.image,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                  ),
                                ),
                          // Edit image button
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: MaterialButton(
                              elevation: 1,
                              onPressed: () {
                                _showBottomSheet();
                              },
                              shape: const CircleBorder(),
                              color: Color.fromARGB(255, 68, 255, 196),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
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
                        onSaved: (val) => API.me.name = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 68, 255, 196),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 68, 255, 196)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 68, 255, 196)),
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
                        onSaved: (val) => API.me.about = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.info_outline,
                            color: Color.fromARGB(255, 68, 255, 196),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 68, 255, 196)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 68, 255, 196)),
                          ),
                          hintText: 'eg. Feeling Happy',
                          labelText: 'About',
                        ),
                      ),
                      // Space
                      SizedBox(height: mq.height * .04),
                      // Update Button
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await API.updateUserInfo();
                            Dialogs.showSnackBarUpdate(
                                context, 'Profile Updated Sucessfully');
                          }
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 28,
                        ),
                        label: const Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Color.fromARGB(255, 68, 255, 196),
                          minimumSize: Size(mq.width * .5, mq.height * .06),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .1),
            children: [
              // pick profile picture label
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              // for adding some space
              SizedBox(height: mq.height * .04),
              // buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // pick from gallery button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(mq.width * .3, mq.height * .15),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        print('Image Path: ${image.path}');
                        setState(() {
                          _image = image.path;
                        });

                        await API.updateUserProfilePicture(File(_image!));
                        // for hiding bottom sheet
                        Navigator.pop(context);
                        Dialogs.showSnackBarUpdate(
                            context, 'Picture Updated Sucessfully');
                      }
                    },
                    child: Image.asset('assets/images/add_image.png'),
                  ),
                  // take a picture from camera
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(mq.width * .3, mq.height * .15),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        print('Image Path: ${image.path}');
                        setState(() {
                          _image = image.path;
                        });

                        await API.updateUserProfilePicture(File(_image!));
                        // for hiding bottom sheet
                        Navigator.pop(context);
                        Dialogs.showSnackBarUpdate(
                            context, 'Picture Updated Sucessfully');
                      }
                    },
                    child: Image.asset('assets/images/camera.png'),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
