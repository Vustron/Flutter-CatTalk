// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, file_names, prefer_const_constructors, deprecated_member_use
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wechat/controller/api.dart';
import 'package:wechat/model/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wechat/model/message.dart';
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

  bool _showEmoji = false;

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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),

            backgroundColor: Color.fromARGB(255, 234, 248, 255),
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
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: Row(
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
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                width: mq.height * .06,
                height: mq.height * .06,
                imageUrl: widget.user.image,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
            ),
            // for adding space
            const SizedBox(width: 10),
            // User Name
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'Last seen not available',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
              child: Row(
                children: [
                  // emoji button
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(Icons.emoji_emotions,
                        color: Color.fromARGB(255, 68, 255, 196), size: 25),
                  ),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type something...',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  )),
                  // pick an image from gallery button
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.image,
                        color: Color.fromARGB(255, 68, 255, 196), size: 26),
                  ),
                  // take an image from camera button
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_rounded,
                        color: Color.fromARGB(255, 68, 255, 196), size: 26),
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
                API.sendMessage(
                  widget.user,
                  _textController.text,
                );
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
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
