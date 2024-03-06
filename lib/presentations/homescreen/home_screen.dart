import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart' as dir;
import 'package:provider/provider.dart';
import 'package:signature_app/elements/toast_message.dart';
import 'package:signature_app/presentations/homescreen/layout/body.dart';
import 'package:signature_app/presentations/pdf_viewer/pdf_viewer.dart';
import 'package:signature_app/provider/cache_files_provider.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  late FToast toast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowedExtensions: ['pdf'],
              type: FileType.custom,
            );

            if (result != null) {
              File file = File(result.files.single.path!);

              await Navigator.of(context).pushNamed(
                PdfViewerView.routeName,
                arguments: file,
              );

              Provider.of<CacheFileProvider>(context, listen: false)
                  .saveFileToCache(file.path);
            } else {
              // User canceled the picker
              getToastMessage(toast, "No file selected");
            }

            // debugPrint(
            // (await dir.getApplicationDocumentsDirectory()).toString());
            // debugPrint((await dir.getTemporaryDirectory()).toString());
            // debugPrint((await dir.getDownloadsDirectory()).toString());

            // debugPrint((await dir.getApplicationSupportDirectory()).toString());
            // debugPrint((await dir.getExternalStorageDirectory()).toString());
            // debugPrint((await dir.getLibraryDirectory()).toString());
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: SafeArea(
        child: HomeScreenViewBody(),
      ),
    );
  }
}
