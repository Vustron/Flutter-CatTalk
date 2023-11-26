// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, avoid_print, unused_label, unused_local_variable, unnecessary_null_comparison, prefer_const_constructors, use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wechat/model/chat_user.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../main.dart';
import '../controller/googleAuth.dart';
import '../controller/api.dart';
import '../utils/dialog.dart';
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
          body: Form(
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
                      onSaved: (val) => API.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
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
                      onSaved: (val) => API.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
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
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              // pick profile picture label
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              // for adding some space
              SizedBox(height: mq.height * .02),
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
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() {
                          _image = image.path;
                        });

                        API.updateUserProfilePicture(File(_image!));
                        // for hiding bottom sheet
                        Navigator.pop(context);
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
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() {
                          _image = image.path;
                        });

                        API.updateUserProfilePicture(File(_image!));
                        // for hiding bottom sheet
                        Navigator.pop(context);
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
