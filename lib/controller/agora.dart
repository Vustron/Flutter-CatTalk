// ignore_for_file: avoid_print

import 'package:agora_uikit/agora_uikit.dart';

class AgoraAPIProvider {
  // agora client data
  final AgoraClient _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: 'b7e7cf74098b4ef1afd95f138eaa90aa',
      channelName: 'Flutter-WeChat',
      tempToken:
          '007eJxTYKi+atDwxsKPz8Q3ypD7UrEyX5a2iXm/XlV5t68a343qagWGJPNU8+Q0cxMDS4skk9Q0w8S0FEvTNENji9TEREuDxMQe3dzUhkBGhoVGi1kYGSAQxOdjcMspLSlJLdINT3XOSCxhYAAASpkfaQ==',
    ),
  );

  // for initializing client
  Future<void> initializeAgora() async {
    await _client.initialize();
  }

  AgoraClient get getClient => _client;
}
