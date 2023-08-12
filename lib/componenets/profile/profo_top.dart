import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../design-system/app_font.dart';
import '../../design-system/app_theme.dart';

class ProfileTop extends StatelessWidget {
  final String profile;
  final String name;
  final String mail;
  final String phone;
  const ProfileTop({
    super.key, required this.profile, required this.name, required this.mail, required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
          child: Center(
            child: Hero(
              tag: 'profile',
              child: CircleAvatar(
                radius: 60,
                foregroundImage:
                CachedNetworkImageProvider(profile),
              ),
            ),
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.only(bottom: 5),
          child: Text(
            name,
            style: const TextStyle(
              fontFamily: 'Satoshi',
              color: AppTheme.signAppColor,
              fontSize: AppFont.subTitle,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            '+91 $phone',
            style: const TextStyle(
              fontFamily: 'Satoshi',
              color: Color(0xff797a74),
              fontSize: AppFont.subHead,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            mail,
            style: const TextStyle(
              fontFamily: 'Satoshi',
              color: Color(0xff797a74),
              fontSize: AppFont.subHead,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}