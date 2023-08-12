import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../componenets/expo/expocard.dart';
import '../design-system/app_font.dart';
import '../design-system/app_theme.dart';
import '../design-system/constant.dart';

Stream<QuerySnapshot> _asyncProfo() =>
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Expo")
        .snapshots();


class Expo extends StatefulWidget {
  const Expo({Key? key}) : super(key: key);

  @override
  State<Expo> createState() => _ExpoState();
}

class _ExpoState extends State<Expo> {

  Widget? productTile;

  late final getData = _asyncProfo();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: getData,
        builder: (context, snapshot) {
          final tilesList = <Widget>[];

          if (snapshot.hasData) {
            snapshot.data.docs.forEach((value) {
              final productTile =
              ExpoList(name: value.data()['collectionName'], keyo: value.id);

              tilesList.add(productTile);
            });

            tilesList.insert(
              0,
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24.0, bottom: 60),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  mainAxisAlignment:
                  MainAxisAlignment.start,
                  children: const [
                    Text(
                      "The Expos",
                      style: TextStyle(
                        fontSize: AppFont.megaHead,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );

            return SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 10),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  backgroundColor: AppTheme.mainAppColor,
                  elevation: 0,
                ),
                body: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Container(
                    decoration: kImageBackground.copyWith(),
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20, top: 40),
                        physics: const BouncingScrollPhysics(),
                        itemCount: tilesList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return snapshot.data.size == 0
                              ? Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height *
                                    0.07),
                            child: Center(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 60, bottom: 10),
                                    child: Image(
                                        image: Image.asset(
                                            "asset/NODATA.png")
                                            .image,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            4,
                                        height: MediaQuery.of(context)
                                            .size
                                            .height *
                                            0.4),
                                  ),
                                  const Text(
                                    'Expo is Empty!',
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primeAppColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                      left: 90,
                                      right: 90,
                                    ),
                                    child: Text(
                                      'Try adding Users to the Expo!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: AppFont.subHead,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1B1B1B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              : tilesList.isEmpty
                              ? Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(
                                    top: 50, bottom: 10),
                                child: Image(
                                    image: Image.asset(
                                        "asset/NODATA.png")
                                        .image,
                                    width: 230,
                                    height: 230),
                              ),
                              const Text(
                                'No results found',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: AppFont.topHead,
                                  fontWeight: FontWeight.bold,
                                  color:
                                  AppTheme.primeAppColor,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 70,
                                    right: 70,
                                    bottom: 200),
                                child: Text(
                                  'We couldn\'t find what you searched for.\nTry searching again.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontSize: AppFont.subHead,
                                    fontWeight:
                                    FontWeight.w500,
                                    color:
                                    AppTheme.signAppColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                              : AnimationConfiguration
                              .staggeredList(
                            position: index,
                            duration: const Duration(
                                milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: tilesList[index],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
