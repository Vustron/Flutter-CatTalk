// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last, prefer_final_fields, unused_field, unused_element, avoid_print, unused_local_variable, use_build_context_synchronously, file_names, prefer_const_constructors, unnecessary_string_interpolations, unrelated_type_equality_checks
import 'dart:async';
import 'dart:developer';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import '../controller/agora.dart';

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
  // init timer
  late Timer timer;
  int elapsedTimeInSeconds = 0;

  @override
  void initState() {
    super.initState();
    // initialize agora client
    agoraProvider.initializeAgora();

    // // init token generator
    // agoraProvider.getToken();

    // Start the timer
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTimeInSeconds++;
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer.cancel();
    // dispose agora client

    super.dispose();
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
        actions: [
          // Timer display
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${Duration(seconds: elapsedTimeInSeconds).inMinutes}:${Duration(seconds: elapsedTimeInSeconds).inSeconds.remainder(60)}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      // body
      body: SafeArea(
        child: Stack(
          children: [
            // video call screen
            Container(
              child: AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                floatingLayoutContainerHeight: 100,
                floatingLayoutContainerWidth: 100,
                showNumberOfUsers: true,
                showAVState: true,
              ),
            ),
            AgoraVideoButtons(client: client),
          ],
        ),
      ),
    );
  }
}
