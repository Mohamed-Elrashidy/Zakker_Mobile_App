import 'dart:io';

import 'package:app/presentation/pages/pdf_reader_page.dart';
import 'package:app/presentation/widgets/main_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../utils/routes.dart';

class PDFScreen extends StatelessWidget {
  final String path;

  const PDFScreen({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PDF Viewer'),
        ),
        body: Center(
          child:Container(
            child: MainButton(title: 'File pdf', onTap: ()async{
              final file =await pickFile();
              if(file==null)
                return;
             Navigator.of(context).pushNamed(Routes.pdfViewerPage,arguments: file);
            },

            ),
          )
          ,
        )
    );
  }
  Future<File?> pickFile()async{
    final result =await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if(result == null)return null;
    return File(result.paths.first!);
  }

}
