import 'package:expo_in/componenets/r_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../componenets/login/normal_w_input.dart';
import '../../design-system/app_font.dart';
import '../../design-system/app_theme.dart';

class ForgotP extends StatefulWidget {
  const ForgotP({Key? key}) : super(key: key);

  @override
  State<ForgotP> createState() => _ForgotPState();
}

class _ForgotPState extends State<ForgotP> {
  final TextEditingController _controller = TextEditingController();
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

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_errorText == null) {
      try {
        // await FirebaseAuth.instance.createUserWithEmailAndPassword(
        //   email: _controller.text.toString(),
        //   password: _pcontroller.text.toString(),
        // );

        await FirebaseAuth.instance.sendPasswordResetEmail(email: _controller.text.toString());

        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email has been sent"),
            behavior: SnackBarBehavior.floating,
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 20, right: 24.0),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: AppTheme.subtitleAppColor,
                      ),
                      child: SizedBox(
                        height: 5.0,
                        width: MediaQuery.of(context).size.width * 0.15,
                      )),
                ),
              ),
              const Text(
                'Kindly,\nEnter your mail.',
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 42.0,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.signAppColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Please enter your mail to send password change request.',
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    fontSize: AppFont.inputHead,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.signAppColor.withOpacity(0.5),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 20),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: AppFont.subHead,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.signAppColor,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: NormalInputW(
                        submit: _submitted,
                        errorSt: _errorText,
                        controller: _controller,
                        text: _text,
                        hinty: 'Enter your email address',
                        txtType: TextInputType.emailAddress,
                        maxLiney: 1, maxChar: null, showp: false,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: RoundedButton(
                      title: 'Send Request',
                      colour: AppTheme.primeAppColor,
                      onPressed: () {
                        _controller.value.text.isNotEmpty
                            ? _submit()
                            : null;
                      },
                      shadow: AppTheme.shadowAppColor,
                      width: 100,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
