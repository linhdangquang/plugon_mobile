import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

const dongSanPhamApiUrl = 'http://api.ngs.vn/nspace/crm/product-family/';

class DongSanPham with ChangeNotifier {
  late int id;
  late String productFamilyCode;
  late String productFamilyName;
  late String description;

  DongSanPham({
    required this.id,
    required this.productFamilyCode,
    required this.productFamilyName,
    required this.description,
  });
}

class DongSanPhamItems with ChangeNotifier {
  final accessToken;
  // ignore: prefer_final_fields
  List<DongSanPham> _items = [];

  DongSanPhamItems({
    required this.accessToken,
    required List<DongSanPham> items,
  }) : _items = items;

  List<DongSanPham> get items => [..._items];

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
      final url =
          Uri.parse('${dongSanPhamApiUrl}search?page=0&size=20&sort=id');
      final response = await http.get(
        url,
        headers: defaultHeaders(accessToken),
      );
      final extractedData = json.decode(utf8.decode(response.bodyBytes))['data']
          ['content'] as List;
      final List<DongSanPham> loadedItems = [];
      for (var itemData in extractedData) {
        loadedItems.add(DongSanPham(
          id: itemData['id'],
          productFamilyCode: itemData['productFamilyCode'],
          productFamilyName: itemData['productFamilyName'],
          description: itemData['description'] ?? '',
        ));
      }
      _items = loadedItems;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  DongSanPham findById(int id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> addDongSanPham(DongSanPham dongSanPham) async {
    try {
      final url = Uri.parse(dongSanPhamApiUrl);
      final response = await http.post(url,
          headers: defaultHeaders(accessToken),
          body: json.encode({
            'productFamilyCode': dongSanPham.productFamilyCode,
            'productFamilyName': dongSanPham.productFamilyName,
            'description': dongSanPham.description
          }));

      final newDongSanPham = DongSanPham(
        id: json.decode(response.body)['data']['id'],
        productFamilyCode: dongSanPham.productFamilyCode,
        productFamilyName: dongSanPham.productFamilyName,
        description: dongSanPham.description,
      );
      _items.add(newDongSanPham);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateItem(int id, DongSanPham newItem) async {
    try {
      final itemIndex = _items.indexWhere((item) => item.id == id);
      if (itemIndex >= 0) {
        final url = Uri.parse('$dongSanPhamApiUrl$id');
        final response = await http.put(url,
            headers: idHeaders(accessToken, id),
            body: json.encode({
              'productFamilyCode': newItem.productFamilyCode,
              'productFamilyName': newItem.productFamilyName,
              'description': newItem.description
            }));
        _items[itemIndex] = newItem;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDongSanPham(int id) async {
    try {
      final url = Uri.parse('$dongSanPhamApiUrl$id');
      final response = await http.delete(
        url,
        headers: idHeaders(accessToken, id),
      );
      if ((response.statusCode >= 200 && response.statusCode < 300) ||
          response.statusCode == 400) {
        _items.removeWhere((item) => item.id == id);
        notifyListeners();
      } else {
        throw HttpException(response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
  }
}
