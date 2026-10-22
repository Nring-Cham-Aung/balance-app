import 'package:balance/core/database/db_helper.dart';
import 'package:balance/feature/category/model/category_model.dart';
import 'package:balance/feature/utility/balance_type.dart';
import 'package:intl/intl.dart';

class HomeRepository {
  Future<List<CategoryModel>> getCategories()async{
    var data = await DbHelper.db.query('category');
    return data.map((e)=>CategoryModel.fromMap(e)).toList();
  }

  Future<int> getBalance()async{
    String qurey = "SELECT SUM(amount) as total from balance where type = ?";
    Map<BalanceType, int> data = {};
    for (var type in BalanceType.values) {
      final list = await DbHelper.db.rawQuery(qurey, [type.name]);
      data[type] = _normilizeAmount(list);
    }
    return data[BalanceType.income]! - data[BalanceType.expense]!;
  }

  int _normilizeAmount(List<Map<String, dynamic>> list){
    final r = int.tryParse('${list.first['total']}');
    return r?? 0;
  }

  Future<List<int>> getSummary(DateTime date)async{
    String qurey = "SELECT SUM(amount) as total from balance where type = ? AND date LIKE ?";
    String dateStr = DateFormat('y-MM').format(date);
    Map<BalanceType, int> data = {};
    for (var type in BalanceType.values) {
      final list = await DbHelper.db.rawQuery(qurey, [type.name, '$dateStr%']);
      data[type] = _normilizeAmount(list);
    }
    return [data[BalanceType.income]!, data[BalanceType.expense]!];
  }


}