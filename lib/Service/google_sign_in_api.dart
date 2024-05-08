import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'openid',
    'profile',
  ]);
  static Future<GoogleSignInAccount?> login() async {
    return await _googleSignIn.signIn();
  }

  static Future<bool> isUserSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  static Future logout() async {
    await _googleSignIn.disconnect();
  }

  static GoogleSignIn getObj() {
    return _googleSignIn;
  }

  static Future<GoogleSignInAccount?> getUserData() async {
    if (await isUserSignedIn()) {
      if (_googleSignIn.currentUser == null) {
        return await _googleSignIn.signInSilently();
      }
      return _googleSignIn.currentUser;
    }
    return null;
  }
}
