import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expo_in/componenets/create_route.dart';
import 'package:expo_in/screens/expo.dart';
import 'package:expo_in/screens/scanner/quick_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../componenets/home/custombtn.dart';
import '../componenets/home/h_btn.dart';
import '../design-system/app_font.dart';
import '../design-system/app_theme.dart';
import '../design-system/constant.dart';

Future<void> _asyncProfo() async => FirebaseFirestore.instance
    .collection('Users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final asyncProfo = _asyncProfo();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: asyncProfo,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                extendBodyBehindAppBar: true,
                body: Container(
                    decoration: kImageBackground.copyWith(),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24.0, top: 20, right: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      CustomButtonTest(),
                                      // Image(
                                      //   image:
                                      //   const AssetImage('asset/A.png'),
                                      //   height: MediaQuery.of(context)
                                      //       .size
                                      //       .height *
                                      //       0.1,
                                      //   width: MediaQuery.of(context)
                                      //       .size
                                      //       .width *
                                      //       0.25,
                                      // ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Glad you\'e here,\n',
                                    style: const TextStyle(
                                      fontSize: AppFont.announceHead,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Satoshi',
                                      color: AppTheme.subtitleAppColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: snapshot.data.data()['name'],
                                        style: const TextStyle(
                                          height: 1.1,
                                          fontSize: AppFont.topHead,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Satoshi',
                                          color: AppTheme.signAppColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.025),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          // border: Border.all(color: AppTheme.primeAppColor, width: 2.5),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'asset/icon/Bell2.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.435,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.22,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 30, left: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('Notice')
                                                    .doc('0')
                                                    .get(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot.hasData &&
                                                      snapshot.data.data()[
                                                              'notice'] !=
                                                          "") {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10.0,
                                                              right: 10),
                                                      child: Text(
                                                        snapshot.data
                                                            .data()['notice'],
                                                        style: const TextStyle(
                                                          fontFamily: 'Satoshi',
                                                          color: AppTheme
                                                              .cardPurAppColor,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: AppFont
                                                              .announceHead,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 10.0,
                                                          right: 10),
                                                      child: Text(
                                                        'No new\nNotice Today!',
                                                        style: TextStyle(
                                                          fontFamily: 'Satoshi',
                                                          color: AppTheme
                                                              .cardPurAppColor,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: AppFont
                                                              .announceHead,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0),
                                                child: SvgPicture.asset(
                                                  'asset/icon/Warn.svg',
                                                  width: 45,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Bounce(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(createRoute(const QuickScan()));
                                        },
                                        duration:
                                            const Duration(milliseconds: 100),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // color: Color(0xffffcc00),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                  'asset/icon/Pdf1.png'),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.435,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.22,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30, left: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 40.0),
                                                  child: Text(
                                                    'Quick-Scan',
                                                    style: TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      color:
                                                          AppTheme.mainAppColor,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 20.0),
                                                  child: SvgPicture.asset(
                                                    'asset/icon/Vaid.svg',
                                                    width: 45,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                RoundedButtonH(
                                  subtitle:
                                      "Create or Checkout\nall of your Expo",
                                  colour: const Color(0xFFff9864),
                                  title: "Expo\n",
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(createRoute(const Expo()));
                                  },
                                  shadow: const Color(0xffe4f8f8),
                                  image: const Image(
                                      width: 225,
                                      image: AssetImage('asset/Expo.png')),
                                  height: 20,
                                  width: 5,
                                  colour2: const Color(0xFFff9864),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.05),
                                  child: const Text(
                                    'Powerful\nExperience\'s\n',
                                    style: TextStyle(
                                      height: 1.1,
                                      fontSize: AppFont.devSign,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Satoshi',
                                      color: AppTheme.signShadowAppColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                  child: const Text(
                                    "Crafted with ❤ by Devlomers",
                                    style: TextStyle(
                                      fontSize: AppFont.announceHead,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Satoshi',
                                      color: AppTheme.signShadowAppColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // DraggableScrollableSheet(
                          //     minChildSize: 0.5,
                          //     maxChildSize: 1,
                          //     snap: true,
                          //     snapSizes: const [0.5, 1],
                          //     initialChildSize: 0.5,
                          //     builder: (BuildContext context,
                          //         ScrollController scrollController) {
                          //       return Container();
                          //     }),
                        ],
                      ),
                    )),
              ),
            );
          } else {
            return Container(
              decoration: kImageBackground.copyWith(),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
