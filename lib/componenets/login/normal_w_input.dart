import 'package:flutter/material.dart';
import '../../design-system/app_font.dart';
import '../../design-system/app_theme.dart';
import '../../design-system/constant.dart';

class NormalInputW extends StatefulWidget {
  final bool submit;
  final String? errorSt;
  final TextEditingController controller;
  final String text;
  final String hinty;
  final TextInputType txtType;
  final int maxLiney;
  final int? maxChar;
  final IconButton? icob;
  final bool showp;
  const NormalInputW(
      {Key? key,
        required this.submit,
        required this.errorSt,
        required this.controller,
        required this.text, required this.hinty, required this.txtType, required this.maxLiney, required this.maxChar, required this.showp, this.icob})
      : super(key: key);

  @override
  State<NormalInputW> createState() => _NormalInputWState();
}

class _NormalInputWState extends State<NormalInputW> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: kDecorW.copyWith(
        hintText: widget.hinty,
        errorText: widget.submit ? widget.errorSt : null,
        suffixIcon: widget.icob
      ),
      keyboardType: widget.txtType,
      maxLines: widget.maxLiney,
      maxLength: widget.maxChar,
      obscureText: widget.showp,
      style: const TextStyle(
        fontFamily: 'Satoshi',
        fontSize: AppFont.inputHead,
        fontWeight: FontWeight.w600,
        color: AppTheme.signAppColor,
      ),
      controller: widget.controller,
      onChanged: (text) => setState(() => widget.text),
    );
  }
}
