import 'package:agora_uikit/agora_uikit.dart';

class AgoraAPIProvider {
  // agora client data
  final AgoraClient _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: 'b7e7cf74098b4ef1afd95f138eaa90aa',
      channelName: 'Flutter-WeChat',
      tempToken:
          '007eJxTYCibXnLuj36+9Rm2eP266VO1ZMKCfAwDL71n25p7NH3L7Y0KDEnmqebJaeYmBpYWSSapaYaJaSmWpmmGxhapiYmWBomJNpMyUxsCGRneM3kyMzJAIIjPx+CWU1pSklqkG57qnJFYwsAAAIszIuc=',
    ),
  );

  // for initializing client
  Future<void> initializeAgora() async {
    await _client.initialize();
  }

  AgoraClient get getClient => _client;
}
