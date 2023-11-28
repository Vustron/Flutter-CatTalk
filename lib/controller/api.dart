// ignore_for_file: file_names, avoid_print
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../model/chat_user.dart';
import '../model/message.dart';
import 'package:http/http.dart' as http;

class API {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;
  // for storing self information
  static late ChatUser me;
  // to return current user
  static User get user => auth.currentUser!;
  // for accessing firebase messaging (Push Notifications)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    // Request permission
    NotificationSettings settings = await fMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}');
    // get push token
    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });
  }

  // for sending push notifications
  static Future<void> sendPushNotifications(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {"title": chatUser.name, "body": msg}
      };

      var response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAAfv393jU:APA91bGswPJx7mdyAgxSJH1W_qO-uxshvJYb1kAyJqCbvnPtj7I3XvKnwtbWECoDyFGIoePlzVleOsgEhC8JftHYPnO0spYH4c8cKoLVMgO8Qy1ycI7akLQcLdMQcZruueXd35Xf2RBR',
              },
              body: jsonEncode(body));
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      log('\nsendPushNotification Error: $e');
    }
  }

  // check if the user exists or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // check if the user exists or not
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        // for setting user status to active
        API.updateActiveStatus(true);
        log('My Data: ${user.data()}');
      } else {
        createUser().then((value) => getSelfInfo());
      }
    });
  }

// for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using We Chat",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // Get all users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  // for updating user profile picture
  static Future<void> updateUserProfilePicture(File file) async {
    // Getting image file extension
    final ext = file.path.split('.').last;
    print('Extension: $ext');

    // storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    // uploading image
    await ref
        .putFile(
            file,
            SettableMetadata(
              contentType: 'image/$ext',
            ))
        .then((p0) {
      print('Data transferred: ${p0.bytesTransferred / 1000} kb');
    });

    // Updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  ///****************Chat Screen related API**********************

  //get conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // Get all messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending messages
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    // message sending time(also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // message to send
    final Message message = Message(
        fromId: user.uid,
        msg: msg,
        read: '',
        sent: time,
        told: chatUser.id,
        type: type);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotifications(
            chatUser, type == Type.text ? msg : 'sent a photo'));
  }

  // update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    // Getting image file extension
    final ext = file.path.split('.').last;

    // storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    // uploading image
    await ref
        .putFile(
            file,
            SettableMetadata(
              contentType: 'image/$ext',
            ))
        .then((p0) {
      log('Data transferred: ${p0.bytesTransferred / 1000} kb');
    });

    // Updating image in firestore database
    final imageURL = await ref.getDownloadURL();
    await sendMessage(chatUser, imageURL, Type.image);
  }
}
