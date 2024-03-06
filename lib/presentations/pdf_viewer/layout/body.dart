import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:signature_app/configs/app_colors.dart';

import '../../../provider/signature_provider.dart';

// import 'package:pdf/pdf.dart';

class PdfViewerViewBody extends StatefulWidget {
  File pdfFile;
  PdfViewerViewBody({required this.pdfFile, super.key});

  @override
  State<PdfViewerViewBody> createState() => _PdfViewerViewBodyState();
}

class _PdfViewerViewBodyState extends State<PdfViewerViewBody> {
  Offset _position = const Offset(0, 0);
  double _scale = 1.0;
  Offset _previousOffset = const Offset(0, 0);

  bool isSignatureFocused = false;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    final pngProvider = Provider.of<SignatureProvider>(context);

    return Stack(
      children: [
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.green, width: 3)),
          child: PDFView(
            filePath: widget.pdfFile.path,
            autoSpacing: true,
            onError: (error) {
              debugPrint(error.toString());
            },
            onPageError: (page, error) {
              debugPrint('$page: ${error.toString()}');
            },
            onPageChanged: (page, total) {
              pngProvider.setPdfPageNo = page == null ? 1 : page;
            },
          ),
        ),
        if (pngProvider.getExportedSignature != null)
          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                _position += details.delta;

                if (_position.dx < 0) {
                  _position = Offset(0, _position.dy);
                } else if (_position.dx > screenWidth - (200 * _scale)
                    // _position.dx + (200 * _scale) > screenWidth
                    ) {
                  _position =
                      Offset(screenWidth - (200 * _scale), _position.dy);

                  debugPrint(_position.dx.toString());

                  // _position = Offset(screenWidth - 200, _position.dy);
                }

                if (_position.dy < 0) {
                  _position = Offset(_position.dx, 0);
                } else if (_position.dy > screenHeight - (200 * _scale)) {
                  _position =
                      Offset(_position.dx, screenHeight - (200 * _scale));

                  debugPrint(_position.dy.toString());
                  // _position = Offset(_position.dx, screenHeight - 200);
                }

                pngProvider.setSignaturePosition = _position;
                setState(() {});
              },
              child: Stack(
                children: [
                  Container(
                    // height: _height,
                    // width: _width,
                    width: 200 * _scale,
                    height: 200 * _scale,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(),
                    ),
                    child: Image.memory(
                      pngProvider.getExportedSignature!,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: GestureDetector(
                        onScaleStart: (ScaleStartDetails details) {
                          _previousOffset = details.focalPoint;
                        },
                        onScaleUpdate: (ScaleUpdateDetails details) {
                          Offset currentOffset = details.focalPoint;
                          double dx = currentOffset.dx - _previousOffset.dx;
                          double dy = currentOffset.dy - _previousOffset.dy;

                          setState(() {
                            if (dx.abs() > dy.abs()) {
                              if (dx > 0) {
                                _scale += 0.01; // Decrease scale
                              } else {
                                _scale -= 0.01; // Increase scale
                              }
                            } else {
                              if (dy > 0) {
                                _scale += 0.01; // Decrease scale
                              } else {
                                _scale -= 0.01; // Increase scale
                              }
                            }

                            _scale = _scale.clamp(0.5, 2.0);

                            pngProvider.setSignHeight = 200 * _scale;
                            pngProvider.setSignWidth = 200 * _scale;

                            if ((_scale > 0.5) && (_scale < 2.0)) {
                              // _position = details.focalPoint;
                              debugPrint(details.localFocalPoint.dx.toString());
                              debugPrint(details.focalPoint.dy.toString());
                              debugPrint(_scale.toString());
                            }
                          });
                        },
                        child: Container(
                          constraints: const BoxConstraints(
                              minHeight: 16,
                              maxHeight: 24,
                              minWidth: 16,
                              maxWidth: 24),
                          child:
                              const Icon(Icons.open_in_full_rounded, size: 20),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        pngProvider.clearSignatureDetails();
                      },
                      child: Container(
                        constraints: const BoxConstraints(
                            minHeight: 16,
                            maxHeight: 24,
                            minWidth: 16,
                            maxWidth: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.kPrimaryColors,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}


/*

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:signature_app/configs/app_colors.dart';

import '../../../provider/signature_provider.dart';

// import 'package:pdf/pdf.dart';

class PdfViewerViewBody extends StatefulWidget {
  File pdfFile;
  PdfViewerViewBody({required this.pdfFile, super.key});

  @override
  State<PdfViewerViewBody> createState() => _PdfViewerViewBodyState();
}

class _PdfViewerViewBodyState extends State<PdfViewerViewBody> {
  Offset _position = const Offset(0, 0);
  double _scale = 1.0;
  Offset _previousOffset = const Offset(0, 0);

  bool isSignatureFocused = false;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    final pngProvider = Provider.of<SignatureProvider>(context);

    return Stack(
      children: [
        PDFView(
          filePath: widget.pdfFile.path,
          onError: (error) {
            debugPrint(error.toString());
          },
          onPageError: (page, error) {
            debugPrint('$page: ${error.toString()}');
          },
          onPageChanged: (page, total) {
            pngProvider.setPdfPageNo = page == null ? 1 : page;
          },
        ),
        if (pngProvider.getExportedSignature != null)
          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                _position += details.delta;

                if (_position.dx < 0) {
                  _position = Offset(0, _position.dy);
                } else if (_position.dx > screenWidth - (200 * _scale)
                    // _position.dx + (200 * _scale) > screenWidth
                    ) {
                  _position =
                      Offset(screenWidth - (200 * _scale), _position.dy);

                  // _position = Offset(screenWidth - 200, _position.dy);
                }

                if (_position.dy < 0) {
                  _position = Offset(_position.dx, 0);
                } else if (_position.dy > screenHeight - (200 * _scale)) {
                  _position =
                      Offset(_position.dx, screenHeight - (200 * _scale));
                  // _position = Offset(_position.dx, screenHeight - 200);
                }

                pngProvider.setSignaturePosition = _position;
                setState(() {});
              },
              child: Stack(
                children: [
                  Container(
                    // height: _height,
                    // width: _width,
                    width: 200 * _scale,
                    height: 200 * _scale,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(),
                    ),
                    child: Image.memory(
                      pngProvider.getExportedSignature!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: GestureDetector(
                        onScaleStart: (ScaleStartDetails details) {
                          _previousOffset = details.focalPoint;
                        },
                        onScaleUpdate: (ScaleUpdateDetails details) {
                          Offset currentOffset = details.focalPoint;
                          double dx = currentOffset.dx - _previousOffset.dx;
                          double dy = currentOffset.dy - _previousOffset.dy;

                          setState(() {
                            if (dx.abs() > dy.abs()) {
                              if (dx > 0) {
                                _scale += 0.01; // Decrease scale
                              } else {
                                _scale -= 0.01; // Increase scale
                              }
                            } else {
                              if (dy > 0) {
                                _scale += 0.01; // Decrease scale
                              } else {
                                _scale -= 0.01; // Increase scale
                              }
                            }

                            _scale = _scale.clamp(0.5, 2.0);

                            pngProvider.setSignHeight = 200 * _scale;
                            pngProvider.setSignWidth = 200 * _scale;

                            if ((_scale > 0.5) && (_scale < 2.0)) {
                              // _position = details.focalPoint;
                              debugPrint(details.localFocalPoint.dx.toString());
                              debugPrint(details.focalPoint.dy.toString());
                              debugPrint(_scale.toString());
                            }
                          });
                        },
                        child: Container(
                          constraints: const BoxConstraints(
                              minHeight: 16,
                              maxHeight: 24,
                              minWidth: 16,
                              maxWidth: 24),
                          child:
                              const Icon(Icons.open_in_full_rounded, size: 20),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        pngProvider.clearSignatureDetails();
                      },
                      child: Container(
                        constraints: const BoxConstraints(
                            minHeight: 16,
                            maxHeight: 24,
                            minWidth: 16,
                            maxWidth: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.kPrimaryColors,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}


 */