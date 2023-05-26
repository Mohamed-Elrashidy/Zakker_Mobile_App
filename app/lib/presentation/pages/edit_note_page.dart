import 'dart:io';

import 'package:app/presentation/controllers/note_controller/note_cubit.dart';
import 'package:app/presentation/widgets/big_text.dart';
import 'package:app/presentation/widgets/main_button.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/presentation/widgets/small_button.dart';
import 'package:app/presentation/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/note.dart';
import '../../utils/dimension_scale.dart';

class EditNotePage extends StatefulWidget {
  final Note note;
  EditNotePage({required this.note});
  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  Dimension scaleDimension = GetIt.instance.get<Dimension>();

  TextEditingController _bodyController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _pageNumberController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();
  String _imagePath = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imagePath = widget.note.image;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            body: Padding(
                padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _appBarBuilder(context),
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
                      //        _noteData(),
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget _appBarBuilder(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SmallButton(
                icon: Icons.highlight_remove_outlined,
                onTap: () {
                  Navigator.of(context).pop();
                }),
            BigText(text: "Edit Note"),
            SmallButton(
                icon: Icons.check_circle_outline,
                onTap: () {
                  widget.note.title = _titleController.text.trim();
                  widget.note.body = _bodyController.text.trim();
                  widget.note.category = _categoryController.text.trim();
                  widget.note.source = _sourceController.text.trim();
                  widget.note.image = _imagePath;

                  BlocProvider.of<NoteCubit>(context).editNote(widget.note);
                  BlocProvider.of<NoteCubit>(context).getAllNotes();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                })
          ],
        ),
      ],
    );
  }

  Widget _bodyBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: scaleDimension.scaleHeight(300),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: scaleDimension.scaleHeight(15),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: scaleDimension.scaleWidth(10)),
                      child: _textFieldBuilder(
                          widget.note.title, _titleController, true),
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
                _textFieldBuilder(widget.note.body, _bodyController, true),
              ],
            )),
        _imagePicker()
      ],
    );
  }

  /*Widget _noteData() {
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
                _textFieldBuilder(widget.note.category, _categoryController, false),
              ],
            ),
            Row(
              children: [
                SmallText(text: "Source : "),
                _textFieldBuilder(widget.note.source, _sourceController, false),
              ],
            ),
            Row(
              children: [
                SmallText(text: "Page : "),
                _textFieldBuilder(widget.note.page.toString(), _pageNumberController, false),
              ],
            ),




          ],
        ),
      ],
    );
  }*/
  Widget itemBuilder(String title, String info) {
    return SmallText(text: title + ' : ' + info);
  }

  Widget _textFieldBuilder(
      String data, TextEditingController controller, bool isFullWidth) {
    controller.text = data;
    return Container(
      width: isFullWidth
          ? scaleDimension.screenWidth - scaleDimension.scaleWidth(30)
          : scaleDimension.screenWidth / 2 - scaleDimension.scaleWidth(20),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: scaleDimension.scaleWidth(10)),
        decoration: BoxDecoration(
            border: Border.all(width: 0, color: Colors.transparent)),
        child: TextField(
          style: isFullWidth
              ? TextStyle(
                  fontSize: scaleDimension.scaleWidth(18), color: Colors.black)
              : TextStyle(
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

  Widget _imagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(text: "Image", size: scaleDimension.scaleWidth(18)),
        SizedBox(
          height: scaleDimension.scaleHeight(10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _pickImage();
                print(_imagePath);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: Colors.grey,
                ),
                width: scaleDimension.scaleWidth(250),
                height: scaleDimension.scaleWidth(250),
                child: _imagePath != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.file(
                          File(_imagePath),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(),
              ),
            ),
          ],
        )
      ],
    );
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        print("new image");
        _imagePath = image.path;
        print(_imagePath);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
