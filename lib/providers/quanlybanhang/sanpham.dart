import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

const sanPhamApiUrl = 'http://api.ngs.vn/nspace/crm/product/';

class SanPham {
  late int id;
  late String productCode;
  late String productName;
  late String description;
  late int productFamilyId;
  late int status;

  SanPham(
      {required this.id,
      required this.productCode,
      required this.productName,
      required this.description,
      required this.productFamilyId,
      this.status = 1});
}

class SanPhamItems with ChangeNotifier {
  // ignore: prefer_typing_uninitialized_variables
  final accessToken;
  // ignore: prefer_final_fields
  List<SanPham> _items = [];
  SanPhamItems({
    required this.accessToken,
    required List<SanPham> items,
  }) : _items = items;
  List<SanPham> get items => [..._items];

  var defaultHeaders = (accessToken) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'cid': '167',
      'uid': 'b785640b-7d62-4111-a40c-45baad3f25ed',
    };
  };

  var idHeaders = (accessToken, id) {
    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $accessToken',
      'cid': '167',
      'id': id.toString(),
      'uid': 'b785640b-7d62-4111-a40c-45baad3f25ed',
    };
  };

  Future<void> fetchAndSetItems() async {
    try {
      final url = Uri.parse('${sanPhamApiUrl}search?sort=id,desc');
      final response =
          await http.get(url, headers: defaultHeaders(accessToken));
      final extractedData = json.decode(utf8.decode(response.bodyBytes))['data']
          ['content'] as List;
      final List<SanPham> loadedItems = [];
      for (var itemData in extractedData) {
        loadedItems.add(SanPham(
          id: itemData['id'],
          productCode: itemData['productCode'] ?? '',
          productName: itemData['productName'],
          description: itemData['description'] ?? '',
          productFamilyId: itemData['productFamilyId'],
          status: itemData['status'],
        ));
      }
      _items = loadedItems;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addItem(SanPham sanPham) async {
    try {
      final url = Uri.parse(sanPhamApiUrl);
      final response = await http.post(url,
          headers: defaultHeaders(accessToken),
          body: json.encode({
            'productCode': sanPham.productCode,
            'productName': sanPham.productName,
            'productFamilyId': sanPham.productFamilyId,
            'description': sanPham.description,
            'status': 1,
          }));

      final newSanPham = SanPham(
        id: json.decode(response.body)['data']['id'],
        productCode: sanPham.productCode,
        productName: sanPham.productName,
        productFamilyId: sanPham.productFamilyId,
        description: sanPham.description,
        status: 1,
      );
      _items.add(newSanPham);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  SanPham findById(int id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateItem(SanPham sanPham) async {
    try {
      final index = _items.indexWhere((element) => element.id == sanPham.id);
      if (index >= 0) {
        final url = Uri.parse('$sanPhamApiUrl${sanPham.id}');
        final response = await http.put(url,
            headers: defaultHeaders(accessToken),
            body: json.encode({
              'productCode': sanPham.productCode,
              'productName': sanPham.productName,
              'productFamilyId': sanPham.productFamilyId,
              'description': sanPham.description,
              'status': 1,
            }));
        _items[index] = sanPham;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeProductStatus(int id) async {
    try {
      final url = Uri.parse('$sanPhamApiUrl/active/$id');
      await http.put(
        url,
        headers: idHeaders(accessToken, id),
      );
      final index = _items.indexWhere((element) => element.id == id);
      _items[index].status = _items[index].status == 1 ? 0 : 1;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
