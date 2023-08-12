import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({Key? key, required this.colour, required this.title, required this.onPressed, required this.shadow, required this.width}) : super(key: key);

  final Color colour;
  final Color? shadow;
  final double width;
  final String title;
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0 , bottom: 10.0),
      child: Material(
        elevation: 25,
        color: colour,
        shadowColor: shadow,
        borderRadius: BorderRadius.circular(50.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: MaterialButton(
            highlightColor: Colors.transparent,
            onPressed: onPressed,
            minWidth: width,
            height: 70.0,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Satoshi',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}