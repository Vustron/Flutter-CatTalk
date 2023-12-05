// ignore_for_file: avoid_print
import 'package:agora_uikit/agora_uikit.dart';

class AgoraAPIProvider {
  // agora client data
  final AgoraClient _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: 'b7e7cf74098b4ef1afd95f138eaa90aa',
      channelName: 'Flutter-WeChat',
      tempToken:
          '007eJxTYLjP2xS3UVi5MOOvifHec8ohWYW1JQuOB8S43i1YFL3iu5MCQ5J5qnlymrmJgaVFkklqmmFiWoqlaZqhsUVqYqKlQWJi9cu81IZARobZVSZMjAwQCOLzMbjllJaUpBbphqc6ZySWMDAAAKQtI5I=',
    ),
  );

  // for initializing client
  Future<void> initializeAgora() async {
    await _client.initialize();
  }

  AgoraClient get getClient => _client;
}
