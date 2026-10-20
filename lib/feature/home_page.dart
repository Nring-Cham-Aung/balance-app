
import 'package:balance/core/app_lifecycle.dart';
import 'package:balance/feature/category/category_from_page.dart';
import 'package:balance/feature/category/category_repository.dart';
import 'package:balance/feature/home_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'category/model/category_model.dart';
import 'widget/icon_card.dart';
import 'widget/summary_card.dart';

class HomePage extends StatelessWidget {
  final AppLifecycle lifecycle;
  final HomeRepository repo;
  const new({super.key, required this.lifecycle, required this.repo});

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
                Text("45000 ks", style: TextTheme.of(context).titleMedium,),
                IconButton(onPressed: (){}, icon: Icon(Icons.add))
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
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
                          label: StreamBuilder(
                            stream: lifecycle.monthStream,
                            builder: (context, asyncSnapshot) {
                              return Text(DateFormat('y MMMM').format(lifecycle.selectedMonth), style: TextTheme.of(context).titleMedium?.copyWith(color: color.primary));
                            }
                          )
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
                ),
              ),
            ),
            SliverList.list(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: StreamBuilder(
                    stream: lifecycle.categoryStream,
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
          if(result is bool && result){
            final data = await repo.getCategories();
            lifecycle.refreshCategory(data);
          }
        },
        child: Icon(Icons.add)
      ),


    );
  }

  Future<void> _selectMonth(BuildContext context)async{
    DateTime? value = await showMonthPicker(context: context, initialDate: lifecycle.selectedMonth);
    if(value == null) return;
    lifecycle.setMonth(value);
  }
}
