import 'package:hive/hive.dart';

part 'grn_items_details.g.dart';

@HiveType(typeId: 3)
class GrnItemsDetails {
  @HiveField(0)
  final int itemId;

  @HiveField(1)
  final String itemDesc;

  @HiveField(2)
  final double qty;

  @HiveField(3)
  final double receivedQty;

  @HiveField(4)
  final String unit;

  @HiveField(5)
  final int glAccountId;

  GrnItemsDetails({
    required this.itemId,
    required this.itemDesc,
    required this.qty,
    required this.receivedQty,
    required this.unit,
    required this.glAccountId,
  });

  factory GrnItemsDetails.fromJson(Map<String, dynamic> json) {
    return GrnItemsDetails(
      itemId: json['itemId'],
      itemDesc: json['itemDesc'],
      qty: json['qty'],
      receivedQty: json['receivedQty'],
      unit: json['unit'],
      glAccountId: json['glAccountId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'itemDesc': itemDesc,
      'qty': qty,
      'receivedQty': receivedQty,
      'unit': unit,
      'glAccountId': glAccountId,
    };
  }
}
