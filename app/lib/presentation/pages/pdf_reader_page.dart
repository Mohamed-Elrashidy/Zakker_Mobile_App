import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfReaderPage extends StatelessWidget {

  File file;
  PdfReaderPage({required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SfPdfViewer.file(
       file,
      enableTextSelection: true,
      onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
    if (details.selectedText != null) {
    print(details.selectedText);
    }}
      )
    );
  }
}
