import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as path;

class PdfSaverProvider {
  static Future<String> saveEditedPdf(
      Uint8List signatureImage,
      File selectedPdf,
      int signaturePageNumber,
      double width,
      double height,
      Offset position,
      Size canvaSize) async {
    debugPrint("here1");
    //Create a new PDF document.
    final PdfDocument document = PdfDocument(
      inputBytes: selectedPdf.readAsBytesSync(),
    );
    document.compressionLevel = PdfCompressionLevel.belowNormal;
    debugPrint("here2");

//Get the existing PDF page.
    document.pageSettings.size = PdfPageSize.note;

    PdfPage page = document.pages[signaturePageNumber];
    debugPrint("here3");

//Load the image using PdfBitmap.
    final PdfBitmap image = PdfBitmap(
      signatureImage,
    );
    debugPrint("here4");

    double difference = height - 200;

// page.defaultLayer.graphics.drawImage(image, Rect.fromCenter(center: center, width: width, height: height))

//Draw the image to the PDF page.

    page.graphics.drawImage(
      image,
      // Rect.fromLTRB(
      //     position.dx, position.dx, position.dx + width, position.dy)
      // Rect.fromCenter(center: position, width: width, height: height)
      Rect.fromLTWH(position.dx + 120, position.dy - 10, 300, 300),

      // Rect.fromLTWH(position.dx, position.dy, width, height),
      // Rect.fromPoints(
      //     position, Offset(position.dx + width, position.dy + height)),
    );

    //Rect.fromLTWH(position.dx, position.dy, width, height)
    // Rect. fromPoints(
    //     position, Offset(position.dx + height, position.dy + height),),
    debugPrint("here5");

    //getting path
    Directory? appDirectory = await getExternalStorageDirectory();

    debugPrint(appDirectory.toString());

    // if(Platform.isIOS){
    //   appDirectory = getappli
    // }

    debugPrint("here6");

    String filePath =
        '${appDirectory?.path}/${(path.basename(selectedPdf.path))}';
    debugPrint("here7");

// Save the document.
    File(filePath).writeAsBytes(await document.save());
    debugPrint("here8");

    debugPrint("saved");

// Dispose the document.
    document.dispose();

    return filePath;
  }
}
