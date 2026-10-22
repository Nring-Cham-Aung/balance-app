class MonthDataModel {
  final DateTime month;
  final int income, expense;
  MonthDataModel({
    required this.month,
    required this.income,
    required this.expense
  });



  MonthDataModel copyWith({
    DateTime? month,
    int? income,
    int? expense
  }){
    return MonthDataModel(
      month: month?? this.month,
      income: income?? this.income,
      expense: expense?? this.expense
    );
  }
}