import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewrPage extends StatelessWidget {
  final File file;
  const PdfViewrPage({Key? key,required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:AppBar(

    )
        ,
      body: PDFView(
        filePath: file.path,

      ),
    );
  }
}
