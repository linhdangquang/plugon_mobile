import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plugon_mobile/constants/colors.dart';
import 'package:plugon_mobile/screens/home/widgets/ListGrid.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: double.infinity,
        leading: SizedBox(
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, HomePage.routeName);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SvgPicture.asset(
                      'assets/images/plugon.svg',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Plugon Mobile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: mainAppBarColor,
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.black87,
            ),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: bgGradient,
          ),
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Center(
                  child: Text(
                    'Chào buổi chiều',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              ListGridView()
            ],
          )),
    );
  }
}
