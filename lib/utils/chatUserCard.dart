// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, file_names, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:wechat/model/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wechat/utils/my_date_util.dart';
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
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            // Navigating to chat screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(user: widget.user)));
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
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      width: mq.height * .055,
                      height: mq.height * .055,
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
                  title: Text(
                    widget.user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  // Last message
                  subtitle: Text(
                    _message != null ? _message!.msg : widget.user.about,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
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
                                color: Colors.black54,
                                fontSize: 10,
                              ),
                            ));
            },
          )),
    );
  }
}
