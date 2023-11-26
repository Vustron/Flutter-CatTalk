// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, file_names, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:wechat/model/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controller/API.dart';
import '../main.dart';
import '../model/message.dart';
import '../screens/chat_screen.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return API.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  // sender or another user message
  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 221, 245, 255),
              border: Border.all(
                color: Colors.lightBlue,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        // message time
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            widget.message.sent,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  // our message or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // message time
        Row(
          children: [
            // for adding some space
            SizedBox(width: mq.width * .04),
            // double tick blue icon for message read
            const Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: 20,
            ),
            // for adding some space
            SizedBox(width: 2),
            // read time

            Text(
              widget.message.read + '12:00 PM',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 218, 255, 176),
              border: Border.all(
                color: Colors.lightGreen,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
