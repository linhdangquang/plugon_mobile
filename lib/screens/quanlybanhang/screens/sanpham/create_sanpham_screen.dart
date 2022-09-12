import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plugon_mobile/constants/colors.dart';
import 'package:plugon_mobile/providers/quanlybanhang/dongsanpham.dart';
import 'package:plugon_mobile/providers/quanlybanhang/sanpham.dart';
import 'package:provider/provider.dart';

class CreateSanPhamScreen extends StatefulWidget {
  const CreateSanPhamScreen({Key? key}) : super(key: key);

  static const routeName = '/quanlybanhang/sanpham/create-sanpham';

  @override
  State<CreateSanPhamScreen> createState() => _CreateSanPhamScreenState();
}

class _CreateSanPhamScreenState extends State<CreateSanPhamScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();
  final String ma = 'productCode';
  final String ten = 'productName';
  final String moTa = 'description';
  final String dongSanPham = 'dongSanPhamId';

  String _appBarTitle = 'Tạo sản phẩm';

  bool _isLoading = false;

  bool _isEdit = false;

  SanPham _editSanPham = SanPham(
      id: int.parse(DateTime.now().millisecondsSinceEpoch.toString()),
      productCode: '',
      productName: '',
      description: '',
      productFamilyId:
          int.parse(DateTime.now().millisecondsSinceEpoch.toString()));

  var _initValues = {
    'productCode': '',
    'productName': '',
    'description': '',
    'dongSanPhamId':
        int.parse(DateTime.now().millisecondsSinceEpoch.toString()),
  };

  @override
  void didChangeDependencies() {
    final productId = ModalRoute.of(context)?.settings.arguments as int?;
    if (productId != null) {
      _isEdit = true;
      _appBarTitle = 'Sửa sản phẩm';
      _editSanPham = Provider.of<SanPhamItems>(context).findById(productId);
      _initValues = {
        ma: _editSanPham.productCode,
        ten: _editSanPham.productName,
        moTa: _editSanPham.description,
        dongSanPham: _editSanPham.productFamilyId,
      };
    }
    super.didChangeDependencies();
  }

  void _onSubmitPressed() async {
    if (_fbKey.currentState!.saveAndValidate()) {
      final formData = _fbKey.currentState!.value;

      final sanPham = SanPham(
        id: _editSanPham.id,
        productCode: formData[ma],
        productName: formData[ten],
        description: formData[moTa],
        productFamilyId: formData[dongSanPham],
      );

      try {
        setState(() {
          _isLoading = true;
        });
        if (_isEdit) {
          try {
            await Provider.of<SanPhamItems>(context, listen: false)
                .updateItem(sanPham);
          } catch (e) {
            rethrow;
          }
        } else {
          try {
            await Provider.of<SanPhamItems>(context, listen: false)
                .addItem(sanPham);
            Fluttertoast.showToast(msg: 'Thêm thành công');
          } catch (e) {
            Fluttertoast.showToast(msg: 'Thêm thất bại');
          }
        }
      } catch (e) {
        rethrow;
      } finally {
        setState(() => _isLoading = false);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_appBarTitle,
              style: const TextStyle(color: Colors.black87, fontSize: 18)),
          iconTheme: const IconThemeData(color: Colors.black87),
          elevation: 5,
          backgroundColor: mainAppBarColor,
          actions: [
            IconButton(
                onPressed: () => _onSubmitPressed(),
                icon: Icon(Icons.save_outlined,
                    size: 28, color: Colors.blue[400]))
          ]),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            FormBuilder(
                key: _fbKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: FormBuilderTextField(
                              name: ma,
                              initialValue: _initValues[ma].toString(),
                              decoration: InputDecoration(
                                  labelText: 'Mã sản phẩm',
                                  labelStyle: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.blue[200]),
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 18),
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(
                                    errorText: 'Vui lòng nhập mã sản phẩm',
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: FormBuilderTextField(
                              name: ten,
                              initialValue: _initValues[ten].toString(),
                              decoration: InputDecoration(
                                  labelText: 'Tên sản phẩm',
                                  labelStyle: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.blue[200]),
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 18),
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(
                                    errorText: 'Vui lòng nhập tên sản phẩm',
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormBuilderDropdown(
                        name: dongSanPham,
                        initialValue: _initValues[dongSanPham],
                        items: Provider.of<DongSanPhamItems>(context)
                            .items
                            .map((e) => DropdownMenuItem(
                                  value: e.id,
                                  child: Text(e.productFamilyName),
                                ))
                            .toList(),
                        validator: FormBuilderValidators.required(
                            errorText: 'Vui lòng chọn dòng sản phẩm'),
                        decoration: InputDecoration(
                            labelText: 'Dòng sản phẩm',
                            labelStyle: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.blue[200])),
                    const SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      name: moTa,
                      initialValue: _initValues[moTa].toString(),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: 'Mô tả',
                          labelStyle: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.blue[200]),
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 18),
                    ),
                  ],
                )),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () => _onSubmitPressed(),
                        child: Text(_isEdit ? 'Sửa' : 'Thêm'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
