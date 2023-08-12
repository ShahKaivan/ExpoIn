import 'package:expo_in/componenets/create_route.dart';
import 'package:expo_in/componenets/r_btn.dart';
import 'package:expo_in/design-system/app_font.dart';
import 'package:expo_in/screens/loreg/reg1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../design-system/app_theme.dart';
import '../../screens/loreg/login.dart';

class OnboardBtm extends StatelessWidget {
  final String headtitle;
  final String subtitile;
  final VoidCallback vc;
  final PageController controller;
  final bool lastP;
  const OnboardBtm({
    super.key,
    required this.headtitle,
    required this.subtitile,
    required this.vc,
    required this.controller,
    required this.lastP,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: AppTheme.mainAppColor,
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30.0, left: 24, right: 24, bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    headtitle,
                    style: const TextStyle(
                      fontSize: AppFont.announceHead,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Satoshi',
                      color: AppTheme.subtitleAppColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      subtitile,
                      style: const TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: AppFont.topHead,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.signAppColor,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.04),
                child: lastP
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, bottom: 10.0, right: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Hero(
                                tag: 'register',
                                child: RoundedButton(
                                  title: 'Register',
                                  colour: AppTheme.signAppColor,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(createRoute(const RegScreen()));
                                  },
                                  shadow: AppTheme.signShadowAppColor,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: RoundedButton(
                              title: 'Login',
                              colour: AppTheme.primeAppColor,
                              onPressed: () {
                                showModalBottomSheet<dynamic>(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(42.0),
                                        topRight: Radius.circular(42.0),
                                      ),
                                    ),
                                    builder: (context) {
                                      return const LoginScreen();
                                    });
                              },
                              shadow: AppTheme.shadowAppColor,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmoothPageIndicator(
                            controller: controller,
                            count: 3,
                            effect: const WormEffect(
                                activeDotColor: AppTheme.primeAppColor,
                                dotColor: AppTheme.shadowAppColor),
                          ),
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: FloatingActionButton(
                              onPressed: vc,
                              backgroundColor: AppTheme.primeAppColor,
                              child: SvgPicture.asset(
                                'asset/icon/aleft.svg',
                                width: 30,
                                colorFilter: const ColorFilter.mode(
                                    AppTheme.mainAppColor, BlendMode.srcIn),
                                height: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
