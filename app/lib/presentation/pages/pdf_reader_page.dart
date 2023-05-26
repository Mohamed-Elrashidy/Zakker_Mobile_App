import 'dart:io';
import 'package:app/presentation/widgets/main_button.dart';
import 'package:app/utils/dimension_scale.dart';
import 'package:app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfReaderPage extends StatelessWidget {
  File file;
  String data="";
  PdfReaderPage({required this.file});
  final PdfViewerController _pdfViewerController=PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
            children: [
              _appBarBuilder(context),
              Container(
                height: GetIt.instance.get<Dimension>().screenHeight-GetIt.instance.get<Dimension>().scaleHeight(100),

                child: SfPdfViewer.file(file, enableTextSelection: true,
                    controller:_pdfViewerController ,
                    onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                      if (details.selectedText != null) {
                        data=details.selectedText!;
                        print(details.selectedText);
                      }
                    }),
              ),
            ],
          )),
    );
  }

  Widget _appBarBuilder(BuildContext context) {
    return Padding (padding: EdgeInsets.all(10),child:  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        MainButton(title: "Add Note", onTap: (){
          String source =file.path.split('/')[file.path.split('/').length-1];
          source=source.substring(0,source.length-4);
          String header='$data |* $source';
          header+='|*'+ (_pdfViewerController.pageNumber+1).toString();
          Navigator.of(context).pushNamed(Routes.addNotePage,arguments: header);

        })
      ],
    ),);
  }
}