
import 'dart:async';

import 'package:balance/core/app_lifecycle.dart';
import 'package:balance/feature/category/category_from_page.dart';
import 'package:balance/feature/category/category_repository.dart';
import 'package:balance/feature/home_repository.dart';
import 'package:balance/feature/income/income_form_page.dart';
import 'package:balance/feature/income/income_repository.dart';
import 'package:balance/feature/model/month_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'category/model/category_model.dart';
import 'widget/icon_card.dart';
import 'widget/summary_card.dart';

class HomePage extends StatefulWidget {
  final AppLifecycle lifecycle;
  final HomeRepository repo;
  const new({super.key, required this.lifecycle, required this.repo});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();
    unawaited(initialize());
  }

  Future<void> initialize()async{
   await refreshBalance();
   await refreshSummary(widget.lifecycle.monthDataModel.month);
   await refreshCategory();
  }



  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text("Balance"),
              actionsPadding: EdgeInsets.only(right: 20),
              expandedHeight: 200,
              collapsedHeight: 80,
              actions: [
                StreamBuilder(
                  stream: widget.lifecycle.balance,
                  builder: (context, asyncSnapshot) {
                    final amt = asyncSnapshot.hasData? asyncSnapshot.data! : 0;
                    return Text("$amt ks", style: TextTheme.of(context).titleMedium,);
                  }
                ),
                IconButton(onPressed: () => _showIncomeForm(context), icon: Icon(Icons.add))
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: StreamBuilder(
                  stream: widget.lifecycle.monthDataStream,
                  builder: (context, asyncSnapshot) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(15)
                                ),
                                side: BorderSide(color: color.primary)
                              ),
                              onPressed: ()=> _selectMonth(context),
                              icon: Icon(Icons.date_range),
                              label: Text(
                                DateFormat('y MMMM')
                                .format(widget.lifecycle.monthDataModel.month),
                                style: TextTheme.of(context).titleMedium?.copyWith(color: color.primary)
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SummaryCard(
                                    text: "${widget.lifecycle.monthDataModel.income} ks",
                                    backgroundColor: color.primaryContainer,
                                    textColor: color.onPrimaryContainer,
                                    onTap: (){
                                      print("Clicked form Income");
                                    },
                                  ),
                                ),
                                VerticalDivider(color: color.secondary),
                                Expanded(
                                  child: SummaryCard(
                                    text: "${widget.lifecycle.monthDataModel.expense} ks",
                                    backgroundColor: color.tertiaryContainer,
                                    textColor: color.onTertiaryContainer,
                                    onTap: (){
                                      print("Clicked form Expense");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                ),
              ),
            ),
            SliverList.list(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: StreamBuilder(
                    stream: widget.lifecycle.categoryStream,
                    builder: (context, asyncSnapshot) {
                      final List<CategoryModel> data = asyncSnapshot.hasData? asyncSnapshot.data! : [];
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: data.map((e)=>IconCard(
                          iconCode: e.iconCode,
                          title: e.name,
                          onTap: (){})
                        ).toList(),
                      );
                    }
                  ),
                )
              ],
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          var result = await Navigator.push(context, CupertinoPageRoute(builder: (context)=> CategoryFromPage(repo: CategoryRepository())));
          if(result is bool && result) refreshCategory();
        },
        child: Icon(Icons.add)
      ),


    );
  }


  Future<void> refreshCategory()async{
    final data = await widget.repo.getCategories();
    widget.lifecycle.refreshCategory(data);
  }

  Future<void> refreshBalance()async{
    widget.lifecycle.setBalance(await widget.repo.getBalance());
  }

  Future<void> _selectMonth(BuildContext context)async{
    DateTime? value = await showMonthPicker(context: context, initialDate: widget.lifecycle.monthDataModel.month);
    if(value == null) return;
    refreshSummary(value);
  }

  Future<void> refreshSummary(DateTime value)async{
    final dataList = await widget.repo.getSummary(value);
    widget.lifecycle.refreshMonthDataModel(MonthDataModel(month: value, income: dataList.first, expense: dataList.last));
  }

  Future<void> _showIncomeForm(BuildContext context)async{
    final result = await Navigator.push(context, CupertinoPageRoute(builder: (context)=> IncomeFormPage(repo: IncomeRepository())));
    if(result != null){
      refreshBalance();
      refreshSummary(widget.lifecycle.monthDataModel.month);
    }
  }


}
