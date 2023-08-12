import 'package:flutter/material.dart';

import '../../design-system/app_font.dart';
import '../../design-system/app_theme.dart';

class NoInt extends StatelessWidget {
  const NoInt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2,
                      bottom: 10),
                  child: Image(
                      image: Image.asset("asset/NOINT.png").image,
                      width: 350,
                      height: 350),
                ),
                const Text(
                  'No Internet!',
                  style: TextStyle(
                    fontFamily: 'ProductSans',
                    fontSize: AppFont.topHead,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.mainAppColor,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      top: 10, left: 70, right: 70, bottom: 200),
                  child: Text(
                    'Couldn\'t connect to internet.\nPlease check your network settings.\nThe App will refresh automatically once you connect to the Internet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'ProductSans',
                      fontSize: AppFont.subHead,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.signAppColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
