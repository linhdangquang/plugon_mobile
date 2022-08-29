import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

const dongSanPhamApiUrl =
    'http://api.ngs.vn/nspace/crm/product-family/search?page=0&size=20&sort=id';

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

  Future<void> fetchAndSetItems() async {
    try {
      final url = Uri.parse(dongSanPhamApiUrl);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'cid': '167',
          'uid': 'b785640b-7d62-4111-a40c-45baad3f25ed',
        },
      );
      final extractedData =
          json.decode(response.body)['data']['content'] as List;
      final List<DongSanPham> loadedItems = [];
      for (var itemData in extractedData) {
        loadedItems.add(DongSanPham(
          id: itemData['id'],
          productFamilyCode: itemData['productFamilyCode'],
          productFamilyName: itemData['productFamilyName'],
          description: itemData['description'],
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

  void addDongSanPham(DongSanPham dongSanPham) {
    _items.add(dongSanPham);
    notifyListeners();
  }

  void updateItem(int id, DongSanPham newItem) {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      _items[itemIndex] = newItem;
      notifyListeners();
    }
  }
}
