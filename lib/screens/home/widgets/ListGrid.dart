import 'package:flutter/material.dart';
import 'package:plugon_mobile/screens/quanlybanhang/quanlybanhang_screen.dart';

class ListGridView extends StatelessWidget {
  const ListGridView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/asdasdsd');
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Image.asset('assets/images/workplace-project.png'),
                    ),
                  ),
                  const Text(
                    'Project',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      print('tap');
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Image.asset('assets/images/hcm-hrm.png'),
                    ),
                  ),
                  const Text(
                    'Nhân sự',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      print('tap');
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Image.asset('assets/images/hcm-time-salary.png'),
                    ),
                  ),
                  const Text(
                    'Công/lương',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () => Navigator.of(context)
                        .pushNamed(QuanLyBanHangScreen.routeName),
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Image.asset('assets/images/crm-crm.png'),
                    ),
                  ),
                  const FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'QL bán hàng',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      print('tap');
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Image.asset(
                          'assets/images/administrator-administrator.png'),
                    ),
                  ),
                  const Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]);
  }
}
