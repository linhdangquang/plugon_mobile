import 'package:flutter/material.dart';
import 'package:plugon_mobile/screens/home/home_screen.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/404error.png",
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.14,
          left: MediaQuery.of(context).size.width * 0.1,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 5),
                  blurRadius: 25,
                  color: Colors.black.withOpacity(0.17),
                ),
              ],
            ),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(HomePage.routeName),
              child: Text(
                "Home".toUpperCase(),
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
