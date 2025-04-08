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

  GrnItemsDetails({
    required this.itemId,
    required this.itemDesc,
    required this.qty,
    required this.receivedQty,
    required this.unit,
    required this.glAccountId,
    required this.unitPrice,
  });

  factory GrnItemsDetails.fromJson(Map<String, dynamic> json) {
    return GrnItemsDetails(
      itemId: json['itemId'],
      itemDesc: json['itemDesc'],
      qty: json['qty'],
      receivedQty: json['receivedQty'],
      unit: json['unit'],
      glAccountId: json['glAccountId'],
      unitPrice: json['unitPrice'],
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
      'unitPrice': unitPrice,
    };
  }
}
