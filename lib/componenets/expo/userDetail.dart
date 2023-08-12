import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../design-system/app_font.dart';
import '../../design-system/app_theme.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class UserDetails extends StatefulWidget {
  final String name;
  final String parentKey;
  final String keyo;
  const UserDetails({
    Key? key,
    required this.name,
    required this.parentKey,
    required this.keyo,
  }) : super(key: key);

  @override
  State<UserDetails> createState() => _UsersDetailsState();
}

class _UsersDetailsState extends State<UserDetails> {
  late Map<String, dynamic> _profileData;
  bool _isLoading = false;

  Future<void> _getProfo() async {
    setState(() {
      _isLoading = true;
    });

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.name)
        .get();

    setState(() {
      _profileData = doc.data()!;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProfo();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 15,
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Slidable(
          key: Key(widget.keyo),
          endActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              // An action can be bigger than the others.
              onPressed: (value) {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("Expo")
                    .doc(widget.parentKey)
                    .collection(widget.name)
                    .doc(widget.keyo)
                    .delete();

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Product Deleted'),
                  behavior: SnackBarBehavior.floating,
                ));
              },
              backgroundColor: const Color(0xFFD16464),
              foregroundColor: Colors.white,
              icon: Icons.clear_rounded,
            ),
            SlidableAction(
              // An action can be bigger than the others.
              onPressed: (value) async {
                final link = WhatsAppUnilink(
                  phoneNumber: '+91 ${_profileData['wpno']}',
                  text: _profileData['custom_message'],
                );

                final url = Uri.parse('$link');

                await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              },
              backgroundColor: AppTheme.primeAppColor,
              foregroundColor: Colors.white,
              icon: Icons.chat,
            ),
          ]),
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.signAppColor),
                  color: AppTheme.mainAppColor,
                  boxShadow: const [
                    BoxShadow(
                      color: AppTheme.signAppColor,
                      spreadRadius: 0,
                      offset: Offset(4.5, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ExpansionTile(
                  iconColor: AppTheme.primeAppColor,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: NetworkImage(
                        _profileData['profile'],
                      ),
                      width: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    _profileData['name'],
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: AppFont.subHead,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.signAppColor,
                    ),
                  ),
                  subtitle: Text(
                    'Phone: ${_profileData['phone']}',
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.gryAppColorSec,
                    ),
                  ),
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 3 / 3.7,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                _profileData['address'],
                                style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: AppFont.subHead,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.cardPurAppColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (_profileData['wpno'].isNotEmpty) ...[
                                    const Text(
                                      'Whatsapp Number',
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: AppFont.subHead,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.signAppColor,
                                      ),
                                    ),
                                    Text(
                                      _profileData['wpno'],
                                      style: const TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: AppFont.subHead,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.cardPurAppColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (_profileData['website'].isNotEmpty) ...[
                                    const Text(
                                      'Website',
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: AppFont.subHead,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.signAppColor,
                                      ),
                                    ),
                                    Text(
                                      _profileData['website'],
                                      style: const TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: AppFont.subHead,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.cardPurAppColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (_profileData['mail'].isNotEmpty) ...[
                                    const Text(
                                      'Mail',
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: AppFont.subHead,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.signAppColor,
                                      ),
                                    ),
                                    Text(
                                      _profileData['mail'],
                                      style: const TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: AppFont.subHead,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.cardPurAppColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
