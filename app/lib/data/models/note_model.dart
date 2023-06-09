import '../../domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel(
      {required super.title,
      required super.body,
      required super.image,
      required super.category,
      required super.page,
      required super.source,
      required super.id,
      required super.color,
      required super.date});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
        title: json['title'],
        body: json['body'],
        image: json['image'],
        category: json['category'],
        page: json['page'] is String ? int.parse(json['page']) : json['page'],
        source: json['source'],
        id: json['id'] is String ? int.parse(json['id']) : json['id'],
        color:
            json['color'] is String ? int.parse(json['color']) : json['color'],
        date: json['date']);
  }

  Map<String, dynamic> toJson({bool flag=true}) {
    Map<String, dynamic> json = {};
    json['title'] = title;
    json['body'] = body;
    json['image'] = image;
    json['category'] = category;
    json['page'] = page.toString();
    json['color'] = color.toString();
    json['source'] = source;
    if(flag) {
      json['id'] = id.toString();
    }
    json['date'] = date;

    return json;
  }

}
