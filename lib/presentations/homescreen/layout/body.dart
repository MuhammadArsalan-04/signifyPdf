import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:signature_app/configs/app_colors.dart';
import 'package:signature_app/configs/res.dart';
import 'package:signature_app/elements/custom_text.dart';
import 'package:signature_app/elements/sizes.dart';
import 'package:signature_app/presentations/pdf_viewer/pdf_viewer.dart';
import 'package:signature_app/provider/cache_files_provider.dart';

class HomeScreenViewBody extends StatefulWidget {
  HomeScreenViewBody({super.key});

  @override
  State<HomeScreenViewBody> createState() => _HomeScreenViewBodyState();
}

class _HomeScreenViewBodyState extends State<HomeScreenViewBody> {
  TextEditingController _searchController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      await Provider.of<CacheFileProvider>(context, listen: false)
          .getAndFetchCachedFiles;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerRef = Provider.of<CacheFileProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                Res.kSplashImage,
                scale: 4,
              ),
            ),
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: "Search...",
                fillColor: Colors.grey.shade200,
                filled: true,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            CustomText(
              text: "Files",
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            20.heightBox,
            if (isLoading) ...[
              200.heightBox,
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.kPrimaryColors,
                ),
              )
            ],
            if (!isLoading &&
                (providerRef.getCachedFiles == null ||
                    providerRef.getCachedFiles.isEmpty)) ...[
              200.heightBox,
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Res.kFolder,
                      scale: 2,
                    ),
                    CustomText(
                      text: "      No Files Added",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
              ),
            ],
            if (providerRef.getCachedFiles.isNotEmpty)
              ...providerRef.getCachedFiles.map(
                (e) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(PdfViewerView.routeName,
                          arguments: File(e.path));
                    },
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 44,
                              width: 44,
                              child: Image.asset(Res.kPdf),
                            ),
                            10.widthBox,
                            Expanded(
                              child: CustomText(
                                text: (path.basename(e!.path)).substring(
                                    0, (path.basename(e.path).length - 4)),
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                        const Divider()
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
