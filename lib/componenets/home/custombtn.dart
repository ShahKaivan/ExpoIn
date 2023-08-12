import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../design-system/app_theme.dart';
import '../../screens/onboarding.dart';
import '../../screens/profile/profile.dart';
import '../create_route.dart';

Future<void> _getData() async => FirebaseFirestore.instance
    .collection('Users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get();

class CustomButtonTest extends StatefulWidget {
  const CustomButtonTest({Key? key}) : super(key: key);

  @override
  State<CustomButtonTest> createState() => _CustomButtonTestState();
}

class _CustomButtonTestState extends State<CustomButtonTest> {
  late final getData = _getData();

  @override
  Widget build(BuildContext context) {
    //SizedBox(
    //                     height: MediaQuery.of(context).size.height * 0.1,
    //                     width: MediaQuery.of(context).size.width * 0.2,
    //                     child: Image(
    //                       image: CachedNetworkImageProvider(snapshot.data.data()['photo']),
    //                       fit: BoxFit.cover,
    //                     ),
    //                   );

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: ClipRRect(
          borderRadius: BorderRadius.circular(15.0), //or 15.0
          child: FutureBuilder(
              future: getData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatar(
                    radius: 50,
                    foregroundImage: CachedNetworkImageProvider(
                        snapshot.data.data()['profile']),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ),
        items: [
          ...MenuItems.firstItems.map(
                (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
          const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
          ...MenuItems.thirdItems.map(
                (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value as MenuItem);
        },
        iconStyleData: const IconStyleData(
          iconSize: 14,
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 50,
          padding: const EdgeInsets.only(left: 14, right: 14),
          customHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 40),
            8,
            ...List<double>.filled(MenuItems.thirdItems.length, 40),
          ],
        ),
        dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 200,
            padding: null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppTheme.whiteAppColor,
            ),
            elevation: 0,
            offset: const Offset(0, -10),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(false),
            )),
        buttonStyleData: const ButtonStyleData(
          height: 40,
          width: 160,
          padding: EdgeInsets.only(left: 14, right: 14),
          elevation: 8,
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [home];
  static const List<MenuItem> thirdItems = [logout];

  static const home = MenuItem(text: 'Profile', icon: Icons.person);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: AppTheme.signAppColor, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: AppTheme.signAppColor,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) async {
    switch (item) {
      case MenuItems.home:
      //Do something
        Navigator.of(context).push(createRoute(const Profile(type: 'Personal')));
        break;
      case MenuItems.logout:
      //Do something
        final navigator = Navigator.of(context);
        await FirebaseAuth.instance.signOut();
        navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const OnBoarding()),
                (route) => false);
        break;
    }
  }
}
