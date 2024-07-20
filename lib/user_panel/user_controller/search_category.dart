import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:farmer_eboard/models/category_model.dart';

class CategoriesController extends GetxController {
  var searchQuery = ''.obs;
  List<CategoriesModel> categories = [].obs as List<CategoriesModel>;

  @override
  void onInit() {
    super.onInit();
    fetchCategories().then((fetchedCategories) {
      categories = fetchedCategories;
    });
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<CategoriesModel> filterCategories() {
    if (searchQuery.isEmpty) {
      return categories;
    } else {
      return categories.where((category) => category.categoryName.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }
  }

  Future<List<CategoriesModel>> fetchCategories() async {
    List<CategoriesModel> categories = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').get();
      for (var doc in querySnapshot.docs) {
        categories.add(
          CategoriesModel(
            categoryId: doc['categoryId'],
            categoryImg: doc['categoryImg'],
            categoryName: doc['categoryName'],
            createdAt: doc['createdAt'],
          ),
        );
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
    return categories;
  }
}
