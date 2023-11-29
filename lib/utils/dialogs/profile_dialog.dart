// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, file_names, prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wechat/screens/view_profile_screen.dart';
import '../../main.dart';
import '../../model/chat_user.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Color.fromARGB(255, 68, 255, 196),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        width: mq.width * .6,
        height: mq.height * .35,
        child: Stack(
          children: [
            // User profile picture
            Positioned(
              top: mq.height * .040,
              left: mq.width * .13,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .25),
                child: CachedNetworkImage(
                  width: mq.width * .5,
                  fit: BoxFit.fill,
                  imageUrl: user.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),
            ),
            // user name
            Positioned(
              left: mq.width * .1,
              top: mq.width * .60,
              width: mq.width * .58,
              child: Center(
                child: Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
            // info button
            Positioned(
              right: 8,
              top: 6,
              child: MaterialButton(
                  onPressed: () {
                    // for hiding the card
                    Navigator.pop(context);
                    // for transition into user profile screen
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rotate,
                            alignment: Alignment.bottomCenter,
                            duration: Duration(milliseconds: 500),
                            child: ViewProfileScreen(user: user)));
                  },
                  shape: CircleBorder(),
                  minWidth: 0,
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 30,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
