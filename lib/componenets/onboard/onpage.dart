import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../design-system/constant.dart';
import 'onboardbtm.dart';

class OnPage extends StatelessWidget {
  final String imgi;
  final String heady;
  final String subby;
  final VoidCallback vc;
  final PageController wt;
  final bool lastp;
  const OnPage(
      {Key? key, required this.imgi, required this.heady, required this.subby, required this.vc, required this.wt, required this.lastp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: kImageBackground.copyWith(),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imgi),
                    fit: BoxFit.cover,
                  ),
                )),
            Positioned(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: OnboardBtm(
                headtitle: heady,
                subtitile: subby, vc: vc, controller: wt, lastP: lastp,
              ),
            )),
          ],
        ));
  }
}
