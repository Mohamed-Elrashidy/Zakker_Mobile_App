import 'package:app/presentation/controllers/categories_controller/category_cubit.dart';
import 'package:app/presentation/controllers/note_controller/note_cubit.dart';
import 'package:app/presentation/widgets/big_text.dart';
import 'package:app/presentation/widgets/main_button.dart';
import 'package:app/utils/note_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/note.dart';
import '../../utils/dimension_scale.dart';

class AddNotePage extends StatelessWidget {
// text fields controllers
  TextEditingController _bodyController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _pageNumberController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();
  TextEditingController _imagePath = TextEditingController();

  Dimension scaleDimension = GetIt.instance.get<Dimension>();
  int _noteColor = 0;

  @override
  Widget build(BuildContext context) {
    // tempfunction

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
                _appBarBuilder(),
                _bodyBuilder(context),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _appBarBuilder() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_back_ios_new),
            )
          ],
        ),
        BigText(text: "Add Note"),
      ],
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: scaleDimension.scaleHeight(15),
        ),
        _textFieldBuilder("Title", "Add title here", _titleController, true),
        SizedBox(
          height: scaleDimension.scaleHeight(15),
        ),
        _textFieldBuilder("Body", "Add body here", _bodyController, true),
        SizedBox(
          height: scaleDimension.scaleHeight(15),
        ),
        _textFieldBuilder("Source", "Add source here", _sourceController, true),
        SizedBox(
          height: scaleDimension.scaleHeight(15),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _textFieldBuilder("Category", "", _categoryController, false),
            _textFieldBuilder("Page", "", _pageNumberController, false),
          ],
        ),
        SizedBox(height: scaleDimension.scaleHeight(10)),
        imagePicker(),
        colorPicker(),
        SizedBox(height: scaleDimension.scaleHeight(20)),
        MainButton(
            title: "Create Note",
            onTap: () {
              _createNote(context);
            }),
        SizedBox(height: scaleDimension.scaleHeight(30)),
      ],
    );
  }

  void _createNote(BuildContext context) {
    if (_titleController.text.trim().isEmpty) {
      print("title is empty");
    } else if (_sourceController.text.trim().isEmpty) {
      print("source is empty");
    } else if (_categoryController.text.trim().isEmpty) {
      print("Category field is empty");
    } else {
      BlocProvider.of<NoteCubit>(context).addNote(Note(
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          image: _imagePath.text,
          category: _categoryController.text.trim(),
          page: _pageNumberController.text.trim().isEmpty
              ? -1
              : int.parse(_pageNumberController.text.trim()),
          source: _sourceController.text.trim(),
          id: 0, // it is a default value will be modified at NoteRepository file
          color: _noteColor,
          date: DateTime.now().toString()));

      BlocProvider.of<NoteCubit>(context).getAllNotes();
      BlocProvider.of<CategoryCubit>(context).getAllCategories();
      BlocProvider.of<CategoryCubit>(context)
          .getCategorySources(_categoryController.text.trim());
    }
  }

  Widget _textFieldBuilder(String title, String hint,
      TextEditingController controller, bool isFullWidth) {
    return Container(
      width: isFullWidth
          ? scaleDimension.screenWidth
          : scaleDimension.screenWidth / 2 - scaleDimension.scaleWidth(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigText(text: title, size: scaleDimension.scaleWidth(18)),
          SizedBox(
            height: scaleDimension.scaleHeight(10),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: scaleDimension.scaleWidth(10)),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(scaleDimension.scaleWidth(16)),
                border: Border.all(color: Colors.grey[400]!, width: 1.5)),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                    fontSize: scaleDimension.scaleWidth(14),
                    color: Colors.grey[400]),
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget colorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(text: "Color", size: scaleDimension.scaleWidth(18)),
        SizedBox(
          height: scaleDimension.scaleHeight(10),
        ),
        Row(
          children: [
            Container(
              height: scaleDimension.scaleHeight(scaleDimension.scaleWidth(45)),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: NoteColors.color.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _noteColor = index;
                            },
                            child: CircleAvatar(
                              backgroundColor: NoteColors.color[index],
                              radius: scaleDimension.scaleWidth(20),
                            ),
                          ),
                          SizedBox(
                            width: scaleDimension.scaleWidth(25),
                          )
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget imagePicker() {
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
              child: CircleAvatar(
                radius: scaleDimension.scaleHeight(80),
                backgroundColor: Colors.grey,
              ),
            ),
          ],
        )
      ],
    );
  }
}
