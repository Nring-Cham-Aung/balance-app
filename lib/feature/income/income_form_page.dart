import 'package:balance/feature/income/income_repository.dart';
import 'package:balance/feature/model/balance_model.dart';
import 'package:balance/feature/utility/balance_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeFormPage extends StatefulWidget {
  final IncomeRepository repo;
  const new({super.key, required this.repo});

  @override
  State<IncomeFormPage> createState() => _IncomeFormPageState();
}

class _IncomeFormPageState extends State<IncomeFormPage> {


  final fkey = GlobalKey<FormState>();
  final titleC = TextEditingController();
  final amountC = TextEditingController();
  final dateC = TextEditingController();

  DateTime? _selectedDate;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Income"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: fkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: titleC,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v==null || v.trim().isEmpty)? "required a valid title" : null,
              ),
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
      title: titleC.text.trim(),
      type: BalanceType.income,
      date: DateFormat('y-MM-dd').format(_selectedDate!)
    );

    final insertedItem = await widget.repo.insert(balance);

    if(mounted) Navigator.pop(context, insertedItem);

  }


}