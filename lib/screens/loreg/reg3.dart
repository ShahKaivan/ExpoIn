import 'dart:io';

import 'package:expo_in/screens/loreg/regepass.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../componenets/create_route.dart';
import '../../componenets/r_btn.dart';
import '../../design-system/app_font.dart';
import '../../design-system/app_theme.dart';
import '../../design-system/constant.dart';

class RegScreen3 extends StatefulWidget {
  final String website;
  final String name;
  final String wpno;
  final String phone;
  final String address;
  const RegScreen3({Key? key, required this.name, required this.address, required this.website, required this.wpno, required this.phone}) : super(key: key);

  @override
  State<RegScreen3> createState() => _RegScreen3State();
}

class _RegScreen3State extends State<RegScreen3> {
  String profilePicLink = "";
  late File imageFile;
  bool _load = false;
  late bool submitted = false;

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

    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path);
        _load = true;
      });
    } else {
      setState(() => submitted = false);
    }
  }

  void _submit() async {
    if (imageFile != File('')) {
      setState(() => submitted = true);
      if (!mounted) return;
      Navigator.of(context)
          .push(createRoute(RegEPass(
        name: widget.name,
        website: widget.website,
        address: widget.address,
        photo: imageFile,
        wpno: widget.wpno,
        phone: widget.phone,
      )));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No image selected")));
    }
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffffe39c), Color(0xffBE6CFF)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 500.0, 18.0));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration:kImageBackgroundBlack.copyWith(),
          constraints: const BoxConstraints.expand(),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 24.0, top: 40, right: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'How do you\nlook like?',
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
                    'So that we can recognize you better 😊',
                    style: TextStyle(
                        fontFamily: 'ProductSans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        foreground: Paint()..shader = linearGradient),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Profile Picture',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: AppFont.subHead,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.mainAppColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            pickUploadProfilePic();
                          },
                          child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: _load == true
                                  ? CircleAvatar(
                                radius: 50,
                                backgroundImage: FileImage(imageFile),
                              )
                                  : const Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.black,
                              )
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                            fontFamily: 'ProductSans',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF2F2F2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Hero(
                  tag: 'subby',
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: RoundedButton(
                      title: 'Continue',
                      colour: AppTheme.primeAppColor,
                      onPressed: () {
                        _submit();
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
    );
  }
}
