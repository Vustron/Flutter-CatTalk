// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, file_names, prefer_const_constructors, unnecessary_string_interpolations, unrelated_type_equality_checks
import 'dart:developer';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:WeChat/controller/agora.dart';

// video call screen
class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen>
    with WidgetsBindingObserver {
  // call agora client
  final AgoraAPIProvider agoraProvider = AgoraAPIProvider();

  @override
  void initState() {
    super.initState();
    // initialize agora client
    agoraProvider.initializeAgora();
  }

  @override
  Widget build(BuildContext context) {
    // call agora client data
    AgoraClient client = agoraProvider.getClient;

    return Scaffold(
      // appbar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Video Call'),
      ),
      // body
      body: SafeArea(
        child: Stack(
          children: [
            // video call screen
            AgoraVideoViewer(client: client),
            AgoraVideoButtons(client: client),
          ],
        ),
      ),
    );
  }
}
