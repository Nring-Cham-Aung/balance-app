import 'package:balance/core/database/db_helper.dart';
import 'package:balance/feature/category/model/category_model.dart';

class CategoryRepository {
  Future<CategoryModel> insert(CategoryModel category)async{
    final normilize = category.toJson();
    normilize.remove('id');
    int insertedId = await DbHelper.db.insert('category', normilize);
    normilize['id']=insertedId;
    return CategoryModel.fromMap(normilize);
  }
}