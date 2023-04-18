import 'package:app/presentation/widgets/big_text.dart';
import 'package:app/presentation/widgets/main_button.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/presentation/widgets/small_button.dart';
import 'package:app/presentation/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/note.dart';
import '../../utils/dimension_scale.dart';

class EditNotePage extends StatelessWidget {
  final Note note;
  EditNotePage({required this.note});
  late Dimension scaleDimension;


  TextEditingController _bodyController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _pageNumberController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();
  TextEditingController _imagePath = TextEditingController();
  @override
  Widget build(BuildContext context) {
    dimensionInit(context);
    return SafeArea(
      child: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();

        },
        child: Scaffold(
            body: Padding(
                padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _appBarBuilder(),
                      SizedBox(
                        height: scaleDimension.scaleHeight(10),
                      ),
                      Container(
                          height: 2,
                          width: scaleDimension.screenWidth,
                          color: Colors.grey[400]),
                      _bodyBuilder(),
                      SizedBox(
                        height: scaleDimension.scaleHeight(10),
                      ),
                      _noteData(),
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget _appBarBuilder() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          SmallButton(icon: Icons.highlight_remove_outlined, onTap: (){}),
          BigText(text: "Edit Note"),
          SmallButton(icon: Icons.check_circle_outline, onTap: (){})
          ],
        ),
      ],
    );
  }

  Widget _bodyBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: scaleDimension.scaleHeight(15),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: scaleDimension.scaleWidth(10)),
              child: _textFieldBuilder( note.title, _titleController, true),
            ),
          ],
        ),
        SizedBox(
          height: scaleDimension.scaleHeight(10),
        ),
        Container(
            height: 2,
            width: scaleDimension.screenWidth,
            color: Colors.grey[400]),
        SizedBox(
          height: scaleDimension.scaleHeight(10),
        ),
_textFieldBuilder( note.body, _bodyController, true)      ],
    );
  }

  Widget _noteData() {
    return Row(
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,


          children: [
            BigText(
              text: "Note Data",
            ),
            SizedBox(height:
            scaleDimension.scaleHeight(20),),
            Row(
              children: [SmallText(text: "Category : "),
                _textFieldBuilder(note.category, _categoryController, false),
              ],
            ),
            Row(
              children: [
                SmallText(text: "Source : "),
                _textFieldBuilder(note.source, _sourceController, false),
              ],
            ),
            Row(
              children: [
                SmallText(text: "Page : "),
                _textFieldBuilder(note.page.toString(), _pageNumberController, false),
              ],
            ),




          ],
        ),
      ],
    );
  }
  Widget itemBuilder(String title,String info)
  {
    return SmallText(text:title+' : '+info);

  }
  Widget _textFieldBuilder(String data,
      TextEditingController controller, bool isFullWidth) {
    controller.text=data;
    return Container(
      width:  isFullWidth
          ? scaleDimension.screenWidth-scaleDimension.scaleWidth(30)
          : scaleDimension.screenWidth / 2 - scaleDimension.scaleWidth(20),

      child: Container(
        padding:
        EdgeInsets.symmetric(horizontal: scaleDimension.scaleWidth(10)),
        decoration: BoxDecoration(
            border: Border.all(width: 0,color: Colors.transparent)),
        child: TextField(
          style: isFullWidth?TextStyle(
              fontSize: scaleDimension.scaleWidth(18),
              color: Colors.black):TextStyle(
              fontSize: scaleDimension.scaleWidth(14),
              color: Colors.grey[400]),
          maxLines: null,
          controller: controller,
          decoration: InputDecoration(


            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
  dimensionInit(BuildContext context) {
    try {
      // Get the intialized instance of Dimension class to make ui scalable

      Dimension scaleDimension = GetIt.instance.get<Dimension>();
      this.scaleDimension = scaleDimension;
    } catch (e) {
      GetIt locator = GetIt.instance;
      locator.registerSingleton<Dimension>(Dimension(context: context));

      // Get the initialized instance of Dimension class to make ui scalable
      Dimension scaleDimension = GetIt.instance.get<Dimension>();
      this.scaleDimension = scaleDimension;
    }
  }
}
