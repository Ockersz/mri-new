import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:mri/data/grn_items/grn_items_details.dart';

class GrnItemsRepository {
  static const String _boxName = 'grnItemBox';
  final String baseURL = 'https://api.hexagonasia.com';
  // final String baseURL = 'http://192.168.1.13:5000';
  static const Duration timeoutDuration = Duration(seconds: 10);

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

        final box = await _getBox(fresh: true);

        final grnItemDetails =
            items.map((item) {
              return GrnItemsDetails(
                itemId: int.tryParse(item['itemId']?.toString() ?? '0') ?? 0,
                itemDesc: item['itemName']?.toString() ?? '',
                qty: safeDouble(item['qty']),
                receivedQty: 0,
                oldReceivedQty: safeDouble(item['receivedQty']),
                unit: item['unit']?.toString() ?? '',
                glAccountId: 0,
                unitPrice: safeDouble(item['unitPrice']),
                podetaId: int.tryParse(item['id']?.toString() ?? '0') ?? 0,
                unitId: int.tryParse(item['unitId']?.toString() ?? '0') ?? 0,
              );
            }).toList();

        await box.clear();
        await box.addAll(grnItemDetails);

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

  Future<bool> addItem(GrnItemsDetails item) async {
    final box = await _getBox();
    await box.put(item.itemId, item);
    return true;
  }

  GrnItemsDetails? getItem(int itemId) {
    final box = Hive.box<GrnItemsDetails>(_boxName);
    return box.get(itemId);
  }

  Future<bool> updateItem(GrnItemsDetails item) async {
    final box = await _getBox();
    await box.put(item.itemId, item);
    return true;
  }

  Future<bool> deleteItem(int itemId) async {
    final box = await _getBox();
    await box.delete(itemId);
    return true;
  }

  Future<List<GrnItemsDetails>> getAllItems() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<bool> clearBox() async {
    final box = await _getBox();
    await box.clear();
    return true;
  }

  Future<int> getItemCount() async {
    final box = await _getBox();
    return box.length;
  }

  Future<bool> deleteBox() async {
    final box = await _getBox();
    await box.deleteFromDisk();
    return true;
  }

  Future<bool> deleteAllItems() async => clearBox();

  Future<bool> deleteAllBoxes() async => deleteBox();

  Future<Box<GrnItemsDetails>> _getBox({bool fresh = false}) async {
    if (fresh && Hive.isBoxOpen(_boxName)) {
      await Hive.box<GrnItemsDetails>(_boxName).deleteFromDisk();
    }
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<GrnItemsDetails>(_boxName);
    }
    return Hive.box<GrnItemsDetails>(_boxName);
  }
}
