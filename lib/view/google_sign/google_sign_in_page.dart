import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prospros/Service/google_sign_in_api.dart';
import 'package:prospros/view/login.dart';

class GoogleSignedInPage extends StatefulWidget {
  const GoogleSignedInPage({super.key});

  @override
  State<GoogleSignedInPage> createState() => _GoogleSignedInPageState();
}

class _GoogleSignedInPageState extends State<GoogleSignedInPage> {
  GoogleSignInAccount? userInfo;
  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  loadUserData() async {
    userInfo = await GoogleSignInApi.getUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("User Name : ${userInfo?.displayName ?? ''}"),
              Text("User Email : ${userInfo?.email ?? ''}"),
              ElevatedButton(
                  onPressed: () async {
                    await GoogleSignInApi.logout();
                    Get.offAll(Login());
                  },
                  child: Text("Logout"))
            ]),
      ),
    );
  }
}
