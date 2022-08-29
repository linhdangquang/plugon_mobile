import 'package:flutter/material.dart';
import 'package:plugon_mobile/constants/colors.dart';

class ScreenAppBar extends StatelessWidget with PreferredSizeWidget {
  const ScreenAppBar({Key? key, required this.title, required this.imgPath})
      : super(key: key);

  final String title;
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black87,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Image.asset(
              imgPath,
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      backgroundColor: mainAppBarColor,
      elevation: 5,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
