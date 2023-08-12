import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../componenets/login/normal_input.dart';
import '../../componenets/r_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../design-system/app_font.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../design-system/app_theme.dart';
import '../../design-system/constant.dart';
import '../home.dart';

class RegEPass extends StatefulWidget {
  final String website;
  final String name;
  final String wpno;
  final String phone;
  final String address;
  final File photo;
  const RegEPass({Key? key, required this.website, required this.name, required this.wpno, required this.phone, required this.address, required this.photo}) : super(key: key);

  @override
  State<RegEPass> createState() => _RegEPassState();
}

class _RegEPassState extends State<RegEPass> {

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _pcontroller = TextEditingController();

  bool passwordVisible=false;
  String? uid;
  String profilePicLink = '';

  final _text = '';
  late bool _submitted = false;
  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _controller.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Email can\'t be empty';
    }
    if (RegExp(
        r"^[a-zA-Z\d.a-zA-Z!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+")
        .hasMatch(text)) {
      return null;
    } else {
      return 'Invalid Email';
    }
  }

  String? get _errorText2 {
    // at any time, we can get the text from _controller.value.text
    final text = _pcontroller.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 8) {
      return 'Too short';
    }
    // return null if the text is valid
    return null;
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_errorText == null && _errorText2 == null) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _controller.text.toString(),
          password: _pcontroller.text.toString(),
        ).then((value) async {
          if (value.user != null) {
            uid = value.user!.uid;

            Reference ref = FirebaseStorage.instance.ref().child(
                "User-Profiles/${FirebaseAuth.instance.currentUser!.uid}/profile.png");

            await ref.putFile(widget.photo);

            await ref.getDownloadURL().then((value) async {
              setState(() {
                profilePicLink = value;
              });
            });

            FirebaseFirestore.instance.collection('Users').doc(uid).set({
              'id': uid,
              'name': widget.name,
              'wpno': widget.wpno,
              'phone': widget.phone,
              'profile': profilePicLink,
              'website': widget.website,
              'address': widget.address,
              'mail': _controller.text,
            });
          }
        });

        if (!mounted) return;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
                  (route) => false);

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          if(!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('The password provided is too weak'),
                behavior: SnackBarBehavior.floating,
              ),
            );
        } else if (e.code == 'email-already-in-use') {
          if(!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Wrong password provided for that user'),
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      } catch (e) {
        if(!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              behavior: SnackBarBehavior.floating,
            ),
          );
      }
    }
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffff9ca0), Color(0xffBE6CFF)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 500.0, 18.0));

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pcontroller.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.signAppColor,
        appBar: AppBar(
          backgroundColor: AppTheme.signAppColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: kImageBackgroundBlack.copyWith(),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                const EdgeInsets.only(left: 24.0, top: 30, right: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Fill in your\nMail and Password',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: AppFont.megaHead,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.mainAppColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 50),
                      child: Text(
                        'So that you can use it to login to your account.',
                        style: TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: AppFont.subTitle,
                            fontWeight: FontWeight.w500,
                            foreground: Paint()..shader = linearGradient),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Mail',
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: AppFont.subHead,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.mainAppColor,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: NormalInput(
                          submit: _submitted,
                          errorSt: _errorText,
                          controller: _controller,
                          text: _text,
                          hinty: 'Enter your email address',
                          txtType: TextInputType.emailAddress,
                          maxLiney: 1, maxChar: null, showp: false,
                        )),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10, top: 20),
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: AppFont.subHead,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.mainAppColor,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: NormalInput(
                          submit: _submitted,
                          errorSt: _errorText2,
                          controller: _pcontroller,
                          icob: IconButton(
                            color: AppTheme.primeAppColor,
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                    () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                          text: _text,
                          hinty: 'Enter your password',
                          txtType: TextInputType.visiblePassword,
                          maxLiney: 1, maxChar: null, showp: passwordVisible,
                        )),
                    Hero(
                      tag: 'subby',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RoundedButton(
                          title: 'Continue',
                          colour: AppTheme.primeAppColor,
                          onPressed: () {
                            if (_controller.value.text.isNotEmpty &&
                                _pcontroller.value.text.isNotEmpty) {
                              _submit();
                            }
                          },
                          width: MediaQuery.of(context).size.width,
                          shadow: null,
                        ),
                      ),
                    ),
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
