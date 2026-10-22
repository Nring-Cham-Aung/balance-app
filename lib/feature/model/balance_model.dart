import 'package:balance/feature/utility/balance_type.dart';

class BalanceModel {
  final int id, amount;
  final String title, date;
  final BalanceType type;

  BalanceModel({
    required this.id,
    required this.amount,
    required this.title,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> get json => {
    'id': id,
    'title': title,
    'amount': amount,
    'type': type.name,
    'date': date
  };

  factory BalanceModel.fromJson(Map<String, dynamic> data){
    return BalanceModel(
      id: data['id'],
      amount: data['amount'],
      title: data['title'],
      type: data['type']==BalanceType.income.name? BalanceType.income : BalanceType.expense,
      date: data['date']
    );
  }

  
}