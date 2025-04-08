import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:mri/data/grn_items/grn_items_details.dart';

class GrnItemsRepository {
  static const String _boxName = 'grnItemBox';
  // final String baseURL = 'https://api.hexagonasia.com';
  final String baseURL = 'http://192.168.1.13:5000';
  static const Duration timeoutDuration = Duration(seconds: 10);

  // Future<Box> init() async {
  //   return await Hive.openBox<GrnItemsDetails>(_boxName);
  // }

  double safeDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Future<Map<String, dynamic>> searchPoNumber(String poNumber) async {
    try {
      print('🔍 Requesting PO details for: $poNumber');
      final uri = Uri.parse('$baseURL/mobile/grn/search/po?poNumber=$poNumber');
      print('📡 GET: $uri');

      final response = await http.get(uri).timeout(timeoutDuration);

      print('✅ Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);

        final String supplierName = decoded['supplierName'] ?? '';
        final String currencyName = decoded['currencyName'] ?? '';
        final int poId = int.tryParse(decoded['poId']?.toString() ?? '0') ?? 0;
        final int supplierId =
            int.tryParse(decoded['supplierId']?.toString() ?? '0') ?? 0;
        final int currencyId =
            int.tryParse(decoded['currencyId']?.toString() ?? '0') ?? 0;
        final List<dynamic> items = decoded['items'] ?? [];

        print('🧾 Found ${items.length} item(s)');
        await Hive.deleteBoxFromDisk(_boxName);

        // Convert and validate items
        final grnItemDetails =
            items.map((item) {
              return GrnItemsDetails(
                itemId: int.tryParse(item['itemId']?.toString() ?? '0') ?? 0,
                itemDesc: item['itemName']?.toString() ?? '',
                qty: safeDouble(item['qty']),
                receivedQty: safeDouble(item['receivedQty']),
                unit: item['unit']?.toString() ?? '',
                glAccountId: 0,
                unitPrice: safeDouble(item['unitPrice']),
              );
            }).toList();

        // Save to Hive
        await Hive.close();
        final grnItemDetailsBox = await Hive.openBox<GrnItemsDetails>(_boxName);
        await grnItemDetailsBox.clear();
        await grnItemDetailsBox.addAll(grnItemDetails);
        await grnItemDetailsBox.close();

        print('✅ GRN items saved to Hive');

        return {
          'poId': poId,
          'supplierId': supplierId,
          'currencyId': currencyId,
          'supplierName': supplierName,
          'currencyName': currencyName,
          'items': grnItemDetails,
        };
      } else {
        throw 'HTTP ${response.statusCode}: ${response.reasonPhrase}';
      }
    } catch (e, stack) {
      print('❌ Exception in searchPoNumber: $e');
      print('🔍 Stack trace: $stack');
      return Future.error('Something went wrong: $e');
    }
  }

  Future<bool> addItem(
    int itemId,
    double qty,
    double receivedQty,
    String unit,
    int glAccountId,
    String itemDesc,
    double unitPrice,
  ) async {
    await Hive.close();
    final grnItemDetailsBox = await Hive.openBox(_boxName);
    final grnItemDetails = GrnItemsDetails(
      itemId: itemId,
      qty: qty,
      receivedQty: receivedQty,
      unit: unit,
      glAccountId: glAccountId,
      itemDesc: itemDesc,
      unitPrice: unitPrice,
    );
    await grnItemDetailsBox.put(itemId, grnItemDetails);
    await grnItemDetailsBox.close();
    await Hive.close();
    return true;
  }

  dynamic getItem(itemId) {
    final grnItemDetailsBox = Hive.box(_boxName);
    return grnItemDetailsBox.get(itemId);
  }

  Future<bool> updateItem(
    itemId,
    qty,
    receivedQty,
    unit,
    glAccountId,
    itemDesc,
    unitPrice,
  ) async {
    await Hive.close();
    final grnItemDetailsBox = await Hive.openBox(_boxName);
    final grnItemDetails = GrnItemsDetails(
      itemId: itemId,
      qty: qty,
      receivedQty: receivedQty,
      unit: unit,
      glAccountId: glAccountId,
      itemDesc: itemDesc,
      unitPrice: unitPrice,
    );
    await grnItemDetailsBox.put(itemId, grnItemDetails);
    await grnItemDetailsBox.close();
    await Hive.close();
    return true;
  }

  Future<bool> deleteItem(itemId) async {
    await Hive.close();
    final grnItemDetailsBox = await Hive.openBox(_boxName);
    await grnItemDetailsBox.delete(itemId);
    await grnItemDetailsBox.close();
    await Hive.close();
    return true;
  }

  Future<bool> clearBox() async {
    late Box<GrnItemsDetails> grnItemDetailsBox;

    if (Hive.isBoxOpen(_boxName)) {
      grnItemDetailsBox = Hive.box<GrnItemsDetails>(_boxName);
    } else {
      grnItemDetailsBox = await Hive.openBox<GrnItemsDetails>(_boxName);
    }

    await grnItemDetailsBox.clear();

    // OPTIONAL: Only close the box if you **won't use it again immediately**
    // await grnItemDetailsBox.close();

    return true;
  }

  Future<bool> deleteBox() async {
    await Hive.close();
    final grnItemDetailsBox = await Hive.openBox(_boxName);
    await grnItemDetailsBox.deleteFromDisk();
    await Hive.close();
    return true;
  }

  Future<bool> deleteAllItems() async {
    await Hive.close();
    final grnItemDetailsBox = await Hive.openBox(_boxName);
    await grnItemDetailsBox.clear();
    await grnItemDetailsBox.close();
    await Hive.close();
    return true;
  }

  Future<bool> deleteAllBoxes() async {
    await Hive.close();
    final grnItemDetailsBox = await Hive.openBox(_boxName);
    await grnItemDetailsBox.deleteFromDisk();
    await grnItemDetailsBox.close();
    await Hive.close();
    return true;
  }
}
