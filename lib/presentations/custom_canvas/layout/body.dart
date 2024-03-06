import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature_app/elements/alert_dialogue.dart';
import 'package:signature_app/elements/sizes.dart';
import 'package:signature_app/presentations/custom_canvas/layout/signature_painter.dart';
import 'package:signature_app/provider/signature_provider.dart';

class CustomCanvasViewBody extends StatefulWidget {
  const CustomCanvasViewBody({super.key});

  @override
  State<CustomCanvasViewBody> createState() => _CustomCanvasBodyState();
}

class _CustomCanvasBodyState extends State<CustomCanvasViewBody> {
  List<List<Offset?>> _signaturePoints = [];
  double initialVal = 17.0;

  bool colorIconCheck = false;
  bool strokeIconCheck = false;

  double selectedStroke = 1;
  Color selectedColor = Colors.black;

  double _scale = 1.0;

  late SignaturePainter painter;

  @override
  void initState() {
    super.initState();
    painter = SignaturePainter(
      _signaturePoints,
      selectedColor,
      selectedStroke,
    );
  }

  Offset _position = const Offset(0, 0);

  Offset _previousOffset = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    final pngProvider = Provider.of<SignatureProvider>(context);
    return Stack(
      children: [
        CustomPaint(
          painter:
              SignaturePainter(_signaturePoints, selectedColor, selectedStroke),
          child: GestureDetector(onPanStart: (details) {
            if (_signaturePoints.isNotEmpty) {
              _signaturePoints.last.add(details.localPosition);
            } else {
              _signaturePoints.add([details.localPosition]);
            }

            setState(() {});
          }, onPanUpdate: (details) {
            if (_signaturePoints.isNotEmpty) {
              _signaturePoints.last.add(details.localPosition);
            } else {
              _signaturePoints.add([details.localPosition]);
            }

            setState(() {});
          }, onPanEnd: (details) {
            _signaturePoints.last.add(null);
          }),

          // ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            color: Colors.transparent,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getSignatureWidget(Icons.arrow_back_ios, Colors.white, () {
                  Navigator.of(context).pop();
                }, 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    getSignatureWidget(
                      colorIconCheck ? Icons.palette : Icons.palette_outlined,
                      Colors.white,
                      () {
                        setState(() {
                          if (strokeIconCheck) {
                            strokeIconCheck = false;
                          }
                          colorIconCheck = !colorIconCheck;
                        });
                      },
                    ),
                    10.widthBox,
                    getSignatureWidget(
                      strokeIconCheck ? Icons.brush : Icons.brush_outlined,
                      Colors.white,
                      () {
                        setState(() {
                          if (colorIconCheck) {
                            colorIconCheck = false;
                          }
                          strokeIconCheck = !strokeIconCheck;
                        });
                      },
                    ),
                    10.widthBox,
                    getSignatureWidget(Icons.delete_outlined, Colors.white, () {
                      //clearing the canvas
                      setState(() {
                        _signaturePoints.clear();
                        pngProvider.clearExportedImage();
                      });
                    }),
                    10.widthBox,
                    getSignatureWidget(Icons.ios_share, Colors.white, () async {
                      if (_signaturePoints.isNotEmpty) {
                        showErrorDialogue(context,
                            message:
                                "Are you sure, you want to export the signature?",
                            onPressedNo: () {
                          Navigator.of(context).pop();
                        }, onPressedYes: () async {
                          await pngProvider
                              .exportCanvasToImage(context, _signaturePoints,
                                  selectedColor, selectedStroke)
                              .then((_) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          });
                          // await exportCanvasToImage()
                          //     .then((_) => Navigator.of(context).pop());
                          // setState(() {});
                        });
                      }
                    })
                  ],
                ),
              ],
            ),
          ),
        ),
        // if (pngProvider.getExportedSignature != null)
        //   Positioned(
        //     left: _position.dx,
        //     top: _position.dy,
        //     child: GestureDetector(
        //       onPanUpdate: (details) {
        //         _position += details.delta;

        //         if (_position.dx < 0) {
        //           _position = Offset(0, _position.dy);
        //         } else if (_position.dx > screenWidth - 200) {
        //           _position = Offset(screenWidth - 200, _position.dy);
        //         }

        //         if (_position.dy < 0) {
        //           _position = Offset(_position.dx, 0);
        //         } else if (_position.dy > screenHeight - 200) {
        //           _position = Offset(_position.dx, screenHeight - 200);
        //         }
        //         setState(() {});
        //       },
        //       child: Stack(
        //         children: [
        //           Container(
        //             // height: _height,
        //             // width: _width,
        //             width: 200 * _scale,
        //             height: 200 * _scale,
        //             color: Colors.red,
        //             child: Image.memory(
        //               pngProvider.getExportedSignature!,
        //               fit: BoxFit.contain,
        //             ),
        //           ),
        //           Positioned(
        //             bottom: 10,
        //             right: 10,
        //             child: RotatedBox(
        //                 quarterTurns: 3,
        //                 child: GestureDetector(
        //                     onScaleStart: (ScaleStartDetails details) {
        //                       _previousOffset = details.focalPoint;
        //                     },
        //                     onScaleUpdate: (ScaleUpdateDetails details) {
        //                       Offset currentOffset = details.focalPoint;
        //                       double dx = currentOffset.dx - _previousOffset.dx;
        //                       double dy = currentOffset.dy - _previousOffset.dy;

        //                       setState(() {
        //                         if (dx.abs() > dy.abs()) {
        //                           if (dx > 0) {
        //                             _scale += 0.01; // Decrease scale
        //                           } else {
        //                             _scale -= 0.01; // Increase scale
        //                           }
        //                         } else {
        //                           if (dy > 0) {
        //                             _scale += 0.01; // Decrease scale
        //                           } else {
        //                             _scale -= 0.01; // Increase scale
        //                           }
        //                         }

        //                         _scale = _scale.clamp(0.5, 2.0);
        //                       });
        //                     },
        //                     child: Container(
        //                         color: Colors.blue,
        //                         constraints: const BoxConstraints(
        //                             minHeight: 16,
        //                             maxHeight: 24,
        //                             minWidth: 16,
        //                             maxWidth: 24),
        //                         child:
        //                             const Icon(Icons.open_in_full_rounded)))),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        if (colorIconCheck)
          Container(
            child: RotatedBox(
              quarterTurns: 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 250,
                    height: Colors.primaries.length.toDouble(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: Colors.primaries,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Slider(
                      value: initialVal,
                      onChanged: (value) {
                        setState(() {
                          initialVal = value;
                          selectedColor = value == 17
                              ? Colors.black
                              : Colors.primaries[value.toInt()];
                        });
                      },
                      min: 0,
                      max: Colors.primaries.length.toDouble() - 1,
                      activeColor: Colors.transparent,
                      inactiveColor: Colors.transparent,
                      thumbColor: Colors.white,
                      allowedInteraction: SliderInteraction.tapAndSlide,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (strokeIconCheck)
          Container(
            child: RotatedBox(
              quarterTurns: 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 250,
                    height: Colors.primaries.length.toDouble(),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            topRight: Radius.circular(100))),
                    child: Slider(
                      value: selectedStroke,
                      onChanged: (value) {
                        setState(() {
                          selectedStroke = value;
                        });
                      },
                      min: 1,
                      max: 20.0,
                      activeColor: Colors.transparent,
                      inactiveColor: Colors.transparent,
                      thumbColor: Colors.white,
                      allowedInteraction: SliderInteraction.tapAndSlide,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget getSignatureWidget(
    IconData icon,
    Color iconColor,
    Function onIconPressed, [
    double? iconSize,
  ]) {
    return GestureDetector(
      onTap: () {
        onIconPressed();
      },
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.black54,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
