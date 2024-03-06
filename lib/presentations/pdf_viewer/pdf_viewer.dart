import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:signature_app/elements/custom_text.dart';
import 'package:signature_app/presentations/custom_canvas/custom_canvas.dart';
import 'package:signature_app/presentations/custom_canvas/layout/signature_painter.dart';
import 'package:signature_app/presentations/pdf_viewer/layout/body.dart';

import 'package:path/path.dart' as path;
import 'package:signature_app/provider/pdf_saver_provider.dart';
import 'package:signature_app/provider/signature_provider.dart';

class PdfViewerView extends StatelessWidget {
  const PdfViewerView({super.key});
  static const routeName = 'pdf-viewer';
  @override
  Widget build(BuildContext context) {
    final File pdfFile = ModalRoute.of(context)!.settings.arguments as File;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon:
                Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back)),
        centerTitle: false,
        title: CustomText(
          text:
              // ignore: unnecessary_string_interpolations
              "${path.basename(pdfFile.path.substring(0, pdfFile.path.length - 4))}",
          textColor: Colors.white,
          fontSize: 20,
        ),
        actions: [
          IconButton(
            onPressed: Provider.of<SignatureProvider>(context, listen: true)
                        .getExportedSignature ==
                    null
                ? null
                : () async {
                    debugPrint("pressed");
                    final signProvider =
                        Provider.of<SignatureProvider>(context, listen: false);

                    if (signProvider.getExportedSignature != null &&
                        signProvider.getPdfPageNo != null &&
                        signProvider.getSignHeight != null &&
                        signProvider.getSignWidth != null) {
                      debugPrint("i am in");
                      await PdfSaverProvider.saveEditedPdf(
                              signProvider.getExportedSignature!,
                              pdfFile,
                              signProvider.getPdfPageNo!,
                              signProvider.getSignWidth!,
                              signProvider.getSignHeight!,
                              signProvider.getSignaturePosition,
                              signProvider.getSize)
                          .then(
                        (value) => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => PDFView(
                              filePath: value,
                              autoSpacing: true,
                            ),
                          ),
                        ),
                      );
                    }
                  },
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: PdfViewerViewBody(
          pdfFile: pdfFile,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CustomCanvasView(),
          ));
          // showModalBottomSheet(
          //   context: context,
          //   builder: (context) {
          //     return StatefulBuilder(
          //       builder: (context, setState) {
          //         return Container(
          //           height: 200,
          //           child: Scaffold(
          //             body: CustomPaint(
          //               painter: SignaturePainter([
          //                 [Offset(10, 10), Offset(80, 80)]
          //               ], Colors.black, 5),
          //             ),
          //           ),
          //         );
          //       },
          //     );
          //   },
          // );
        },
        tooltip: "Signature",
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }
}
