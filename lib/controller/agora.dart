// ignore_for_file: avoid_print
import 'package:agora_uikit/agora_uikit.dart';

class AgoraAPIProvider {
  // agora client data
  final AgoraClient _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: 'b7e7cf74098b4ef1afd95f138eaa90aa',
      channelName: 'test',
      tokenUrl: "https://Agora-Node-TokenServer.runamichaeljosh.repl.co",
    ),
  );

  // for initializing client
  Future<void> initializeAgora() async {
    await _client.initialize();
  }

  AgoraClient get getClient => _client;
}
