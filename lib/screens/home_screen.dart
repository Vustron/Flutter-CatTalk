// ignore_for_file: avoid_unnecessary_containers, unused_import, sort_child_properties_last
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text("We Chat"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.add_comment_rounded,
            color: Colors.white, // Set the color to white
          ),
          backgroundColor: Colors.purple, // Set the background color if needed
        ),
      ),
    );
  }
}
