import 'package:balance/core/database/db_helper.dart';
import 'package:balance/feature/balance_repository.dart';
import 'package:balance/feature/model/balance_model.dart';
import 'package:balance/feature/utility/balance_type.dart';
import 'package:intl/intl.dart';

class IncomeRepository extends BalanceRepository {
  Future<List<BalanceModel>> incomeList(DateTime date)async {
    final dateStr = DateFormat('y-MM').format(date);
    final data = await DbHelper.db.query('balance', where: 'type = ? AND date LIKE ?', whereArgs: [BalanceType.income.name, '$dateStr%']);
    return data.map((e)=>BalanceModel.fromJson(e)).toList();
  }
}