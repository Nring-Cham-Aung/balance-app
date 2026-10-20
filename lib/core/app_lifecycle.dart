import 'dart:async';

import 'package:balance/feature/category/model/category_model.dart';

class AppLifecycle {
  DateTime _selectedMonth = DateTime.now();
  DateTime get selectedMonth => _selectedMonth;
  final _dateControlelr = StreamController<DateTime>();
  Stream<DateTime> get monthStream => _dateControlelr.stream;

  final _categoryController = StreamController<List<CategoryModel>>();
  Stream<List<CategoryModel>> get categoryStream => _categoryController.stream;

  void refreshCategory (List<CategoryModel> data) {
    _categoryController.add(data);
  }

  void setMonth(DateTime dateTime){
    _selectedMonth = dateTime;
    _dateControlelr.add(_selectedMonth);
  }
  


}