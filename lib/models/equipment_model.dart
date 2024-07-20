// ignore_for_file: file_names

class EquipmentModel {
  final String equipmentId;
  final String equipmentName;
  final String categoryName;
  final String rentPrice;
  final List<dynamic> equipmentImages;
  final String model;
  final String link;
  final String equipmentDescription;
  final dynamic createdAt;

  EquipmentModel({
    required this.equipmentId,
    required this.equipmentName,
    required this.categoryName,
    required this.rentPrice,
    required this.equipmentImages,
    required this.model,
    required this.link,
    required this.equipmentDescription,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'equipmentId': equipmentId,
      'equipmentName': equipmentName,
      'categoryName': categoryName,
      'rentPrice': rentPrice,
      'equipmentImages': equipmentImages,
      'model': model,
      'link': link,
      'equipmentDescription': equipmentDescription,
      'createdAt': createdAt,
    };
  }

  factory EquipmentModel.fromMap(Map<String, dynamic> json) {
    return EquipmentModel(
      equipmentId: json['equipmentId'],
      equipmentName: json['equipmentName'],
      categoryName: json['categoryName'],
      rentPrice: json['rentPrice'],
      equipmentImages: json['equipmentImages'],
      model: json['model'],
      link: json['link'],
      equipmentDescription: json['equipmentDescription'],
      createdAt: json['createdAt'],
    );
  }
}