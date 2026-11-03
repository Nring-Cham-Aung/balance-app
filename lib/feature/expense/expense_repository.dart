import 'package:balance/core/database/db_helper.dart';
import 'package:balance/feature/balance_repository.dart';
import 'package:balance/feature/model/balance_model.dart';
import 'package:balance/feature/utility/balance_type.dart';
import 'package:intl/intl.dart';

class ExpenseRepository extends BalanceRepository {
  Future<List<BalanceModel>> expenseList(DateTime date, [String? title])async {
    final dateStr = DateFormat('y-MM').format(date);
    final data = title != null
    ? await DbHelper.db.query('balance', where: 'type = ? AND date LIKE ? AND title = ?', whereArgs: [BalanceType.expense.name, '$dateStr%', title])
    : await DbHelper.db.query('balance', where: 'type = ? AND date LIKE ?', whereArgs: [BalanceType.expense.name, '$dateStr%']);
    return data.map((e)=>BalanceModel.fromJson(e)).toList();
  }

}