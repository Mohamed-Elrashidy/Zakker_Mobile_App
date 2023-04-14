import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel(
      {required super.title,
      required super.color,
      required super.id,
      required super.numberOfNotes,
      required super.isSource,
      required super.isCategory});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        title: json['title'],
        color: int.parse(json['color']),
        id: int.parse(json['id']),
        numberOfNotes: int.parse(json['numberOfNotes']),
        isSource: json['isSource'] == "true" ? true : false,
        isCategory: json['isCategory'] == "true" ? true : false);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = title;
    json['color'] = color.toString();
    json['id'] = id.toString();
    json['numberOfNotes'] = numberOfNotes.toString();
    json['isSource'] = isSource.toString();
    json['isCategory'] = isCategory.toString();

    return json;
  }
}
