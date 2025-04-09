import 'package:hive/hive.dart';

part 'grn_items_details.g.dart';

@HiveType(typeId: 3)
class GrnItemsDetails {
  @HiveField(0)
  int itemId;

  @HiveField(1)
  String itemDesc;

  @HiveField(2)
  double qty;

  @HiveField(3)
  double receivedQty;

  @HiveField(4)
  String unit;

  @HiveField(5)
  int glAccountId;

  @HiveField(6)
  double unitPrice;

  @HiveField(7)
  int podetaId;

  @HiveField(8)
  int unitId;

  @HiveField(9)
  double oldReceivedQty;

  GrnItemsDetails({
    required this.itemId,
    required this.itemDesc,
    required this.qty,
    required this.receivedQty,
    required this.oldReceivedQty,
    required this.unit,
    required this.glAccountId,
    required this.unitPrice,
    required this.podetaId,
    required this.unitId,
  });

  factory GrnItemsDetails.fromJson(Map<String, dynamic> json) {
    return GrnItemsDetails(
      itemId: json['itemId'],
      itemDesc: json['itemDesc'],
      qty: json['qty'],
      receivedQty: json['receivedQty'],
      oldReceivedQty: json['oldReceivedQty'] ?? 0.0,
      unit: json['unit'],
      glAccountId: json['glAccountId'],
      unitPrice: json['unitPrice'],
      podetaId: json['podetaId'],
      unitId: json['unitId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'itemDesc': itemDesc,
      'qty': qty,
      'receivedQty': receivedQty,
      'oldReceivedQty': oldReceivedQty,
      'unit': unit,
      'glAccountId': glAccountId,
      'unitPrice': unitPrice,
      'podetaId': podetaId,
      'unitId': unitId,
    };
  }
}
