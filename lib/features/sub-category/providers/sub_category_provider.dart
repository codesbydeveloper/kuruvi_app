import 'package:flutter/material.dart';
import 'package:kuruvikal/core/services/inventory_api_service.dart';
import 'package:kuruvikal/core/services/local_storage_service.dart';
import 'package:kuruvikal/core/services/sub_category_api_service.dart';
import 'package:kuruvikal/core/utils/app_error_handler.dart';
import 'package:kuruvikal/features/sub-category/models/inventory_product_model.dart';
import 'package:kuruvikal/features/sub-category/models/sub_category_model.dart';

class SubCategoryProvider extends ChangeNotifier {
  final SubCategoryApiService _apiService = SubCategoryApiService();
  final InventoryApiService _inventoryApiService = InventoryApiService();
  final LocalStorageService _localStorageService = LocalStorageService();

  bool isLoading = false;
  bool isProductsLoading = false;
  SubCategoryResponse? category;
  List<SubCategoryItem> subCategories = [];
  List<InventoryProduct> products = [];

  Future<void> fetchSubCategories(String categoryId) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _apiService.getSubCategories(categoryId);
      category = SubCategoryResponse.fromJson(response);
      subCategories = category?.subCategories ?? [];
    } catch (e) {
      AppErrorHandler.handle(e, fallbackMessage: 'Failed to load sub categories');
      category = null;
      subCategories = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsForSubCategory(String subCategoryId) async {
    try {
      isProductsLoading = true;
      notifyListeners();

      final storeId = await _localStorageService.getNearestStoreId();
      if (storeId == null || storeId.isEmpty) {
        throw Exception("Nearest store id not found");
      }

      final response = await _inventoryApiService.getProductsBySubCategory(
        storeId,
        subCategoryId,
      );

      products = response
          .map<InventoryProduct>((e) => InventoryProduct.fromJson(e))
          .toList();
    } catch (e) {
      AppErrorHandler.handle(e, fallbackMessage: 'Failed to load products');
      products = [];
    } finally {
      isProductsLoading = false;
      notifyListeners();
    }
  }
}
