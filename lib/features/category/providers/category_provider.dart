import 'package:flutter/material.dart';
import 'package:kuruvikal/core/services/category_api_service.dart';
import 'package:kuruvikal/core/utils/app_error_handler.dart';
import '../models/category_menu_model.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryApiService _apiService = CategoryApiService();

  bool isLoading = false;
  List<CategoryMenuModel> categories = [];

  Future<void> fetchCategories() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _apiService.getCategories();

      categories = response
          .map<CategoryMenuModel>(
              (e) => CategoryMenuModel.fromJson(e))
          .toList();
    } catch (e) {
      AppErrorHandler.handle(e, fallbackMessage: 'Failed to load categories');
      categories = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
