import 'package:balance/bin/icon_mapper.dart';
import 'package:balance/feature/category/model/category_model.dart';
import 'package:balance/feature/expense/expense_repository.dart';
import 'package:balance/feature/model/balance_model.dart';
import 'package:balance/feature/utility/balance_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseFormPage extends StatefulWidget {
  final ExpenseRepository repo;
  final CategoryModel category;
  const new({super.key, required this.repo, required this.category});

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {


  final fkey = GlobalKey<FormState>();
  final amountC = TextEditingController();
  final dateC = TextEditingController();

  DateTime? _selectedDate;



  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30
              ),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 1, offset: Offset(0, 1))
                ]
              ),
              child: Form(
                key: fkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.onPrimaryContainer.withAlpha(80))
                        ),
                        child: Icon(IconMapper.icon(widget.category.iconCode), size: 50, color: colors.onPrimaryContainer,)
                      )
                    ),
                    const SizedBox(height: 20),
                    Text(widget.category.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: amountC,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Amount",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.money)
                      ),
                      validator: _amountValidate,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: dateC,
                      readOnly: true,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: "Select a date",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.date_range)
                      ),
                      onTap: ()async{
                        DateTime? dt = await showDatePicker(context: context, firstDate: DateTime(2025), lastDate: DateTime.now().add(Duration(days: 1)), initialDate: _selectedDate);
                        if(dt == null) return;
                        _selectedDate = dt;
                        dateC.text = DateFormat('MMM dd, y').format(dt);
                        setState(() {});
                      },
                      validator: (v) => _selectedDate == null? "require a valid date" : null,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8)
                        ),
                      ),
                      onPressed: _save,
                      label: Text("Save"),
                      icon: Icon(Icons.done),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String? _amountValidate(String? v){
    String message = "required a valid amount";
    if(v == null) return message;
    int? amt = int.tryParse(v);
    if(amt == null) return message;
    if(amt<=0) return message;
    return null;
  }


  Future<void> _save()async{
    if(!fkey.currentState!.validate()) return;
    final balance = BalanceModel(
      id: 0,
      amount: int.parse(amountC.text),
      title: widget.category.name,
      type: BalanceType.expense,
      date: DateFormat('y-MM-dd').format(_selectedDate!)
    );

    final insertedItem = await widget.repo.insert(balance);

    if(mounted) Navigator.pop(context, insertedItem);

  }


}