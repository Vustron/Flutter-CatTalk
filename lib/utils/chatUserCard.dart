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
import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
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
          child: StreamBuilder(
            stream: API.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                _message = list[0];
              }
              return ListTile(
                  // User profile picture
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileDialog(user: widget.user));
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * 0.1),
                          child: CachedNetworkImage(
                            width: mq.height * 0.055,
                            height: mq.height * 0.055,
                            fit: BoxFit.fill,
                            imageUrl: widget.user.image,
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
                                width: 10,
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
                                width: 10,
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
                  ),
                  // User name
                  title: Text(
                    widget.user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  // Last message
                  subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? 'Sent a photo'
                            : _message!.type == Type.file
                                ? 'Sent a file'
                                : _message!.msg
                        : widget.user.about,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),

                  // Last message time
                  trailing: _message == null
                      ? null // Show nothing when no message is sent
                      : _message!.read.isEmpty &&
                              _message!.fromId != API.user.uid
                          ?
                          // Show for unread message
                          Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          :
                          // Message sent time
                          Text(
                              MyDateUtil.getLastMessageTime(
                                  context: context, time: _message!.sent),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ));
            },
          )),
    );
  }
}
