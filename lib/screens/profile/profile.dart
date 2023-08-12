import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expo_in/componenets/profile/profo_top.dart';
import 'package:expo_in/design-system/app_font.dart';
import 'package:expo_in/screens/profile/EditPro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../componenets/create_route.dart';
import '../../componenets/profile/profo_info.dart';
import '../../design-system/app_theme.dart';
import '../../design-system/constant.dart';

class Profile extends StatefulWidget {
  final String? uid;
  final String type;
  const Profile({Key? key, required this.type, this.uid}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> _getProfo() async => FirebaseFirestore.instance
      .collection('Users')
      .doc(widget.type == "Quick-Scan"
          ? widget.uid
          : FirebaseAuth.instance.currentUser!.uid)
      .get();

  late final getProfo = _getProfo();
  final qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getProfo,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            String qrData = snapshot.data.data()['id'];

            return SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                floatingActionButton: widget.type == "Quick-Scan"
                    ? SizedBox(
                        width: 70,
                        height: 70,
                        child: FloatingActionButton(
                          onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser!;
                            final querySnapshot = await FirebaseFirestore
                                .instance
                                .collection("Users")
                                .doc(user.uid)
                                .collection("Expo")
                                .get();
                            bool nodup = false;

                            if (querySnapshot.docs.isNotEmpty) {
                              for (final documentSnapshot
                                  in querySnapshot.docs) {
                                final collectionName =
                                    documentSnapshot.data()['collectionName'];
                                final collectionRef = documentSnapshot.reference
                                    .collection("General");

                                if (collectionName == "General") {
                                  final docSnapshot =
                                      await collectionRef.doc(widget.uid).get();
                                  if (docSnapshot.exists) {
                                    setState(() {
                                      nodup = false;
                                    });
                                  } else {
                                    await collectionRef.doc(widget.uid).set({
                                      'key': widget.uid,
                                    });
                                    setState(() {
                                      nodup = true;
                                    });
                                  }
                                }
                              }
                            }

                            if (nodup) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Expo Data Added"),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Data already exists in Expo"),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          backgroundColor: Colors.black,
                          child: const Icon(Icons.save_alt_rounded),
                        ),
                      )
                    : null,
                appBar: AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 10),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  backgroundColor: AppTheme.mainAppColor,
                  elevation: 0,
                  actions: [
                    if (widget.type == "Personal") ...[
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0, top: 10),
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(createRoute(const EditPro()));
                            },
                            icon: SvgPicture.asset(
                              'asset/icon/Edit.svg',
                            )),
                      ),
                    ] else
                      ...[]
                  ],
                ),
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: kImageBackground.copyWith(),
                  child: Stack(children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 24, right: 24, bottom: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              child: ProfileTop(
                                mail: snapshot.data.data()['mail'],
                                name: snapshot.data.data()['name'],
                                profile: snapshot.data.data()['profile'],
                                phone: snapshot.data.data()['phone'],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.02,
                                  top: MediaQuery.of(context).size.height *
                                      0.04),
                              child: const Text(
                                'User\'s Information',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: AppFont.subTitle,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff0f1511),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.02,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: RepaintBoundary(
                                      key: qrKey,
                                      child: QrImage(
                                        data:
                                            qrData, //This is the part we give data to our QR
                                        //  embeddedImage: , You can add your custom image to the center of your QR
                                        //  semanticsLabel:'', You can add some info to display when your QR scanned
                                        size: 250,
                                        backgroundColor: Colors.white,
                                        version: QrVersions
                                            .auto, //You can also give other versions
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 16.0,
                                    right: 16,
                                    top: MediaQuery.of(context).size.height *
                                        0.02,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.02),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ListH(
                                      title: 'Whatsapp Number',
                                      subtitle: snapshot.data.data()['wpno'],
                                      icons: const Icon(
                                          Icons.mark_unread_chat_alt_rounded),
                                      mline: 1,
                                      isLastItem: false,
                                    ),
                                    ListH(
                                      title: 'Website',
                                      subtitle: snapshot.data.data()['website'],
                                      icons: const Icon(Icons.web),
                                      mline: 2,
                                      isLastItem: true,
                                    ),
                                    // ListH(
                                    //   title: 'Pan Number',
                                    //   subtitle: snapshot.data.data()['pan'],
                                    //   icons:
                                    //       const Icon(Icons.credit_card_rounded),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 16.0,
                                      right: 16,
                                      top: MediaQuery.of(context).size.height *
                                          0.02,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 60.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  "Address",
                                                  style: TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff444645)),
                                                ),
                                              ),
                                              Text(
                                                snapshot.data.data()['address'],
                                                style: const TextStyle(
                                                    fontFamily: 'Satoshi',
                                                    fontSize: AppFont.subHead,
                                                    color: Color(0xff0f1511),
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context)
                                                    .size
                                                    .height <=
                                                855
                                            ? 40
                                            : 60,
                                        height: MediaQuery.of(context)
                                                    .size
                                                    .height <=
                                                855
                                            ? 40
                                            : 60,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFdefaf0)),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.black,
                                            size: 30),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (snapshot.data?.data()?['custom_message'] !=
                                    null &&
                                snapshot.data?.data()?['custom_message'] !=
                                    "" &&
                                widget.type != "Quick-Scan") ...[
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 16.0,
                                      right: 16,
                                      top: MediaQuery.of(context).size.height *
                                          0.02,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 60.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Text(
                                                    "Custom Message for Whatsapp",
                                                    style: TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff444645),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data!.data()?[
                                                      'custom_message'],
                                                  style: const TextStyle(
                                                    fontFamily: 'Satoshi',
                                                    fontSize: AppFont.subHead,
                                                    color: Color(0xff0f1511),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .height <=
                                                  855
                                              ? 40
                                              : 60,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .height <=
                                                  855
                                              ? 40
                                              : 60,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFdefaf0),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.message_rounded,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
