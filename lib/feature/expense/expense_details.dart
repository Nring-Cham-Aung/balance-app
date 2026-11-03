import 'package:balance/feature/expense/expense_repository.dart';
import 'package:balance/feature/model/balance_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseDetails extends StatefulWidget {
  final ExpenseRepository repo;
  final DateTime date;
  const new({super.key, required this.repo, required this.date});

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        physics: ScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: colors.surface,
            surfaceTintColor: Colors.transparent,
            shadowColor: colors.shadow.withValues(alpha: 0.3),
            pinned: true,
            title: Text('Expense details'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(DateFormat('y MMMM').format(widget.date), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      SizedBox(
                        width: 150,
                        child: Divider(endIndent: 20,),
                      )
                    ],
                  ),
                ),
              )
            ),
          ),

          SliverList.list(
            children: [
              FutureBuilder(
                future: widget.repo.expenseList(widget.date, title),
                builder: (_, snapshot)=> !snapshot.hasData
                ? const Loader()
                : snapshot.data!.isEmpty
                ? empty()
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FilterList(list: snapshot.data!, onSelected: _onSelected,),
                    ...snapshot.data!.map((e)=>listItem(e))
                  ],
                )
              )
            ]
          )


        ],
      ),
    );
  }


  Widget listItem(BalanceModel model)=>
  ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    leading: CircleAvatar(child: Icon(Icons.keyboard_double_arrow_down_rounded)),
    title: Text('${model.amount} ks'),
    subtitle: Text(model.title),
    trailing: Text(model.date),
  );

  Widget empty(){
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black12,
            child: Icon(Icons.format_list_bulleted_rounded, color: Colors.black45, size: 30,)
          ),
          const SizedBox(height: 20),
          Text('There is no data to display yet!', style: TextStyle(color: Colors.black45),),
        ]
      ),
    );
  }


  String? title;

  Future<void> _onSelected(String? v)async{
   title = v;
   setState(() {});
  }

}


class Loader extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      width: 200,
      child: Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}


class FilterList extends StatefulWidget {
  final List<BalanceModel> list;
  final void Function(String?) onSelected;
  const new({super.key, required this.list, required this.onSelected});

  @override
  State<FilterList> createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {

  String _selected = '';


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 48,
      child: ListView(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 4, bottom: 4),
        scrollDirection: Axis.horizontal,
        children: widget.list.map((e)=>e.title).toSet().map(
          (v)=> Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.primary),
                backgroundColor: _selected==v? colors.primaryContainer : null
              ),
              onPressed: (){
                if(_selected == v){
                  setState(() {_selected = '';});
                  widget.onSelected(null);
                  return;
                }
                setState(() {_selected = v;});
                widget.onSelected(v);
              }, 
              child: Text(v)
            ),
          )
        ).toList(),
      ),
    );
  }
}