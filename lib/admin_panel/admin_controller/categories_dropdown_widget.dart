// ignore_for_file: file_names, prefer_const_constructors

import 'package:farmer_eboard/admin_panel/admin_controller/categories_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropDownCategoriesWiidget extends StatelessWidget {
  const DropDownCategoriesWiidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryDropDownController>(
      init: CategoryDropDownController(),
      builder: (categoriesDropDownController) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            value: categoriesDropDownController.selectedCategoryId?.value,
            items: categoriesDropDownController.categories.map((category) {
              return DropdownMenuItem<String>(
                value: category['categoryId'],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        category['categoryImg'].toString(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(category['categoryName']),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? selectedValue) async {
              categoriesDropDownController.setSelectedCategory(selectedValue);
              String? categoryName =
                  await categoriesDropDownController.getCategoryName(selectedValue);
              categoriesDropDownController.setSelectedCategoryName(categoryName);
            },
            hint: const Text('Select Category'),
            isExpanded: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
