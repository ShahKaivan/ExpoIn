import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'app_font.dart';
import 'app_theme.dart';

const kSameImageBackground = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('asset/onboarding-3.png'),
    fit: BoxFit.cover,
  ),
);

var kImageBackground = const BoxDecoration(
  color: AppTheme.mainAppColor,
);

var kImageBackgroundBlack = const BoxDecoration(
  color: AppTheme.signAppColor,
);

final kDecor = InputDecoration(
  counterStyle: const TextStyle(
    fontFamily: 'Satoshi',
    color: Color(0x80F2F2F2),
  ),
  errorStyle: const TextStyle(
    fontFamily: 'Satoshi',
    fontSize: AppFont.subHead,
  ),
  filled: true,
  fillColor: AppTheme.signShadowAppColor,
  contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: AppTheme.primeAppColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  hintStyle: const TextStyle(
    fontFamily: 'Satoshi',
    fontSize: AppFont.subHead,
    fontWeight: FontWeight.w600,
    color: Color(0x80F2F2F2),
  ),
);

final kDecorW = InputDecoration(
  counterStyle: const TextStyle(
    fontFamily: 'Satoshi',
    color: AppTheme.shadowAppColor,
  ),
  errorStyle: const TextStyle(
    fontFamily: 'Satoshi',
    fontSize: AppFont.subHead,
  ),
  filled: true,
  fillColor: AppTheme.mainAppColor,
  contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: AppTheme.primeAppColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  hintStyle: const TextStyle(
    fontFamily: 'Satoshi',
    fontSize: AppFont.subHead,
    fontWeight: FontWeight.w600,
    color: AppTheme.subtitleAppColor,
  ),
);

final kDecorS = InputDecoration(
  prefixIcon: Padding(
    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
    child: Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      child: SvgPicture.asset('asset/icon/Search.svg'),
    ),
  ),
  border: InputBorder.none,
  contentPadding: const EdgeInsets.only(top: 22.0, left: 18.0, right: 18.0),
  hintStyle: const TextStyle(
    fontFamily: 'Satoshi',
    fontSize: AppFont.inputHead,
    fontWeight: FontWeight.w500,
    color: AppTheme.gryAppColorSec,
  ),
);
