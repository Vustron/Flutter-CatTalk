// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:http/http.dart';

class AgoraAPIProvider {
  // agora client data
  late AgoraClient _client;
  // init temp token
  String tempToken = "";

  // for initializing client
  Future<void> initializeAgora() async {
    await _client.initialize();
  }

  // get token
  Future<void> getToken() async {
    String link =
        "https://Agora-Node-TokenServer.runamichaeljosh.repl.co/access_token?channelName=test";

    Response _response = await get(Uri.parse(link));
    Map data = jsonDecode(_response.body);
    print(data["token"]);

    tempToken = data["token"];

    // agora client data
    _client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: 'b7e7cf74098b4ef1afd95f138eaa90aa',
        channelName: 'test',
        tokenUrl: tempToken,
      ),
    );
  }

  AgoraClient get getClient => _client;
}
