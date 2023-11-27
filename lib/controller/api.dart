// ignore_for_file: file_names, avoid_print
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/chat_user.dart';
import '../model/message.dart';

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

  // check if the user exists or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // check if the user exists or not
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        print('My Data: ${user.data()}');
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
    await ref.doc(time).set(message.toJson());
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
