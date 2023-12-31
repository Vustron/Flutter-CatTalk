// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, file_names, prefer_const_constructors, unnecessary_string_interpolations, unrelated_type_equality_checks, no_leading_underscores_for_local_identifiers
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';
import '/model/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/utils/my_date_util.dart';
import '../controller/API.dart';
import '../main.dart';
import '../model/message.dart';
import '../screens/chat_screen.dart';
import 'dialogs/dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  // for handling message text changes
  final _textController = TextEditingController();

  bool isReplied = false;

  @override
  Widget build(BuildContext context) {
    bool isMe = API.user.uid == widget.message.fromId;

    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

  // sender or another user message
  Widget _blueMessage() {
    // file url
    final Uri _fileURL = Uri.parse(widget.message.msg);
    // update last read message if sender and reciever are different
    if (widget.message.read.isEmpty) {
      API.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: Colors.lightBlue[200],
              border: Border.all(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: widget.message.type == Type.file
                ? // show file
                InkWell(
                    onTap: () async {
                      if (!await launchUrl(_fileURL)) {
                        throw Exception('Could not launch $_fileURL');
                      }
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg,
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.file_present_rounded, size: 70),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.message.msg,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : widget.message.type == Type.text
                    ? Text(
                        widget.message.msg,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      )
                    : // show image
                    InkWell(
                        onTap: () async {
                          _previewImageDialog();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg,
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.image, size: 70),
                          ),
                        ),
                      ),
          ),
        ),

        // message time
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
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
    // file url
    final Uri _fileURL = Uri.parse(widget.message.msg);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // message time
        Row(
          children: [
            // for adding some space
            SizedBox(width: mq.width * .04),
            // double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            // for adding some space
            SizedBox(width: 2),
            // read time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        // message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: Colors.lightGreen[200],
              border: Border.all(
                color: Colors.green,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: widget.message.type == Type.file
                ? // show file
                InkWell(
                    onTap: () async {
                      if (!await launchUrl(_fileURL)) {
                        throw Exception('Could not launch $_fileURL');
                      }
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg,
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.file_present_rounded, size: 70),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.message.msg,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : widget.message.type == Type.text
                    ? Text(
                        widget.message.msg,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      )
                    : // show image
                    InkWell(
                        onTap: () async {
                          _previewImageDialog();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg,
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.image, size: 70),
                          ),
                        ),
                      ),
          ),
        ),
      ],
    );
  }

// preview image dialog
  void _previewImageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.only(top: 20, bottom: 10),
        // title
        title: Row(
          children: [
            SizedBox(
              height: mq.height * 0.3,
              width: 235,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: widget.message.msg,
                  placeholder: (context, url) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.image, size: 70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // bottom sheet for modifying message detail
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              // divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                  vertical: mq.height * .015,
                  horizontal: mq.width * .4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              widget.message.type == Type.text ||
                      widget.message.type == Type.file
                  ?
                  // copy option
                  _OptionItem(
                      icon: Icon(
                        Icons.copy_all_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: ' Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          // for hiding bottom sheet
                          Navigator.pop(context);
                          Dialogs.showSnackBarCopy(context, 'Text Copied');
                        });
                      })
                  : // copy option
                  _OptionItem(
                      icon: Icon(
                        Icons.download_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: ' Save Image',
                      onTap: () async {
                        try {
                          log('Image Url: ${widget.message.msg}');
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'WeChat')
                              .then((success) {
                            // for hiding bottom sheet
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackBarUpdate(
                                  context, 'Image saved successfully');
                            }
                          });
                        } catch (e) {
                          log('Error while saving image: $e');
                        }
                      }),

              // separator
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              // edit option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.yellow[900],
                      size: 26,
                    ),
                    name: ' Edit Message',
                    onTap: () {
                      // for hiding  bottom sheet
                      Navigator.pop(context);
                      _showMessageUpdateDialog();
                    }),

              // delete option
              if (isMe)
                _OptionItem(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                      size: 26,
                    ),
                    name: ' Delete Message',
                    onTap: () async {
                      await API.deleteMessage(widget.message).then((value) {
                        // for hiding  bottom sheet
                        Navigator.pop(context);
                      });
                      Dialogs.showSnackBarSuccess(
                          context, 'Message deleted successfully');
                    }),

              // separator
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),

              // sent time
              _OptionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.blue,
                  ),
                  name:
                      ' Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),
              // read time
              _OptionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.lightGreen,
                  ),
                  name: widget.message.read.isEmpty
                      ? ' Read At: Not seen yet'
                      : ' Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),

              // buttons
            ],
          );
        });
  }

  // dialog for updating message content
  void _showMessageUpdateDialog() {
    String updateMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding:
                  EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
              // title
              title: Row(
                children: const [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(
                    ' Update Message',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              // content
              content: TextFormField(
                initialValue: updateMsg,
                maxLines: null,
                onChanged: (value) => updateMsg = value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              // actions
              actions: [
                // update button
                MaterialButton(
                  onPressed: () async {
                    // hide alert dialog
                    Navigator.pop(context);
                    await API.updateMessage(widget.message, updateMsg);
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
                // cancel button
                MaterialButton(
                  onPressed: () {
                    // hide alert dialog
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ));
  }
}

// Custom option card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
          left: mq.width * .05,
          top: mq.height * .015,
          bottom: mq.height * .015,
        ),
        child: Row(
          children: [
            icon,
            Flexible(
              child: Text(
                '$name',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
