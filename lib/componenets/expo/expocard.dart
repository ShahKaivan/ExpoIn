import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import '../../design-system/app_font.dart';
import '../../design-system/app_theme.dart';
import '../../screens/expo_list.dart';
import '../create_route.dart';



class ExpoList extends StatelessWidget {
  final String keyo;
  final String name;
  ExpoList({Key? key, required this.keyo, required this.name})
      : super(key: key);

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 24, right: 24),
        child: Bounce(
          onPressed: () {
            Navigator.of(context).push(createRoute(ECardList(name: name, keyo: keyo)));
          },
          duration: const Duration(milliseconds: 100),
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('asset/expo_btn.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            height: MediaQuery.of(context).size.height * 0.25,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Satoshi',
                        color: AppTheme.mainAppColor,
                        fontWeight: FontWeight.w700,
                        fontSize: AppFont.topHead,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
