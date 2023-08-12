import 'package:expo_in/componenets/login/normal_input.dart';
import 'package:expo_in/screens/loreg/reg2.dart';
import 'package:flutter/material.dart';
import '../../componenets/create_route.dart';
import '../../componenets/r_btn.dart';
import '../../design-system/app_font.dart';
import '../../design-system/app_theme.dart';
import '../../design-system/constant.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final _text = '';

  late bool _submitted = false;

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _nameController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Name can\'t be empty';
    }
    if (text.length < 2) {
      return 'Name too short';
    }
    if (text.length > 30) {
      return 'Name too long';
    }
    // return null if the text is valid
    return null;
  }

  String? get _errorText2 {
    // at any time, we can get the text from _controller.value.text
    final text2 = _cityController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text2.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text2.length < 10) {
      return 'Phone no too short';
    }

    // return null if the text is valid
    return null;
  }

  String? get _errorText3 {
    // at any time, we can get the text from _controller.value.text
    final text3 = _addressController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text3.isEmpty) {
      return 'Address can\'t be empty';
    }
    if (text3.length < 2) {
      return 'Address too short';
    }
    if (text3.length > 100) {
      return 'Address too long';
    }

    // return null if the text is valid
    return null;
  }

  void _submit() {
    setState(() => _submitted = true);
    if (_errorText == null && _errorText2 == null) {
      Navigator.of(context).push(createRoute(RegScreen2(
        name: _nameController.text.trim(),
        phone: _cityController.text.trim(),
        address: _addressController.text.trim(),
      )));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _cityController.dispose();
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffffd260), Color(0xff14e380)],
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
                      'Tell us\nabout Yourself',
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
                        'So that we know how to call you. 👋',
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
                        'Name',
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
                          controller: _nameController,
                          text: _text,
                          hinty: 'Enter your full name',
                          txtType: TextInputType.name,
                          maxLiney: 1, maxChar: null, showp: false,
                        )),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10, top: 20),
                      child: Text(
                        'Phone',
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
                          controller: _cityController,
                          text: _text,
                          hinty: 'Enter your phone number',
                          txtType: TextInputType.number,
                          maxLiney: 1, maxChar: null, showp: false,
                        )),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10, top: 20),
                      child: Text(
                        'Address',
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
                          errorSt: _errorText3,
                          controller: _addressController,
                          text: _text,
                          hinty: 'Enter your address',
                          txtType: TextInputType.multiline,
                          maxLiney: 3, maxChar: null, showp: false,
                        )),
                    Hero(
                      tag: 'subby',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RoundedButton(
                          title: 'Continue',
                          colour: AppTheme.primeAppColor,
                          onPressed: () {
                            if (_nameController.value.text.isNotEmpty &&
                                _cityController.value.text.isNotEmpty &&
                                _addressController.value.text.isNotEmpty) {
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
