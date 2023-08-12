import 'package:expo_in/componenets/onboard/onpage.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController cp = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    cp.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      controller: cp,
      onPageChanged: (index) {
        setState(() => isLastPage = index == 2);
      },
      pageSnapping: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        OnPage(
          imgi: 'asset/qr1.png',
          heady: 'Efficient Data Collection',
          subby: 'Save time by eliminating manual data entry.',
          vc: () {
            cp.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          }, wt: cp, lastp: isLastPage,
        ),
        OnPage(
          imgi: 'asset/qr2.png',
          heady: 'Digital Visitor Database',
          subby: 'Keep a digital record of visitors for improved follow-up.',
          vc: () {
            cp.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          }, wt: cp, lastp: isLastPage,
        ),
        OnPage(
          imgi: 'asset/qr3.png',
          heady: 'Seamless Visitor Experience',
          subby:
              'Offer a convenient and modern way to collect visitor information',
          vc: () {
            cp.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          }, wt: cp, lastp: isLastPage,
        )
      ],
    ));
  }
}
