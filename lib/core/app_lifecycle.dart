import 'dart:async';

import 'package:balance/feature/category/model/category_model.dart';
import 'package:balance/feature/model/month_data_model.dart';

class AppLifecycle {
  static MonthDataModel _monthDataModel = MonthDataModel(month: DateTime.now(), income: 0, expense: 0);
  MonthDataModel get monthDataModel => _monthDataModel;
  final _monthDataControlelr = StreamController<MonthDataModel>();
  Stream<MonthDataModel> get monthDataStream => _monthDataControlelr.stream;

  final _categoryController = StreamController<List<CategoryModel>>();
  Stream<List<CategoryModel>> get categoryStream => _categoryController.stream;

  void refreshCategory (List<CategoryModel> data) {
    _categoryController.add(data);
  }

  void refreshMonthDataModel(MonthDataModel dataModel){
    _monthDataModel = dataModel;
    _monthDataControlelr.add(dataModel);
  }


  final _balanceController = StreamController<int>();
  Stream<int> get balance => _balanceController.stream;

  void setBalance(int balance){
    _balanceController.add(balance);
  }
  


}