// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, camel_case_types, unused_import, avoid_unnecessary_containers, unused_field, unused_local_variable, avoid_print, empty_catches, file_names, use_build_context_synchronously, unnecessary_null_comparison, unrelated_type_equality_checks, no_leading_underscores_for_local_identifiers

import 'package:agora_uikit/models/agora_rtm_mute_request.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import '../model/chat_user.dart';

class FacebookSignInProvider extends ChangeNotifier {
  Map<String, dynamic>? _userData;
  Future<UserCredential?> facebookLogin() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ['email', 'public_profile']);

      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.token);

        final userData = await FacebookAuth.instance.getUserData(
          fields: "email,name,picture.width(200)",
        );
        _userData = userData;
        print(userData);

        notifyListeners();

        return await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.message}');
      rethrow;
    } catch (e) {
      print('Other Exception: $e');
      rethrow;
    }
    return null;
  }

  Future<void> facebookLogout() async {
    try {
      await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Logout Exception: $e');
      rethrow;
    }
  }
}
