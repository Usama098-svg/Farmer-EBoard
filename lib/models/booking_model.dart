// ignore_for_file: file_names


class BookingModel {
  final String bookingId;
  final String equipmentId;
  final String categoryId;
  final String equipmentName;
  final String categoryName;
  final String rentPrice;
  final List<dynamic> equipmentImages;
  final String model;
  final String equipmentDescription;
  final dynamic createdAt;
  final dynamic startDate;
  final dynamic endDate;
  final double numberOfDays;
  final double equipmentQuantity;
  final double equipmentTotalPrice;
  final String customerId;
  final String status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerCity;
  final String customerState;
  final String customerCountry;
  final String zipcode;

  BookingModel({
    required this.bookingId,
    required this.equipmentId,
    required this.categoryId,
    required this.equipmentName,
    required this.categoryName,
    required this.rentPrice,
    required this.equipmentImages,
    required this.model,
    required this.equipmentDescription,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.numberOfDays,
    required this.equipmentQuantity,
    required this.equipmentTotalPrice,
    required this.customerId,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerCity,
    required this.customerCountry,
    required this.customerState,
    required this.zipcode,
    
  });

  Map<String, dynamic> toMap() {
    return {
      'bookingId':bookingId,
      'equipmentId': equipmentId,
      'categoryId': categoryId,
      'equipmentName': equipmentName,
      'categoryName': categoryName,
      'rentPrice': rentPrice,
      'equipmentImages': equipmentImages,
      'model': model,
      'equipmentDescription': equipmentDescription,
      'createdAt': createdAt,
      'startDate': startDate,
      'endDate': endDate,
      'numberOfDays': numberOfDays,
      'equipmentQuantity': equipmentQuantity,
      'equipmentTotalPrice': equipmentTotalPrice,
      'customerId': customerId,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerCity':customerCity,
      'customerState':customerState,
      'customerCountry':customerCountry,
      'zipcode':zipcode,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> json) {
    return BookingModel(
      bookingId:json['bookingId'],
      equipmentId: json['equipmentId'],
      categoryId: json['categoryId'],
      equipmentName: json['equipmentName'],
      categoryName: json['categoryName'],
      rentPrice: json['rentPrice'],
      equipmentImages: json['equipmentImages'],
      model: json['model'],
      equipmentDescription: json['equipmentDescription'],
      createdAt: json['createdAt'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      numberOfDays: json['numberOfDays'],
      equipmentQuantity: json['equipmentQuantity'],
      equipmentTotalPrice: json['equipmentTotalPrice'],
      customerId: json['customerId'],
      status: json['status'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      customerCity: json['customerCity'],
      customerState: json['customerState'],
      customerCountry: json['customerCountry'],
      zipcode: json['zipcode'],
     
    );
  }
}