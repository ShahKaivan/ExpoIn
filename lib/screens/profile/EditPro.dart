import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../design-system/app_font.dart';
import '../../design-system/app_theme.dart';
import '../../design-system/constant.dart';
import '../home.dart';

Future<void> _getData() async => FirebaseFirestore.instance
    .collection('Users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get();

class EditPro extends StatefulWidget {
  const EditPro({Key? key}) : super(key: key);

  @override
  State<EditPro> createState() => _EditProState();
}

class _EditProState extends State<EditPro> {
  final TextEditingController _webController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _wpnoController = TextEditingController();
  final TextEditingController _ctextController = TextEditingController();

  final _text = '';

  String profilePicLink = '';

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      if (profilePicLink == '') {
        setState(() {
          profilePicLink = value.data()!['profile'];
        });
      }
      setState(() {
        _webController.text = value.data()!['website'];
        _phoneController.text = value.data()!['phone'];
        _addressController.text = value.data()!['address'];
        _wpnoController.text = value.data()!['wpno'];
        _ctextController.text = value.data()!['custom_message'];
      });
    });
  }

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 100,
    );

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppTheme.primeAppColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      Reference ref = FirebaseStorage.instance.ref().child(
          "User-Profiles/${FirebaseAuth.instance.currentUser!.uid}/$image.png");
      if (croppedFile != null) {
        await ref.putFile(File(croppedFile.path));

        ref.getDownloadURL().then((value) async {
          setState(() {
            profilePicLink = value;
          });
        });
      }
    });
  }

  late bool _submitted = false;

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _webController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (RegExp(r'(?:(?:https?|ftp)://)?[\w/\-?=%.]+\.[\w/\-?=%.]+')
        .hasMatch(text)) {
      return null;
    } else {
      return 'Invalid URL';
    }
  }

  String? get _errorText2 {
    // at any time, we can get the text from _controller.value.text
    final text = _phoneController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 10) {
      return 'Mobile number too short';
    }

    return null;
  }

  String? get _errorText3 {
    // at any time, we can get the text from _controller.value.text
    final text = _addressController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Address can\'t be empty';
    }
    if (text.length < 10) {
      return 'Too short';
    }
    // return null if the text is valid
    return null;
  }

  String? get _errorText4 {
    // at any time, we can get the text from _controller.value.text
    final text1 = _wpnoController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text1.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text1.length < 10) {
      return 'Whatsapp Number too short';
    }

    return null;
  }

  String? get _errorText5 {
    // at any time, we can get the text from _controller.value.text
    // final text = _ctextController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _webController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _wpnoController.dispose();
    _ctextController.dispose();
  }

  late final getData = _getData();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Scaffold(
                floatingActionButton: SizedBox(
                  width: 70,
                  height: 70,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() => _submitted = true);
                      if (_errorText == null &&
                              _errorText2 == null &&
                              _errorText3 == null &&
                              _errorText4 == null ||
                          _errorText5 == null) {
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'phone': _phoneController.value.text,
                          'website': _webController.value.text,
                          'address': _addressController.value.text,
                          'wpno': _wpnoController.value.text,
                          'custom_message': _ctextController.value.text,
                          'profile': profilePicLink,
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()),
                            (route) => false);
                      }
                    },
                    backgroundColor: Colors.black,
                    child: SvgPicture.asset(
                      'asset/icon/Update.svg',
                      width: 30,
                      colorFilter: const ColorFilter.mode(
                          AppTheme.mainAppColor, BlendMode.srcIn),
                      height: 30,
                    ),
                  ),
                ),
                appBar: AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 10),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  backgroundColor: AppTheme.mainAppColor,
                  elevation: 0,
                  title: const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: AppFont.inputHead,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.signAppColor,
                      ),
                    ),
                  ),
                  centerTitle: true,
                ),
                body: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Container(
                    decoration: kImageBackground.copyWith(),
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 30),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30, left: 24.0, right: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 40),
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        Hero(
                                          tag: 'profile',
                                          child: CircleAvatar(
                                            radius: 60,
                                            foregroundImage: profilePicLink ==
                                                    snapshot.data
                                                        .data()['photo']
                                                ? NetworkImage(snapshot.data
                                                    .data()['photo'])
                                                : NetworkImage(profilePicLink),
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                pickUploadProfilePic();
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppTheme.primeAppColor,
                                                ),
                                                child: const Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Website',
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.signAppColor,
                                    ),
                                  ),
                                ),
                                TextField(
                                    decoration: kDecorW.copyWith(
                                        hintText: 'Enter your website URL',
                                        errorText:
                                            _submitted ? _errorText : null,
                                        counterStyle: const TextStyle(
                                            color: AppTheme.signAppColor)),
                                    keyboardType: TextInputType.name,
                                    style: const TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: AppFont.inputHead,
                                      fontWeight: FontWeight.w400,
                                      color: AppTheme.signAppColor,
                                    ),
                                    controller: _webController,
                                    onChanged: (text) => setState(() => _text),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(15),
                                    ]),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10, top: 20),
                                  child: Text(
                                    'Phone',
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.signAppColor,
                                    ),
                                  ),
                                ),
                                TextField(
                                  decoration: kDecorW.copyWith(
                                    hintText: 'Enter your dln number',
                                    errorText: _submitted ? _errorText2 : null,
                                  ),
                                  keyboardType: TextInputType.name,
                                  style: const TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontSize: AppFont.inputHead,
                                    fontWeight: FontWeight.w400,
                                    color: AppTheme.signAppColor,
                                  ),
                                  controller: _phoneController,
                                  onChanged: (text) => setState(() => _text),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(
                                        top: 20.0, bottom: 10.0),
                                    child: Divider()),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    'Personal Information',
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: AppFont.topHead,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.signAppColor,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Address',
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.signAppColor,
                                    ),
                                  ),
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    errorStyle: const TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 10,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0x801B1B1B), width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppTheme.primeAppColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    errorText: _submitted ? _errorText3 : null,
                                    hintText: "Enter your address",
                                    hintStyle: const TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: AppFont.inputHead,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0x801B1B1B),
                                    ),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  style: const TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontSize: AppFont.inputHead,
                                    fontWeight: FontWeight.w400,
                                    color: AppTheme.signAppColor,
                                  ),
                                  controller: _addressController,
                                  onChanged: (text) => setState(() => _text),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 10, top: 20),
                                      child: Text(
                                        'Whatsapp Number',
                                        style: TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.signAppColor,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      decoration: kDecorW.copyWith(
                                          hintText:
                                              'Enter your whatsapp number',
                                          errorText:
                                              _submitted ? _errorText4 : null,
                                          counterStyle: const TextStyle(
                                              color: Color(0x801B1B1B))),
                                      keyboardType: TextInputType.name,
                                      style: const TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: AppFont.inputHead,
                                        fontWeight: FontWeight.w400,
                                        color: AppTheme.signAppColor,
                                      ),
                                      controller: _wpnoController,
                                      onChanged: (text) =>
                                          setState(() => _text),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 10, top: 20),
                                      child: Text(
                                        'Custom Message for Whatsapp',
                                        style: TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.signAppColor,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        errorStyle: const TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontSize: 10,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0x801B1B1B),
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppTheme.primeAppColor,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        hintText: 'Enter your message',
                                        errorText:
                                            _submitted ? _errorText5 : null,
                                        hintStyle: const TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontSize: AppFont.inputHead,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0x801B1B1B),
                                        ),
                                      ),
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 4,
                                      style: const TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: AppFont.inputHead,
                                        fontWeight: FontWeight.w400,
                                        color: AppTheme.signAppColor,
                                      ),
                                      controller: _ctextController,
                                      onChanged: (text) =>
                                          setState(() => _text),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
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
