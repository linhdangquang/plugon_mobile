import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:plugon_mobile/providers/quanlybanhang/dongsanpham.dart';
import 'package:plugon_mobile/screens/quanlybanhang/screens/dong_san_pham/widgets/new_dongsanpham.dart';
import 'package:plugon_mobile/screens/quanlybanhang/widgets/quanlybanhang_drawer.dart';
import 'package:plugon_mobile/widgets/screen_app_bar.dart';
import 'package:provider/provider.dart';

class DongSanPhamScreen extends StatefulWidget {
  const DongSanPhamScreen({Key? key}) : super(key: key);

  static const routeName = '/quanlybanhang/dongsanpham';

  @override
  State<DongSanPhamScreen> createState() => _DongSanPhamScreenState();
}

class _DongSanPhamScreenState extends State<DongSanPhamScreen> {
  final List<String> categories = [
    'Tất cả',
  ];

  bool _isLoading = false;

  String _selectedCategory = 'Tất cả';

  // var pageContext;

  @override
  void initState() {
    setState(() => _isLoading = true);
    Provider.of<DongSanPhamItems>(context, listen: false)
        .fetchAndSetItems()
        .then((_) => {setState((() => _isLoading = false))});
    super.initState();
  }

  void _delete(BuildContext context, int id) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Xác nhận xóa'),
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      await Provider.of<DongSanPhamItems>(context,
                              listen: false)
                          .deleteDongSanPham(id);
                      Fluttertoast.showToast(msg: 'Xóa thành công');
                    } catch (e) {
                      Fluttertoast.showToast(msg: 'Xóa thất bại');
                    } finally {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Đồng ý')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      Colors.red[500],
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Colors.red[200],
                    ),
                  ),
                  child: const Text('Không'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenAppBar(
        title: 'QLBH - Dòng sản phẩm',
        imgPath: 'assets/images/crm-crm.png',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModalDongSanPham(context, -1);
        },
        tooltip: 'Add',
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
                      child: Consumer<DongSanPhamItems>(
                    builder: (_, dongSanPham, __) =>
                        _buildDataTable(dongSanPham.items),
                  )),
                ],
              ),
            ),
      drawer: const QuanLyBanHangDrawer(),
    );
  }

  Future<dynamic> _showModalDongSanPham(BuildContext context, int id) {
    return showMaterialModalBottomSheet(
        context: context,
        builder: (context) => SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: NewDongSanPham(
              id: id,
            )));
  }

  Widget _buildDataTable(rowData) {
    final List<DataColumn> columns = [
      const DataColumn(label: Text('Mã')),
      const DataColumn(label: Text('Tên')),
      const DataColumn(label: Text('Thao tác')),
    ];

    List<DataRow> getRows(List<DongSanPham> rowData) {
      return rowData.map((row) {
        return DataRow(
          key: ValueKey(row.id),
          cells: [
            DataCell(Text(row.productFamilyCode)),
            DataCell(Text(row.productFamilyName)),
            DataCell(PopupMenuButton(
                elevation: 3,
                onSelected: (result) {
                  if (result == 'edit') {
                    _showModalDongSanPham(context, row.id);
                  } else {
                    _delete(context, row.id);
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
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
                        value: 'delete',
                        child: Row(
                          children: const [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Xóa")
                          ],
                        ),
                      ),
                    ])),
          ],
        );
      }).toList();
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: DataTable2(
        showCheckboxColumn: true,
        columnSpacing: 12,
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
