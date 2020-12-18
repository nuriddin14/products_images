import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AppUtils {
  static Future<String> getFolderPath(String folderName) async {
    Directory dir = await getExternalStorageDirectory();

    File file = File('${dir.path}/$folderName');

    bool isFolderExist = await Directory(file.path).exists();
    if (isFolderExist) {
      return file.path;
    } else {
      Directory newFolder = await new Directory(file.path).create();
      return newFolder.path;
    }
  }

  static Future<String> getFilePath({
    @required String fileName,
    @required String folderName,
  }) async {
    String folderPath = await getFolderPath(folderName);
    File file = File('$folderPath/$fileName.jpg');
    if (file.existsSync()) {
      return file.path;
    }

    return '';
  }

  static Future<File> getFile(
      {@required String fileName, @required String folderName}) async {
    String folderPath = await getFolderPath(folderName);
    File file = File('$folderPath/$fileName.jpg');
    if (file.existsSync()) {
      return file;
    }

    return null;
  }

  static List<DropdownMenuItem<int>> convertListToMenuItem(List list) {
    return list
        .map((saleType) => DropdownMenuItem<int>(
              child: Text(
                saleType.name,
                textWidthBasis: TextWidthBasis.longestLine,
              ),
              value: saleType.id,
            ))
        .toList();
  }
}
