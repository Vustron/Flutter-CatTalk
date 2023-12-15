// ignore_for_file: avoid_print
import 'package:agora_uikit/agora_uikit.dart';

class AgoraAPIProvider {
  // agora client data
  final AgoraClient _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: 'b7e7cf74098b4ef1afd95f138eaa90aa',
      channelName: 'Flutter-WeChat',
      tempToken:
          '007eJxTYDhXXs7bFV0Sxv/KpDLDsvyro3Sng8LOivm61VvlRNO/aCkwJJmnmienmZsYWFokmaSmGSampViaphkaW6QmJloaJCaunVud2hDIyLAxPZWFkQECQXw+Brec0pKS1CLd8FTnjMQSBgYACCMhzw==',
    ),
  );

  // for initializing client
  Future<void> initializeAgora() async {
    await _client.initialize();
  }

  AgoraClient get getClient => _client;
}

// // agora client data
// late AgoraClient _client;
// // init temp token
// String tempToken = "";

// // for initializing client
// Future<void> initializeAgora() async {
//   await _client.initialize();
// }

// // get token
// Future<void> getToken() async {
//   String link =
//       "https://agora-node-tokenserver.runamichaeljosh.repl.co/access_token?channelName=test&role=subscriber&uid=1234&expireTime";

//   Response _response = await get(Uri.parse(link));
//   Map data = jsonDecode(_response.body);
//   print(data["token"]);

//   tempToken = data["token"];

//   // agora client data
//   _client = AgoraClient(
//     agoraConnectionData: AgoraConnectionData(
//       appId: 'b7e7cf74098b4ef1afd95f138eaa90aa',
//       channelName: 'test',
//       tokenUrl: tempToken,
//     ),
//   );
// }
