import '../../domain/entities/source.dart';

class SourceModel extends Source {
  SourceModel(
      {required super.title,
      required super.color,
      required super.numberOfNotes,
      required super.id,
      required super.categoryId});

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      title: json['title'],
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      color:
      json['color'] is String ? int.parse(json['color']) : json['color'],
      categoryId: json['categoryId'] is String ? int.parse(json['categoryId']) : json['categoryId'],
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
    json['categoryId']=categoryId;
    json['numberOfNotes']=numberOfNotes;

    return json;
  }
}
