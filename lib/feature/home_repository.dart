import 'package:balance/core/database/db_helper.dart';
import 'package:balance/feature/category/model/category_model.dart';

class HomeRepository {
  Future<List<CategoryModel>> getCategories()async{
    var data = await DbHelper.db.query('category');
    return data.map((e)=>CategoryModel.fromMap(e)).toList();
  }
}