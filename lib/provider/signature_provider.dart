import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../presentations/custom_canvas/layout/signature_painter.dart';

class SignatureProvider with ChangeNotifier {
  Uint8List? _exportedSignatureImage;

  int? _pdfPageNo = 0;

  double? _signWidth = 200;
  double? _signHeight = 200;

  Size _canvasSize = Size(0, 0);

  Offset _signaturePosition = const Offset(0, 0);

  void clearExportedImage() {
    _exportedSignatureImage = null;
    notifyListeners();
  }

  Uint8List? get getExportedSignature {
    return _exportedSignatureImage;
  }

  Future<void> exportCanvasToImage(
    BuildContext context,
    List<List<Offset?>> _signaturePoints,
    Color selectedColor,
    double selectedStroke,
  ) async {
    // Create a PictureRecorder to record the canvas

    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    var size = context.size;

    SignaturePainter(_signaturePoints, selectedColor, selectedStroke)
        .paint(canvas, size!);

    _canvasSize = size;

    // Convert the recorded canvas into an Image
    ui.Image img = await recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());

    // Convert Image to ByteData
    ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    debugPrint("--------------" + byteData!.buffer.asUint8List().toString());

    _exportedSignatureImage = byteData.buffer.asUint8List();

    notifyListeners();
  }

  Size get getSize {
    return _canvasSize;
  }

  set setPdfPageNo(int pageNo) {
    _pdfPageNo = pageNo;
  }

  int? get getPdfPageNo {
    return _pdfPageNo;
  }

  set setSignWidth(double width) {
    _signWidth = width;
  }

  set setSignHeight(double height) {
    _signHeight = height;
  }

  set setSignaturePosition(Offset signPosition) {
    _signaturePosition = signPosition;
  }

  double? get getSignWidth {
    return _signWidth;
  }

  double? get getSignHeight {
    return _signHeight;
  }

  Offset get getSignaturePosition {
    return _signaturePosition;
  }

  void clearSignatureDetails() {
    _pdfPageNo = 0;
    _exportedSignatureImage = null;
    _signHeight = 200;
    _signWidth = 200;
    _signaturePosition = const Offset(0, 0);

    notifyListeners();
  }
}
