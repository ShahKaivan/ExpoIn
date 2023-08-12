import 'package:expo_in/design-system/app_font.dart';
import 'package:expo_in/design-system/app_theme.dart';
import 'package:expo_in/design-system/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class RoundedButtonH extends StatelessWidget {
  const RoundedButtonH(
      {Key? key,
      required this.subtitle,
      required this.colour,
      required this.title,
      required this.onPressed,
      required this.shadow,
      required this.image,
      required this.height,
      required this.width,
      required this.colour2})
      : super(key: key);

  final Color colour;
  final Color colour2;
  final Color shadow;
  final String title;
  final String subtitle;
  final Image image;
  final VoidCallback onPressed;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height, bottom: width),
      child: Bounce(
        onPressed: onPressed,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  colour,
                  colour2,
                ]),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: shadow,
                blurRadius: 25.0,
                spreadRadius: 0,
                offset: const Offset(0.0, 15.0),
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: title,
                        style: const TextStyle(
                          fontFamily: 'Satoshi',
                          color: AppTheme.mainAppColor,
                          fontWeight: FontWeight.w700,
                          fontSize: AppFont.topHead,
                        ),
                        children: [
                          TextSpan(
                            text: subtitle,
                            style: const TextStyle(
                              fontFamily: 'Satoshi',
                              color: AppTheme.mainAppColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(child: image),
            ],
          ),
        ),
      ),
    );
  }
}
