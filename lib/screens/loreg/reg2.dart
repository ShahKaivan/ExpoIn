import 'package:expo_in/screens/loreg/reg3.dart';
import 'package:flutter/material.dart';
import '../../componenets/create_route.dart';
import '../../componenets/login/normal_input.dart';
import '../../componenets/r_btn.dart';
import '../../design-system/app_font.dart';
import '../../design-system/app_theme.dart';
import '../../design-system/constant.dart';

class RegScreen2 extends StatefulWidget {
  final String name;
  final String phone;
  final String address;
  const RegScreen2(
      {Key? key, required this.name, required this.phone, required this.address})
      : super(key: key);

  @override
  State<RegScreen2> createState() => _RegScreen2State();
}

class _RegScreen2State extends State<RegScreen2> {
  final TextEditingController _wpnoController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  final _text = '';

  late bool _submitted = false;

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _wpnoController.value.text;
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

  String? get _errorText2 {
    // at any time, we can get the text from _controller.value.text
    final text2 = _websiteController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code

    if (RegExp(r'(?:(?:https?|ftp)://)?[\w/\-?=%.]+\.[\w/\-?=%.]+').hasMatch(text2)) {
      return null;
    } else {
      return 'Invalid URL';
    }
  }

  void _submit() {
    setState(() => _submitted = true);
    if (_errorText == null && _errorText2 == null) {
      Navigator.of(context).push(createRoute(RegScreen3(
        name: widget.name,
        website: _websiteController.text.trim(),
        wpno: _wpnoController.text.trim(),
        phone: widget.phone,
        address: widget.address,
      )));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _websiteController.dispose();
    _wpnoController.dispose();
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffff9ca0), Color(0xffBE6CFF)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 500.0, 18.0));

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
                      'Fill in some\nTernary Details',
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
                        'So that people can reach out to you. ✅',
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
                        'Website URL',
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
                          controller: _websiteController,
                          text: _text,
                          hinty: 'Enter the URL of your website',
                          txtType: TextInputType.name,
                          maxLiney: 1,
                          showp: false, maxChar: null,
                        )),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10, top: 20),
                      child: Text(
                        'Whatsapp Number',
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
                          controller: _wpnoController,
                          text: _text,
                          hinty: 'Enter your mobile number with Whatsapp',
                          txtType: TextInputType.text,
                          maxLiney: 1,
                          maxChar: null, showp: false,
                        )),
                    Hero(
                      tag: 'subby',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RoundedButton(
                          title: 'Continue',
                          colour: AppTheme.primeAppColor,
                          onPressed: () {
                            if (_websiteController.value.text.isNotEmpty &&
                                _wpnoController.value.text.isNotEmpty) {
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
