import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plugon_mobile/providers/auth.dart';
import 'package:plugon_mobile/providers/quanlybanhang/dongsanpham.dart';
import 'package:plugon_mobile/screens/404page/404page.dart';
import 'package:plugon_mobile/screens/home/home_screen.dart';
import 'package:plugon_mobile/screens/login/login.dart';
import 'package:plugon_mobile/screens/quanlybanhang/quanlybanhang_screen.dart';
import 'package:plugon_mobile/screens/quanlybanhang/screens/dong_san_pham/dongsanpham_screen.dart';
import 'package:plugon_mobile/screens/splashscreen/splash_screen.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.lightBlue,
      ),
    );
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, DongSanPhamItems>(
              create: (_) => DongSanPhamItems(accessToken: '', items: []),
              update: ((_, value, previous) => DongSanPhamItems(
                  accessToken: value.accessToken, items: previous!.items))),
        ],
        child: Consumer<Auth>(builder: (context, auth, _) {
          return MaterialApp(
            title: 'Plugon',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [FormBuilderLocalizations.delegate],
            home: auth.isAuth
                ? const HomePage()
                : FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SplashScreen();
                      } else {
                        return const LoginPage();
                      }
                    },
                  ),
            routes: {
              LoginPage.routeName: (_) => const LoginPage(),
              QuanLyBanHangScreen.routeName: (_) => const QuanLyBanHangScreen(),
              DongSanPhamScreen.routeName: (_) => const DongSanPhamScreen(),
            },
            onUnknownRoute: (_) {
              return MaterialPageRoute(
                builder: (_) => const PageNotFound(),
              );
            },
          );
        }));
  }
}
