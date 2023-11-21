// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      // color: Colors.blue.shade50,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          // user profile picture
          leading: CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),
          // user name
          title: Text('Demo User'),
          // last message
          subtitle: Text(
            'Last user message',
            maxLines: 1,
          ),
          // last message time
          trailing: Text(
            '12:00 PM',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
