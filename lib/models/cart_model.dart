// ignore_for_file: file_names

class CartModel {
  final String equipmentId;
  final String equipmentName;
  final String categoryName;
  final String rentPrice;
  final List<dynamic> equipmentImages;
  final String model;
  final String equipmentDescription;
  final dynamic createdAt;
  final dynamic startDate;
  final dynamic endDate;
  late final double equipmentQuantity;
  final double equipmentTotalPrice;
  final int numberOfDays;

  CartModel({
    required this.equipmentId,
    required this.equipmentName,
    required this.categoryName,
    required this.rentPrice,
    required this.equipmentImages,
    required this.model,
    required this.equipmentDescription,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.equipmentQuantity,
    required this.equipmentTotalPrice,
    required this.numberOfDays,
  });

  Map<String, dynamic> toMap() {
    return {
      'equipmentId': equipmentId,
      'equipmentName': equipmentName,
      'categoryName': categoryName,
      'rentPrice': rentPrice,
      'equipmentImages': equipmentImages,
      'model': model,
      'equipmentDescription': equipmentDescription,
      'createdAt': createdAt,
      'startDate': endDate,
      'endDate': endDate,
      'equipmentQuantity': equipmentQuantity,
      'equipmentTotalPrice': equipmentTotalPrice,
      'numberOfDays': numberOfDays,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
      equipmentId: json['equipmentId'],
      equipmentName: json['equipmentName'],
      categoryName: json['categoryName'],
      rentPrice: json['rentPrice'],
      equipmentImages: json['equipmentImages'],
      model: json['model'],
      equipmentDescription: json['equipmentDescription'],
      createdAt: json['createdAt'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      equipmentQuantity: json['equipmentQuantity'],
      equipmentTotalPrice: json['equipmentTotalPrice'],
      numberOfDays: json['numberOfDays'],
    );
  }
}