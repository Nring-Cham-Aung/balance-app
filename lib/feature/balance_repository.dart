import 'package:balance/core/database/db_helper.dart';
import 'package:balance/feature/model/balance_model.dart';

class BalanceRepository {
  Future<BalanceModel> insert(BalanceModel balance)async{
    Map<String,dynamic> normalizeData = balance.json;
    normalizeData.remove('id');
    int insertedId = await DbHelper.db.insert('balance', normalizeData);
    normalizeData['id'] = insertedId;
    return BalanceModel.fromJson(normalizeData);
  }
}