import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgProvider;
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.profileImg});
  final String profileImg;

  @override
  Widget build(BuildContext context) {
    //return DefaultProfileAvatar();
    return profileImg.isEmpty
        ? DefaultProfileAvatar()
        : CachedNetworkImage(
            imageUrl: profileImg,
            imageBuilder: (context, imageProvider) => CircleAvatar(
                //backgroundColor: AppColor.homeAvatarColor,
                backgroundImage: imageProvider,
                radius: 20),
            placeholder: (context, url) =>
                DefaultProfileAvatar(), // CircularProgressIndicator(),
            errorWidget: (context, url, error) => DefaultProfileAvatar());
  }
}

class DefaultProfileAvatar extends StatelessWidget {
  const DefaultProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColor.homeAvatarColor,
      backgroundImage: svgProvider.Svg(AppImage.profile),
      radius: 20,
      // child: const Text("AD",
      //     style: TextStyle(fontSize: 14, color: Color(0xFFF4F5FC)))
    );
  }
}

class CountryFlag extends StatelessWidget {
  const CountryFlag({super.key, required this.flagImg});
  final String flagImg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: CachedNetworkImage(
          imageUrl: flagImg,
          imageBuilder: (context, imageProvider) => Container(
                width: 20,
                height: 14,

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black.withOpacity(.4), width: 1),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fill)),
                //backgroundImage: imageProvider,
              ),
          placeholder: (context, url) => SvgPicture.asset(
              AppImage.communityCountry,
              width: 20,
              height: 20), // CircularProgressIndicator(),
          errorWidget: (context, url, error) => SvgPicture.asset(
              AppImage.communityCountry,
              width: 20,
              height: 20)),
    );
  }
}
