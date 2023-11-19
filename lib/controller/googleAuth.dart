// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, camel_case_types, unused_import, avoid_unnecessary_containers, unused_field, unused_local_variable, avoid_print, empty_catches, file_names, use_build_context_synchronously, unnecessary_null_comparison, unrelated_type_equality_checks

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future<void> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      notifyListeners();
    } catch (error) {
      print("Google login error: $error");
    }
  }

  Future<void> googleLogout() async {
    await _googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
