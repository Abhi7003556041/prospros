import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AppleSignInApi {
  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  static String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<AuthorizationCredentialAppleID?> signIn() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // webAuthenticationOptions: WebAuthenticationOptions(
        //   // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        //   clientId:
        //       '441014505030-4darahl8ugivflogv3om2sju3qe7gehi.apps.googleusercontent.com',

        //   redirectUri:
        //       // For web your redirect URI needs to be the host of the "current page",
        //       // while for Android you will be using the API server that redirects back into your app via a deep link
        //       kIsWeb
        //           ? Uri.parse('https://www.google.com}/')
        //           : Uri.parse(
        //               'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
        //             ),
        // ),
        // nonce: nonce
      );

      // // Create an `OAuthCredential` from the credential returned by Apple.
      // final oauthCredential = OAuthProvider("apple.com").credential(
      //   idToken: credential.identityToken,
      //   rawNonce: rawNonce,
      // );

      // // Sign in the user with Firebase. If the nonce we generated earlier does
      // // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      // final result =
      //     await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      // // return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      // print(result.user!.displayName.toString());
      // print(result.user!.email.toString());
      // print(result.user!.uid.toString());
      // print(result.additionalUserInfo!.username.toString());

      return credential;
    } catch (e) {
      print(e.toString());
      if (e.toString().contains("AuthorizationErrorCode.canceled")) {
        //use rejected
      } else if (e.toString().contains("AuthorizationErrorCode.unknown")) {
        //somtimes plgin showing this error when we are going to attempt login first time
        printRed(e.toString());
      } else {
        Get.showSnackbar(GetSnackBar(
            message: e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
      return null;
    }
  }

  static logout() async {
    // await FirebaseAuth.instance.signOut();
  }
}
