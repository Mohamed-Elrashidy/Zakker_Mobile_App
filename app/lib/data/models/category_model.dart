import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel(
      {required super.title,
      required super.color,
      required super.numberOfNotes,
        required super.id
     });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      title: json['title'],
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      color:
      json['color'] is String ? int.parse(json['color']) : json['color'],
      numberOfNotes: json['numberOfNotes'],

    );

  }

  Map<String, dynamic> toJson({bool flag=true}) {
    Map<String, dynamic> json = {};
    json['title'] = title;
    json['color'] = color.toString();
    if(flag) {
      json['id'] = id.toString();
    }
    json['numberOfNotes']=numberOfNotes;

    return json;
  }
}
