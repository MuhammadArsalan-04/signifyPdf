import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class CacheFileProvider with ChangeNotifier {
  final CacheManager _cacheManager = CacheManager(
    Config(
      "fileKey",
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 30,
      repo: JsonCacheInfoRepository(
        databaseName: "signifyPdfDatabase",
      ),
      fileService: HttpFileService(),
    ),
  );

  List<File?> _cachedFiles = [];

  int _filecount = 0;
  Future<void> saveFileToCache(String filePath) async {
    //code here

    _filecount++;

    await _cacheManager
        .putFile(
      _filecount.toString(),
      File(filePath).readAsBytesSync(),
      // ,
      fileExtension: "pdf",
      maxAge: const Duration(days: 10),
      eTag: _filecount.toString(),
    )
        .then(
      (file) async {
        _cachedFiles.add(file);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("fileLength", _filecount);
        notifyListeners();
      },
    );
  }

  Future<void> get getAndFetchCachedFiles async {
    _cachedFiles = [];

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? totalFiles = prefs.getInt("fileLength");

    if (totalFiles != null) {
      _filecount = totalFiles;
      for (var i = 0; i < totalFiles; i++) {
        String key = (i + 1).toString();
        File fetchedFile = await _cacheManager.getSingleFile(key);
        _cachedFiles.add(fetchedFile);
        debugPrint("---");
      }

      notifyListeners();
    } else {
      _cachedFiles = [];
      notifyListeners();
    }
  }

  List<File?> get getCachedFiles {
    return _cachedFiles;
  }
}
