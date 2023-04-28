import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/presentation/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/category.dart';
import '../../utils/dimension_scale.dart';
import '../../utils/note_colors.dart';

class CategoryWidget extends StatelessWidget {
  Dimension scaleDimension = GetIt.instance.get<Dimension>();
  final  category;
  CategoryWidget({required this.category});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: scaleDimension.scaleHeight(10)),
      decoration: BoxDecoration(
          color: NoteColors.color[category.color]!.withOpacity(0.2),
          borderRadius: BorderRadius.circular(scaleDimension.scaleWidth(16))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.folder,
              color: NoteColors.color[category.color],
              size: scaleDimension.scaleWidth(100)),
          NormalText(text: category.title),
          SmallText(text: category.numberOfNotes.toString() + " Notes")
        ],
      ),
    );
  }
}
