class CategoryModel {
  final int id;
  final String name, iconCode;
  const CategoryModel({required this.id, required this.name, required this.iconCode});

  Map<String,dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon_code': iconCode
  };

  factory CategoryModel.fromMap(Map<String,dynamic> map){
    return CategoryModel(
      id: map['id'] as int,
      name: map['name'] as String,
      iconCode: map['icon_code'] as String
    );
  }

}
