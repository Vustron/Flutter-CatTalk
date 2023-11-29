// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, avoid_print, unused_label, unused_local_variable, unnecessary_null_comparison, prefer_const_constructors, prefer_final_fields, unused_field, deprecated_member_use, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers
import 'dart:convert';
import 'dart:developer';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wechat/model/chat_user.dart';
import '../utils/chatUserCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../main.dart';
import '../controller/googleAuth.dart';
import '../controller/api.dart';
import '../utils/dialogs/dialog.dart';
import 'auth/login_screen.dart';
import 'profile_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // For storing all users
  List<ChatUser> _list = [];
  // for storing search items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;
  // for animations
  late AnimationController _dialogController;

  @override
  void initState() {
    super.initState();

    // dialog control animation
    _dialogController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Adjust the duration as needed
    );

    // get self info
    API.getSelfInfo();

    // for updating user active status according to lifecycle events
    // resume = active or online
    // pause = inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (API.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          API.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          API.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  void dispose() {
    _dialogController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      // for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        // if search is on & back button is pressed then close search
        // or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(false);
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 215, 245, 246),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              // leading: const Icon(CupertinoIcons.home),
              automaticallyImplyLeading: false,
              title: _isSearching
                  ? TextField(
                      autofocus: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name, Email...',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      // Search logic
                      onChanged: (val) {
                        _searchList.clear();
                        for (var i in _list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                    )
                  : AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText(
                          'WeChat',
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                    ),
              actions: [
                IconButton(
                  onPressed: () async {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(
                    _isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRightWithFade,
                        child: ProfileScreen(user: API.me),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_outline_outlined),
                ),
              ],
            ),
            // Add user button
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                onPressed: () {
                  _addChatUserDialog();
                },
                child: const Icon(
                  Icons.add_comment_rounded,
                  color: Colors.white,
                ),
                backgroundColor: const Color.fromARGB(255, 68, 255, 196),
              ),
            ),
            // body
            body: StreamBuilder(
                stream: API.getMyUsersId(),

                // get id of only known users
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    // If data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: SpinKitFadingCircle(
                          color: Color.fromARGB(255, 68, 255, 196),
                          size: 50.0,
                        ),
                      );

                    // If some or all data is loaded then show it
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return StreamBuilder(
                        stream: API.getAllUsers(
                            snapshot.data?.docs.map((e) => e.id).toList() ??
                                []),

                        // get only those user, who's ids are provided
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            // If data is loading
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const Center(
                                child: SpinKitFadingCircle(
                                  color: Color.fromARGB(255, 68, 255, 196),
                                  size: 50.0,
                                ),
                              );

                            // If some or all data is loaded then show it
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              _list = data
                                      ?.map((e) => ChatUser.fromJson(e.data()))
                                      .toList() ??
                                  [];

                              if (_list.isNotEmpty) {
                                return ListView.builder(
                                    itemCount: _isSearching
                                        ? _searchList.length
                                        : _list.length,
                                    padding:
                                        EdgeInsets.only(top: mq.height * .01),
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ChatUserCard(
                                          user: _isSearching
                                              ? _searchList[index]
                                              : _list[index]);
                                    });
                              } else {
                                return const Center(
                                    child: Text(
                                  'No Connection Found!',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ));
                              }
                          }
                        },
                      );
                  }
                }),
          ),
        ),
      ),
    );
  }

  // dialog for updating message content
  void _addChatUserDialog() {
    String email = '';

    showDialog(
      context: context,
      builder: (_) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: _dialogController,
          curve: Curves.easeInOut,
        )),
        child: Material(
          type: MaterialType.transparency,
          child: AlertDialog(
            contentPadding:
                EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
            backgroundColor: Color.fromARGB(255, 68, 255, 196),
            // title
            title: Row(
              children: const [
                Icon(
                  Icons.person_add,
                  color: Colors.white,
                  size: 28,
                ),
                Text(
                  ' Add User',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),

            // content
            content: TextFormField(
              maxLines: null,
              onChanged: (value) => email = value,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Email Id',
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),

            // actions
            actions: [
              // add button
              MaterialButton(
                onPressed: () async {
                  // hide alert dialog
                  Navigator.pop(context);
                  if (email.isNotEmpty) {
                    await API.addChatUser(email).then((value) {
                      if (!value) {
                        Dialogs.showSnackBar(context, 'User does not exist');
                      }
                    });
                  } else {
                    Dialogs.showSnackBar(context, 'Please input an email');
                  }
                },
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              // cancel button
              MaterialButton(
                onPressed: () {
                  _dialogController.reverse();
                  // hide alert dialog
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // Start the animation when the dialog is displayed
    _dialogController.forward();
  }
}
