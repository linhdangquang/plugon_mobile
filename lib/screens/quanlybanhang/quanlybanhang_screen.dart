import 'package:flutter/material.dart';
import 'package:plugon_mobile/screens/quanlybanhang/widgets/quanlybanhang_drawer.dart';
import 'package:plugon_mobile/widgets/screen_app_bar.dart';

class QuanLyBanHangScreen extends StatelessWidget {
  const QuanLyBanHangScreen({Key? key}) : super(key: key);

  static const routeName = '/quanlybanhang';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ScreenAppBar(
        title: 'Quản lý bán hàng',
        imgPath: 'assets/images/crm-crm.png',
      ),
      body: Center(
        child: Text('Quản lý bán hàng'),
      ),
      drawer: QuanLyBanHangDrawer(),
    );
  }
}
