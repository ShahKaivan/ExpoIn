import 'package:expo_in/componenets/login/normal_w_input.dart';
import 'package:expo_in/screens/loreg/forgot_p.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../componenets/r_btn.dart';
import '../../design-system/app_font.dart';
import '../../design-system/app_theme.dart';
import '../home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _pcontroller = TextEditingController();

  bool passwordVisible=false;

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
        // await FirebaseAuth.instance.createUserWithEmailAndPassword(
        //   email: _controller.text.toString(),
        //   password: _pcontroller.text.toString(),
        // );

        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _controller.text.toString(),
            password: _pcontroller.text.toString()
        );

        if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
                (route) => false);

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _pcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Container(
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
                  'Hello,\nKindly Login.',
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    fontSize: 42.0,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.signAppColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'If you are new / click',
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: AppFont.inputHead,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.signAppColor.withOpacity(0.5),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.transparent)),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: AppFont.inputHead,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primeAppColor,
                          ),
                        ),
                        onPressed: () {
                          // final navigator = Navigator.of(context);
                          //
                          // navigator.pushAndRemoveUntil(
                          //     MaterialPageRoute(
                          //         builder: (context) => const RegScreen()),
                          //         (route) => false);

                          Navigator.pop(context);
                        },
                      ),
                    ],
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: AppFont.subHead,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.signAppColor,
                        ),
                      ),
                    ),
                    NormalInputW(
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
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.transparent)),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: AppFont.inputHead,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primeAppColor,
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet<dynamic>(context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(42.0),
                                  topRight: Radius.circular(42.0),
                                ),
                              ),
                              builder: (context) {
                                return const Scaffold(body
                                    : ForgotP());
                              });
                        },
                      ),
                    ),
                    RoundedButton(
                      title: 'Login',
                      colour: AppTheme.primeAppColor,
                      onPressed: () {
                        _controller.value.text.isNotEmpty
                            ? _submit()
                            : null;
                      },
                      shadow: AppTheme.shadowAppColor,
                      width: 100,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
