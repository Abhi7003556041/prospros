import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/fb_sign_in_api.dart';
import 'package:prospros/model/login/fb_user.dart';
import 'package:prospros/view/login.dart';

class FbSignedInPage extends StatefulWidget {
  const FbSignedInPage({super.key});

  @override
  State<FbSignedInPage> createState() => _FbSignedInPageState();
}

class _FbSignedInPageState extends State<FbSignedInPage> {
  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  FbUser? user;

  loadUserData() async {
    user = await FacebookSignInApi.getProfileDetails();
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
              Text("Name : ${user?.name ?? ''}"),
              Text("Email : ${user?.email ?? ''}"),
              ElevatedButton(
                  onPressed: () async {
                    await FacebookSignInApi.logout();
                    Get.offAll(Login());
                  },
                  child: Text("Logout"))
            ]),
      ),
    );
  }
}
