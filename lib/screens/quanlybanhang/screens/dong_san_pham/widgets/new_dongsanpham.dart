import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plugon_mobile/providers/quanlybanhang/dongsanpham.dart';
import 'package:provider/provider.dart';

class NewDongSanPham extends StatefulWidget {
  const NewDongSanPham({Key? key, this.id}) : super(key: key);

  final int? id;

  @override
  State<NewDongSanPham> createState() => _NewDongSanPhamState();
}

class _NewDongSanPhamState extends State<NewDongSanPham> {
  final _fbKey = GlobalKey<FormBuilderState>();
  final String ma = 'productFamilyCode';
  final String ten = 'productFamilyName';
  final String moTa = 'description';

  bool _isEdit = false;

  bool _isLoading = false;

  DongSanPham _editDongSanPham = DongSanPham(
    id: int.parse(DateTime.now().millisecondsSinceEpoch.toString()),
    productFamilyCode: '',
    productFamilyName: '',
    description: '',
  );

  var _initValues = {
    'productFamilyCode': '',
    'productFamilyName': '',
    'description': '',
  };

  @override
  void didChangeDependencies() {
    try {
      _isEdit = true;
      DongSanPham itemValue =
          Provider.of<DongSanPhamItems>(context).findById(widget.id as int);
      _initValues = {
        ma: itemValue.productFamilyCode,
        ten: itemValue.productFamilyName,
        moTa: itemValue.description,
      };
      _editDongSanPham = itemValue;
    } catch (_) {
      _isEdit = false;
    }
    super.didChangeDependencies();
  }

  void _onSubmitPressed() async {
    if (_fbKey.currentState!.saveAndValidate()) {
      final formData = _fbKey.currentState!.value;

      _editDongSanPham = DongSanPham(
        id: _editDongSanPham.id,
        productFamilyCode: formData[ma],
        productFamilyName: formData[ten],
        description: formData[moTa],
      );
      if (_isEdit) {
        setState(() {
          _isLoading = true;
        });
        try {
          await Provider.of<DongSanPhamItems>(context, listen: false)
              .updateItem(widget.id!, _editDongSanPham);
          Fluttertoast.showToast(
              msg: 'C???p nh???t th??nh c??ng',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        } catch (e) {
          Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } finally {
          Navigator.of(context).pop();
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = true;
        });
        try {
          await Provider.of<DongSanPhamItems>(context, listen: false)
              .addDongSanPham(_editDongSanPham)
              .then((_) {
            Fluttertoast.showToast(msg: 'Th??m th??nh c??ng');
          });
        } catch (e) {
          Fluttertoast.showToast(msg: 'Th??m th???t b???i');
        } finally {
          Navigator.of(context).pop();
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  _isEdit ? 'S???a d??ng s???n ph???m' : 'Th??m d??ng s???n ph???m',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
              ),
            ),
            FormBuilder(
                key: _fbKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FormBuilderTextField(
                        name: ma,
                        initialValue: _initValues[ma],
                        decoration: const InputDecoration(
                          labelText: 'M??',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Kh??ng ???????c ????? tr???ng'),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FormBuilderTextField(
                          name: ten,
                          initialValue: _initValues[ten],
                          decoration: const InputDecoration(
                            labelText: 'T??n',
                          ),
                          validator: FormBuilderValidators.required(
                              errorText: 'Kh??ng ???????c ????? tr???ng')),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FormBuilderTextField(
                          name: moTa,
                          initialValue: _initValues[moTa],
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            labelText: 'M?? t???',
                          ),
                          validator: FormBuilderValidators.required(
                              errorText: 'Kh??ng ???????c ????? tr???ng')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () => _onSubmitPressed(),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                )
                              : Text(
                                  _isEdit ? 'S???a' : 'Th??m',
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                    fontWeight: FontWeight.w900,
                                  ),
                                )),
                    ),
                  ],
                ))
          ],
        ),
      ),
      Positioned(
          top: 0,
          right: 0,
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                _fbKey.currentState!.reset();
              },
              icon: const Icon(
                Icons.highlight_remove_rounded,
                color: Colors.pink,
                size: 28,
              )))
    ]);
  }
}
