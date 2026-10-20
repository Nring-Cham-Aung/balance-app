import 'package:balance/bin/icon_code.dart';
import 'package:balance/bin/icon_mapper.dart';
import 'package:balance/feature/category/category_repository.dart';
import 'package:balance/feature/category/model/category_model.dart';
import 'package:flutter/material.dart';

class CategoryFromPage extends StatefulWidget {
  final CategoryModel? category;
  final CategoryRepository repo;
  const new({super.key, this.category, required this.repo});

  @override
  State<CategoryFromPage> createState() => _CategoryFromPageState();
}

class _CategoryFromPageState extends State<CategoryFromPage> {

  final TextEditingController _controller = TextEditingController();

  IconCode? _iconCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category is CategoryModel? "Update category" : "Create category"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Category name"
              ),
            ),

            const SizedBox(height: 50),

            ListTile(
              leading: _iconCode == null? null : Icon(IconMapper.iconFromIconCode(_iconCode!)),
              title: Text(_iconCode == null? "please select an icon" : "is selected"),
              
            ),


            const SizedBox(height: 50),

            Expanded(
              child: GridView.builder(
                
                itemCount: IconCode.values.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8
                ),
                itemBuilder: (_, i){
                  final icc = IconCode.values[i];
                  return GestureDetector(
                    onTap: (){
                      setState(() {_iconCode = icc;});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Icon(IconMapper.iconFromIconCode(icc))
                    ),
                  );
                }
              )
            ),

            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: _save,
                icon: Icon(Icons.save),
                label: Text("Save")
              )
            )
        
          ],
        ),
      ),
    );
  }

  Future<void> _save()async{
    final name = _controller.text;
    if(name.isEmpty || _iconCode == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Name and Icon are required!")));
      return;
    }
    final category = CategoryModel(id:0, name: name, iconCode: _iconCode!.name);
    await widget.repo.insert(category);
    if(mounted) Navigator.pop(context, true);
  }


}