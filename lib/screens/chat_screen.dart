// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, file_names, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:wechat/model/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        // body
        body: Column(
          children: [_chatInput()],
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
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_emotions,
                        color: Color.fromARGB(255, 68, 255, 196), size: 25),
                  ),
                  const Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Type something...',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 68, 255, 196),
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
            onPressed: () {},
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
