import 'package:expo_in/design-system/app_font.dart';
import 'package:flutter/material.dart';

class ListH extends StatelessWidget {
  const ListH({Key? key, required this.title, required this.subtitle, required this.icons, required this.mline, required this.isLastItem}) : super(key: key);

  final String title;
  final String subtitle;
  final Icon icons;
  final int mline;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.height <= 855 ? 40 : 60,
              height: MediaQuery.of(context).size.height <= 855 ? 40 : 60,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFdefaf0)),
              child: icons,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:  const EdgeInsets.only(bottom: 5),
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff444645)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      subtitle,
                      softWrap: true,
                      style: const TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: AppFont.announceHead,
                        color: Color(0xff0f1511),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLastItem) const Padding(
          padding: EdgeInsets.all(4),
          child: Divider(),
        )
      ],
    );
  }
}