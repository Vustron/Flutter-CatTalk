// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, file_names, prefer_const_constructors, deprecated_member_use
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:WeChat/screens/video_call_screen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import '/controller/api.dart';
import '/model/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/model/message.dart';
import '/screens/view_profile_screen.dart';
import '/utils/my_date_util.dart';
import '../main.dart';
import '../utils/messageCard.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for storing messages
  List<Message> _list = [];
  // for handling message text changes
  final _textController = TextEditingController();
  // show emoji -- for storing value of showing or hiding emoji
  // isUploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            // if emojis are shown & back button is pressed then hide emojis
            // or else simple close current screen on back button click
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            // appbar
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
              actions: [
                IconButton(
                  onPressed: () async {
                    API.sendVideoCallPushNotification(widget.user);
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRightWithFade,
                        child: VideoCallScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.video_call),
                ),
              ],
            ),
            backgroundColor: Color.fromARGB(255, 215, 245, 246),
            // body
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: API.getAllMessages(widget.user),
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
                          // log('Data: ${jsonEncode(data![0].data())}');
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];
                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: const EdgeInsets.only(top: 2),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(message: _list[index]);
                              },
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'Say Hi! 👋',
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

                // progress indicator for showing uploading
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )),

                // chat input field
                _chatInput(),
                // Show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: const Color.fromARGB(255, 234, 248, 255),
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        recentTabBehavior: RecentTabBehavior.RECENT,
                        recentsLimit: 28,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ), // Needs to be const Widget
                        loadingIndicator:
                            const SizedBox.shrink(), // Needs to be const Widget
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // appbar widget
  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                child: ViewProfileScreen(user: widget.user)));
      },
      child: Padding(
          padding: const EdgeInsets.only(top: 1),
          child: StreamBuilder(
              stream: API.getUserInfo(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];

                return Row(
                  // Back button
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    // User profile picture
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            width: mq.height * .06,
                            height: mq.height * .06,
                            fit: BoxFit.fill,
                            imageUrl: list.isNotEmpty
                                ? list[0].image
                                : widget.user.image,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                          ),
                        ),
                        // user status
                        widget.user.isOnline
                            ? Positioned(
                                top: 30,
                                bottom: 0,
                                right: 1,
                                width: 12,
                                child: MaterialButton(
                                  onPressed: () {
                                    // Add your onPressed logic here
                                  },
                                  shape: CircleBorder(),
                                  color: Colors.lightGreenAccent,
                                ),
                              )
                            : Positioned(
                                top: 30,
                                bottom: 0,
                                right: 1,
                                width: 12,
                                child: MaterialButton(
                                  onPressed: () {
                                    // Add your onPressed logic here
                                  },
                                  shape: CircleBorder(),
                                  color: Colors.grey,
                                ),
                              ),
                      ],
                    ),

                    // for adding space
                    const SizedBox(width: 10),

                    // User Name
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list.isNotEmpty ? list[0].name : widget.user.name,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          list.isNotEmpty
                              ? list[0].isOnline
                                  ? 'Online'
                                  : MyDateUtil.getLastActiveTime(
                                      context: context,
                                      lastActive: list[0].lastActive)
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: widget.user.lastActive),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              })),
    );
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Color.fromARGB(255, 68, 255, 196),
              child: Row(
                children: [
                  // emoji button
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(Icons.emoji_emotions,
                        color: Colors.white, size: 25),
                  ),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type something...',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  )),
                  // pick an image from gallery button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // pick multiple images
                      final List<XFile> images = await picker.pickMultiImage(
                        imageQuality: 70,
                      );
                      // uploading and sending images one by one
                      for (var i in images) {
                        log('Image Path: ${i.path}');
                        setState(() => _isUploading = true);
                        await API.sendChatImage(widget.user, File(i.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon:
                        const Icon(Icons.image, color: Colors.white, size: 26),
                  ),
                  // take an image from camera button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() => _isUploading = true);
                        await API.sendChatImage(widget.user, File(image.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(Icons.camera_alt_rounded,
                        color: Colors.white, size: 26),
                  ),
                  // add space
                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ),
          // send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  // on first message add user to my_user collection of chat users
                  API.sendFirstMessage(
                    widget.user,
                    _textController.text,
                    Type.text,
                  );
                } else {
                  // simply send message
                  API.sendMessage(
                    widget.user,
                    _textController.text,
                    Type.text,
                  );
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Color.fromARGB(255, 68, 255, 196),
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
