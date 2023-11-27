// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, avoid_print, unused_label, unused_local_variable, unnecessary_null_comparison, prefer_const_constructors, prefer_final_fields, unused_field, deprecated_member_use
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wechat/model/chat_user.dart';
import '../utils/chatUserCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../main.dart';
import '../controller/googleAuth.dart';
import '../controller/api.dart';
import 'auth/login_screen.dart';
import 'profile_screen.dart';

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // For storing all users
  List<ChatUser> _list = [];
  // for storing search items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    API.getSelfInfo();

    // for setting user status to active
    API.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      // for updating user active status according to lifecycle events
      // resume = active or online
      // pause = inactive or offline
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
            return Future.value(true);
          }
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: const Icon(CupertinoIcons.home),
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
                  : Text("WeChat"),
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
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(user: API.me),
                        ));
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
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
              stream: API.getAllUsers(),
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
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        padding: const EdgeInsets.only(top: 2),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          // final itemName = list[index].name;
                          // return Text('Name: $itemName');
                          return ChatUserCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index]);
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
          ),
        ),
      ),
    );
  }
}
