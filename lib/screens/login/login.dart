import 'package:flutter/material.dart';
import 'package:plugon_mobile/screens/login/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset('assets/images/logo.png'),
          ),
          const SizedBox(height: 20),
          LoginForm(),
          const SizedBox(height: 20),
          const Text('© 2021 by NGSC., JSC - plugon.vn',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
