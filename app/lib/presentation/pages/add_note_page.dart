import 'package:app/presentation/widgets/big_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/dimension_scale.dart';

class AddNotePage extends StatelessWidget {
// text fields controllers
  TextEditingController _bodyController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _pageNumberController = TextEditingController();
  TextEditingController _noteColor = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();
  TextEditingController _imagePath = TextEditingController();

  late Dimension scaleDimension;

  @override
  Widget build(BuildContext context) {
    // tempfunction
    dimensionInit(context);

    return SafeArea(
      child: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();

        },
        child: Scaffold(
            body: Padding(
          padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
          child: Column(
            children: [
              _appBarBuilder(),
              _bodyBuilder(),
            ],
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

  Widget _bodyBuilder() {
    return Column(
      children: [
        SizedBox(height: scaleDimension.scaleHeight(15),),

        _textFieldBuilder("Title","Add title here",_titleController, true),
        SizedBox(height: scaleDimension.scaleHeight(15),),
        _textFieldBuilder("Body","Add body here",_bodyController, true),
        SizedBox(height: scaleDimension.scaleHeight(15),),
        _textFieldBuilder("Source","Add source here",_sourceController, true),
        SizedBox(height: scaleDimension.scaleHeight(15),),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          _textFieldBuilder("Category","",_sourceController, false),
          _textFieldBuilder("Page","",_sourceController, false),


        ],)

      ],
    );
  }

  void _createNote() {}

  Widget _textFieldBuilder(String title,String hint,TextEditingController controller, bool isFullWidth) {
    return Container(
      width: isFullWidth
          ? scaleDimension.screenWidth
          : scaleDimension.screenWidth / 2-scaleDimension.scaleWidth(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigText(text: title,size:scaleDimension.scaleWidth(18)),
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
                  color: Colors.grey[400]
                ),
                border: InputBorder.none,
              ),
            ),
          )
        ],
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
