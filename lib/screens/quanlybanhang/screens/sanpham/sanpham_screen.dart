import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plugon_mobile/providers/quanlybanhang/dongsanpham.dart';
import 'package:plugon_mobile/providers/quanlybanhang/sanpham.dart';
import 'package:plugon_mobile/screens/quanlybanhang/screens/sanpham/create_sanpham_screen.dart';
import 'package:plugon_mobile/screens/quanlybanhang/widgets/quanlybanhang_drawer.dart';
import 'package:plugon_mobile/widgets/screen_app_bar.dart';
import 'package:provider/provider.dart';

class SanPhamScreen extends StatefulWidget {
  const SanPhamScreen({Key? key}) : super(key: key);

  static const routeName = '/quanlybanhang/sanpham';

  @override
  State<SanPhamScreen> createState() => _SanPhamScreenState();
}

class _SanPhamScreenState extends State<SanPhamScreen> {
  final List<String> categories = [
    'Tất cả',
  ];

  bool _isLoading = false;

  String _selectedCategory = 'Tất cả';

  setLoading(bool bool) {
    setState(() {
      _isLoading = bool;
    });
  }

  @override
  void initState() {
    setLoading(true);
    Provider.of<SanPhamItems>(context, listen: false)
        .fetchAndSetItems()
        .then((_) => setLoading(false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenAppBar(
        title: 'QLBH - Sản phẩm',
        imgPath: 'assets/images/crm-crm.png',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(CreateSanPhamScreen.routeName),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                )
              ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(alignment: Alignment.topLeft, children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              buttonDecoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1)),
                              ),
                              items: categories
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: _selectedCategory,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value as String;
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 140,
                              itemHeight: 40,
                            ),
                          ),
                        ]),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 35,
                          child: const TextField(
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                              labelText: 'Tìm kiếm',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<SanPhamItems>(
                      builder: (_, sanPham, __) =>
                          _buildDataTable(sanPham.items),
                    ),
                  ),
                ],
              ),
            ),
      drawer: const QuanLyBanHangDrawer(),
    );
  }

  Widget _buildDataTable(rowData) {
    final List<DataColumn> columns = [
      const DataColumn(label: Text('Mã')),
      const DataColumn(label: Text('Tên')),
      const DataColumn(label: Text('Dòng sản phẩm')),
      const DataColumn(label: Text('')),
    ];

    List<DataRow> getRows(List<SanPham> rowData) {
      return rowData.map((row) {
        return DataRow(
          key: ValueKey(row.id),
          cells: [
            DataCell(Text(
              row.productCode,
              style: TextStyle(color: Colors.blue[400]),
            )),
            DataCell(Text(
              row.productName,
              style: TextStyle(color: Colors.blue[400]),
            )),
            DataCell(Consumer<DongSanPhamItems>(
                builder: ((context, dongSanPham, child) {
              final isDongSanPham = dongSanPham.items
                  .firstWhere((element) => element.id == row.productFamilyId);
              return Text(
                  isDongSanPham != null ? isDongSanPham.productFamilyName : '');
            }))),
            DataCell(Center(
              child: PopupMenuButton(
                  elevation: 5,
                  onSelected: (result) async {
                    if (result == "Sửa") {
                      Navigator.of(context).pushNamed(
                          CreateSanPhamScreen.routeName,
                          arguments: row.id);
                    } else {
                      await Provider.of<SanPhamItems>(context, listen: false)
                          .changeProductStatus(row.id)
                          .catchError((e) {})
                          .then((_) => Fluttertoast.showToast(
                              msg: 'Đã thay đổi trạng thái thành công',
                              backgroundColor: Colors.greenAccent,
                              textColor: Colors.white));
                      // .then((value) => print(value));
                    }
                  },
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'Sửa',
                          child: Row(
                            children: const [
                              Icon(
                                Icons.edit_outlined,
                                color: Colors.lightBlue,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Sửa")
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: row.status == 1 ? 'Khoá' : 'Mở',
                          child: Row(
                            children: [
                              Icon(
                                row.status == 1
                                    ? Icons.lock_open_outlined
                                    : Icons.lock_outline,
                                color: row.status == 1
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(row.status == 1 ? "Khóa" : "Mở")
                            ],
                          ),
                        ),
                      ]),
            )),
          ],
        );
      }).toList();
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: DataTable2(
        showCheckboxColumn: true,
        columnSpacing: 12,
        minWidth: 500,
        horizontalMargin: 12,
        headingRowHeight: 40,
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.grey[300]!),
        columns: columns,
        rows: getRows(rowData),
      ),
    );
  }
}
