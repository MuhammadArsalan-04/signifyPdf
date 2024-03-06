import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:signature_app/provider/signature_provider.dart';

class SignaturePainter extends CustomPainter {
  List<List<Offset?>> _signatureOffsets;
  Color strokeColor;
  double strokeWidth;
  Canvas? drawnCanvas;

  // List<Offset> _signatureOffsets;

  SignaturePainter(
    this._signatureOffsets,
    this.strokeColor,
    this.strokeWidth,
  );
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..filterQuality = FilterQuality.high;

    for (var stroke in _signatureOffsets) {
      if (stroke.length > 1) {
        for (int i = 0; i < stroke.length - 1; i++) {
          if (stroke[i] != null && stroke[i + 1] != null) {
            // Draw lines within each stroke
            canvas.drawLine(stroke[i]!, stroke[i + 1]!, paint);
          }
        }
      }
    }

    drawnCanvas = canvas;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return true;
  }

  //getter
  // List<Offset> get getSignaturePoints {
  //   return _signatureOffsets;
  // }

  List<List<Offset?>> get getSignaturePoints {
    return _signatureOffsets;
  }

  //setter
  // set setSignaturePoints(List<Offset> signaturePoints) {
  //   _signatureOffsets = signaturePoints;
  // }
  // set setSignaturePoints(List<List<Offset>> signaturePoints) {
  //   _signatureOffsets = signaturePoints;
  // }

  Future<Uint8List?> exportCanvasToImage() async {
    // Create a PictureRecorder to record the canvas
    ui.PictureRecorder recorder = ui.PictureRecorder();

    // Convert the recorded canvas into an Image

    ui.Image img = await recorder.endRecording().toImage(200, 200);

    // Convert Image to ByteData
    ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    debugPrint("--------------" + byteData!.buffer.asUint8List().toString());

    // Convert ByteData to Uint8List
    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();
      debugPrint(pngBytes.toString());
      return pngBytes;
    } else {
      return null;
    }

    // Now you can do whatever you want with the bytes,
    // e.g., save them to a file or send them over the network.
  }
}
