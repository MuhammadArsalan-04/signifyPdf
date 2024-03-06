import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature_app/configs/theme.dart';
import 'package:signature_app/presentations/homescreen/home_screen.dart';
import 'package:signature_app/presentations/pdf_viewer/pdf_viewer.dart';
import 'package:signature_app/provider/cache_files_provider.dart';
import 'package:signature_app/provider/signature_provider.dart';
import 'presentations/custom_canvas/custom_canvas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: SignatureProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CacheFileProvider(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getCustomTheme(),
        home: const HomeScreenView(),
        routes: {
          PdfViewerView.routeName: (context) => const PdfViewerView(),
        },
      ),
    );
  }
}
