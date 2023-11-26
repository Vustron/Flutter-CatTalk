// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, file_names, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:wechat/model/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          // User profile picture
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: CachedNetworkImage(
              imageUrl: widget.user.image,
              placeholder: (context, url) => CircularProgressIndicator(),
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
            ),
          ),
          // Last message
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Last message time
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // trailing: Text(
          //   '12:00 PM',
          //   style: TextStyle(
          //     color: Colors.black,
          //   ),
        ),
      ),
    );
  }
}
