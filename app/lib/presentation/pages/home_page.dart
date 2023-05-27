import 'dart:io';
import 'package:app/presentation/controllers/note_controller/note_cubit.dart';
import 'package:app/presentation/widgets/big_text.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/services/notification_services.dart';
import 'package:app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:file_picker/file_picker.dart';


import '../../utils/dimension_scale.dart';

class HomePage extends StatelessWidget {
   Dimension scaleDimension=GetIt.instance.get<Dimension>();
  @override
  Widget build(BuildContext context) {
   // NotificationServices.checkNotificationLaunch();
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          _appBarBuilder(),
          SizedBox(
            height: scaleDimension.scaleHeight(100),
          ),
          _pdfReaderWidget(context),
          SizedBox(
            height: scaleDimension.scaleHeight(30),
          ),
          _TodaysSession(context)
        ],
      ),
    ));
  }

  Widget _appBarBuilder() {
    return Column(
      children: [
        SizedBox(
          height: scaleDimension.scaleHeight(5),
        ),
        BigText(text: "Home Page"),
        SizedBox(
          height: scaleDimension.scaleHeight(10),
        ),
        Container(
          width: scaleDimension.screenWidth,
          height: 2,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget _pdfReaderWidget(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
        final file =await _pickFile();
        if(file==null)

          {
            print("file is null =>");
            return;}
        print("file is =>"+file.path.toString());
        Navigator.of(context,rootNavigator: true).pushNamed(Routes.pdfReaderPage,arguments: file);
      },

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(scaleDimension.scaleWidth(16)),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/images/pdf_icon.svg",
                height: scaleDimension.scaleWidth(110),
              ),
              SizedBox(
                height: scaleDimension.scaleHeight(10),
              ),
              NormalText(
                text: "Open Pdf",
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _TodaysSession(BuildContext context) {
    return GestureDetector(
      onTap: () {

        Navigator.of(context,rootNavigator: true).pushNamed(Routes.todaysNotesPage);
        BlocProvider.of<NoteCubit>(context).getTodaysNotes();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(scaleDimension.scaleWidth(16)),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/images/todays_session_icon.svg",
                height: scaleDimension.scaleWidth(110),
              ),
              SizedBox(
                height: scaleDimension.scaleHeight(10),
              ),
              NormalText(
                text: "Today's session",
                color: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }

   Future<File?> _pickFile()async{
     final result =await FilePicker.platform.pickFiles(
       type: FileType.custom,
       allowedExtensions: ['pdf'],
     );
     if(result == null)return null;
     return File(result.paths.first!);
   }
}

