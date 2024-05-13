import 'package:food_app/common/configuration/sqflie.config.dart';
import 'package:food_app/features/menu_items/domain/entities/order.dart';

class OrderModel extends Order {
  OrderModel({
    required super.orderId,
    required super.mealId,
    required super.qnt,
  });

  Map<String, dynamic> toJson() => {
        OrderFileds.orderId: orderId,
        OrderFileds.mealId: mealId,
        OrderFileds.qnt: qnt,
      };
  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: int.parse(json[OrderFileds.orderId]),
        mealId: int.parse(json[OrderFileds.mealId]),
        qnt: int.parse(json[OrderFileds.qnt]),
      );
}
