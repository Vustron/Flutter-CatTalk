// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, file_names, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '/model/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/utils/dialogs/profile_dialog.dart';
import '/utils/my_date_util.dart';
import '../controller/api.dart';
import '../main.dart';
import '../model/message.dart';
import 'chat_screen.dart';

class ChatUserAvatar extends StatefulWidget {
  final ChatUser user;
  const ChatUserAvatar({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserAvatar> createState() => _ChatUserAvatarState();
}

class _ChatUserAvatarState extends State<ChatUserAvatar> {
  // last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    // Declare MediaQuery instance
    final mq = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 8, vertical: 4), // Adjust margins as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              // Navigating to chat screen
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.topToBottom,
                  child: ChatScreen(user: widget.user),
                ),
              );
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (_) => ProfileDialog(user: widget.user),
              );
            },
            child: StreamBuilder(
              stream: API.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

                if (list.isNotEmpty) {
                  _message = list[0];
                }
                return SizedBox(
                  // User profile picture
                  height: 60,
                  child: Stack(
                    children: [
                      // user profile picture
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(mq.size.height * 0.1),
                        child: CachedNetworkImage(
                          width: mq.size.height * 0.055,
                          height: mq.size.height * 0.055,
                          fit: BoxFit.fill,
                          imageUrl: widget.user.image,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        ),
                      ),

                      // User name
                      Positioned(
                        top: 40,
                        child: Text(
                          widget.user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),

                      // user status
                      Positioned(
                        top: 10,
                        bottom: 0,
                        right: 1,
                        width: 10,
                        child: MaterialButton(
                          onPressed: () {
                            // Add your onPressed logic here
                          },
                          shape: CircleBorder(),
                          color: widget.user.isOnline
                              ? Colors.lightGreenAccent
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
