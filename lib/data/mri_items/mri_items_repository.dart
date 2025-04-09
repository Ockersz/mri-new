import 'package:hive_flutter/hive_flutter.dart';
import 'package:mri/data/mri_items/mri_items_details.dart';

class MriItemsRepository {
  static const String _boxName = 'mriItemBox';
  final String baseURL = 'https://api.hexagonasia.com';
  // final String baseURL = 'http://192.168.1.13:5000';
  static const Duration timeoutDuration = Duration(seconds: 10);

  Future<Box<MriItemsDetails>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<MriItemsDetails>(_boxName);
    }
    return Hive.box<MriItemsDetails>(_boxName);
  }

  Future<bool> addItem(
    int itemId,
    double onHandQty,
    int glAccountId,
    double qty,
    String itemRemark,
    int faItemId,
    int dimensionId,
    String itemDesc,
  ) async {
    final box = await _getBox();
    final item = MriItemsDetails(
      itemId: itemId,
      onHandQty: onHandQty,
      glAccountId: glAccountId,
      qty: qty,
      itemRemark: itemRemark,
      faItemId: faItemId,
      dimensionId: dimensionId,
      itemDesc: itemDesc,
    );
    await box.put(itemId, item);
    return true;
  }

  MriItemsDetails? getItem(int itemId) {
    if (!Hive.isBoxOpen(_boxName)) return null;
    final box = Hive.box<MriItemsDetails>(_boxName);
    return box.get(itemId);
  }

  Future<bool> updateItem(
    int itemId,
    double onHandQty,
    int glAccountId,
    double qty,
    String itemRemark,
    int faItemId,
    int dimensionId,
    String itemDesc,
  ) async {
    final box = await _getBox();
    final item = MriItemsDetails(
      itemId: itemId,
      onHandQty: onHandQty,
      glAccountId: glAccountId,
      qty: qty,
      itemRemark: itemRemark,
      faItemId: faItemId,
      dimensionId: dimensionId,
      itemDesc: itemDesc,
    );
    await box.put(itemId, item);
    return true;
  }

  Future<bool> deleteItem(int itemId) async {
    final box = await _getBox();
    await box.delete(itemId);
    return true;
  }

  Future<List<MriItemsDetails>> getAllItems() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<void> clearAllItems() async {
    final box = await _getBox();
    await box.clear();
  }

  Future<void> closeBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box(_boxName).close();
    }
  }
}
