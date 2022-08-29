import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plugon_mobile/providers/auth.dart';
import 'package:plugon_mobile/screens/quanlybanhang/screens/dong_san_pham/dongsanpham_screen.dart';
import 'package:provider/provider.dart';

class QuanLyBanHangDrawer extends StatelessWidget {
  const QuanLyBanHangDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              // padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset(
                    'assets/images/plugon.svg',
                    height: 40,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'PlugOn',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Trang chủ',
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            title: const Text(
              'Tổng quan',
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            title: const Text(
              'Quản lý bán hàng',
            ),
            expandedAlignment: Alignment.centerLeft,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text(
                      'Kế hoạch kinh doanh',
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/quanlybanhang');
                    },
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  ),
                  ListTile(
                    title: const Text(
                      'Khách hàng',
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/quanlybanhang');
                    },
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  ),
                  ListTile(
                    title: const Text(
                      'Dòng sản phẩm',
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(DongSanPhamScreen.routeName);
                    },
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  ),
                  ListTile(
                    title: const Text(
                      'Quản lý đơn hàng',
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/quanlydonhang');
                    },
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  ),
                ],
              )
            ],
          ),
          ListTile(
            title: const Text(
              'Quản lý chăm sóc khách hàng',
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Text(
              'Quản lý marketing',
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app_outlined,
              color: Colors.black,
            ),
            minLeadingWidth: 10,
            title: const Text(
              'Đăng xuất',
            ),
            onTap: () {
              Provider.of<Auth>(context, listen: false)
                  .signOut()
                  .then((_) => Navigator.of(context).pushReplacementNamed('/'));
            },
          ),
        ],
      ),
    );
  }
}
